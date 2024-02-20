Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A7814C585;
	Tue, 20 Feb 2024 21:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463299; cv=none; b=DSh0EAWzbPGkxDSLJcPqz5veIdoPG7DZBM0DVFOR2lu1BO0uhSU/XT5BJZktWoGtWM46zTCWbOR4P2J2JL47jP2Dg1kqlLcQibET3CYtLLftl97+czn1yV5hI9jZn07QB/VpzBmj7lTV+TD67oOBHWLSNHtVigjKvgsRf3c6ZIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463299; c=relaxed/simple;
	bh=607HFVFo63nhmmtupghcKGnSDAfENQSaPqzDsYj11LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yi7k9MOqp6yz8PdVbAol1BbRLxhhquhSEZT7KWttcUWqrG3T+LjEspcPmlQIALSFHEIg1t5h0lB6m1iJHdM3p0k6H924OzKNOZE2ocXqznFmUhZnUn6e4LkfWADrRa/b+90p0uO2j7Oc7vbDFsSdgJ7oV1MSvKVn67V9EmMOjas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnrDQfr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnrDQfr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259F3C433C7;
	Tue, 20 Feb 2024 21:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463299;
	bh=607HFVFo63nhmmtupghcKGnSDAfENQSaPqzDsYj11LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnrDQfr85tWkBh5cGiahgUUBUIioZYptBnD2XKPzmyknZONHfEE53Cthxj1z8N6kM
	 deih/mZjk9bJbNv5Ae2cxnBcOYJqjeq4ANesXzYNM5mSLy5IuOZ1lQtLv09jFeBRQp
	 sjBtTALGwSek9S3vYrsX81Nn015QXtwJRYBdul/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+40d43509a099ea756317@syzkaller.appspotmail.com,
	Jann Horn <jannh@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 169/197] tls: fix NULL deref on tls_sw_splice_eof() with empty record
Date: Tue, 20 Feb 2024 21:52:08 +0100
Message-ID: <20240220204846.128021804@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/tls/tls_sw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1179,11 +1179,14 @@ void tls_sw_splice_eof(struct socket *so
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


