Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EAB54FA8;
	Thu, 30 Nov 2023 16:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaTiRhKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920D7C433C7;
	Thu, 30 Nov 2023 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361552;
	bh=kag4vTvai0VnroRLRSRf9ysfCxrqkUO5n8gx5S86zUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaTiRhKqWXRE4WS+PXk9WsW8XvkNfD3PxIrwrHth9Pj4FPUgrk9ZX+LU4V3vuwMqL
	 Kp5tKi6fhCKUp7udOUa/5eY+wiY3yA3sLOdZCmG7BbDRK3cFoL9aW2q5dcZOU5+GUq
	 KtC/h8QI6npqZ3GnSZ+sqV5XPrwLQixir+czLDig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+40d43509a099ea756317@syzkaller.appspotmail.com,
	Jann Horn <jannh@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 068/112] tls: fix NULL deref on tls_sw_splice_eof() with empty record
Date: Thu, 30 Nov 2023 16:21:55 +0000
Message-ID: <20231130162142.481412522@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 53f2cb491b500897a619ff6abd72f565933760f0 upstream.

syzkaller discovered that if tls_sw_splice_eof() is executed as part of
sendfile() when the plaintext/ciphertext sk_msg are empty, the send path
gets confused because the empty ciphertext buffer does not have enough
space for the encryption overhead. This causes tls_push_record() to go on
the `split = true` path (which is only supposed to be used when interacting
with an attached BPF program), and then get further confused and hit the
tls_merge_open_record() path, which then assumes that there must be at
least one populated buffer element, leading to a NULL deref.

It is possible to have empty plaintext/ciphertext buffers if we previously
bailed from tls_sw_sendmsg_locked() via the tls_trim_both_msgs() path.
tls_sw_push_pending_record() already handles this case correctly; let's do
the same check in tls_sw_splice_eof().

Fixes: df720d288dbb ("tls/sw: Use splice_eof() to flush")
Cc: stable@vger.kernel.org
Reported-by: syzbot+40d43509a099ea756317@syzkaller.appspotmail.com
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20231122214447.675768-1-jannh@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index a78e8e722409..316f76187962 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1232,11 +1232,14 @@ void tls_sw_splice_eof(struct socket *sock)
 	lock_sock(sk);
 
 retry:
+	/* same checks as in tls_sw_push_pending_record() */
 	rec = ctx->open_rec;
 	if (!rec)
 		goto unlock;
 
 	msg_pl = &rec->msg_plaintext;
+	if (msg_pl->sg.size == 0)
+		goto unlock;
 
 	/* Check the BPF advisor and perform transmission. */
 	ret = bpf_exec_tx_verdict(msg_pl, sk, false, TLS_RECORD_TYPE_DATA,
-- 
2.43.0



