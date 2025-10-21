Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0824B27381E;
	Tue, 21 Oct 2025 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076473; cv=none; b=QokSvITkLLaMKyUJ7h+sRrar310NVOgxspniYI+bFdjfi0UQdvQoYYhYVnK9D1MLjadbWuOAlUHRyMMHCFkff5lOSYC7kRqZBQKUyhxo3grNq6jKQfVs/clggBUzIdHmqyGH3sRwFq/CkMbAX5jbS8Ay5rX4FX0x4CKizPjrnLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076473; c=relaxed/simple;
	bh=zItiAPnLFn2D/8sJ78U9kIef9t3LU6apDza5EykgEKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY3MeBmT4KPW1faATl9goqOtLuGSrinKL0SKewC+uhGG0ICPUBmGoHb19t0FqRBJAnmhVxnjdm2OSmnWWAuIuiEFM9mq5Jn/GwmDgS5I9p03iXmNn8+q8JPgCc/4FL8/Fr5Vn7no8PNplb1sq1LopYulQWw19ydNDmMrfPkb1KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWUdfQlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWUdfQlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1A0C4CEF1;
	Tue, 21 Oct 2025 19:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076472;
	bh=zItiAPnLFn2D/8sJ78U9kIef9t3LU6apDza5EykgEKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWUdfQlQ9vAQKXVUXQRuq1k6Fhro57lW5pbAQd4HLVpRcstiVKh9U5K23GzKRMngn
	 xS9rcgPrpWYeLfGlsFu7simSTPykEV2CPRpgJdKuTpxFPUJEvvVQwftBC9fPY/QYWi
	 BPvFB2GMj6h4YKxHhqKHr3lztjN+imxhbKnqyqbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/105] tls: trim encrypted message to match the plaintext on short splice
Date: Tue, 21 Oct 2025 21:50:53 +0200
Message-ID: <20251021195022.733476682@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit ce5af41e3234425a40974696682163edfd21128c ]

During tls_sw_sendmsg_locked, we pre-allocate the encrypted message
for the size we're expecting to send during the current iteration, but
we may end up sending less, for example when splicing: if we're
getting the data from small fragments of memory, we may fill up all
the slots in the skmsg with less data than expected.

In this case, we need to trim the encrypted message to only the length
we actually need, to avoid pushing uninitialized bytes down the
underlying TCP socket.

Fixes: fe1e81d4f73b ("tls/sw: Support MSG_SPLICE_PAGES")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/66a0ae99c9efc15f88e9e56c1f58f902f442ce86.1760432043.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 435235a351e2f..21276ac1f81dc 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1112,8 +1112,11 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 				goto send_end;
 			tls_ctx->pending_open_record_frags = true;
 
-			if (sk_msg_full(msg_pl))
+			if (sk_msg_full(msg_pl)) {
 				full_record = true;
+				sk_msg_trim(sk, msg_en,
+					    msg_pl->sg.size + prot->overhead_size);
+			}
 
 			if (full_record || eor)
 				goto copied;
-- 
2.51.0



