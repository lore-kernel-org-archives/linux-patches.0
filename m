Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE97831A06A;
	Mon, 27 Oct 2025 19:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592317; cv=none; b=XrdZMQcN84P/2ACdg/tudIWt6PWDJ80/AkP7R+8AjofssnDYCPEmy+IHQk4QfDArEjdzXKatqwxZRoIT3p1GOkIUjiwwtEzgrE+CTTY3YJOXX/aQR33BCpGQtBg3NQ2mrVcJ4GZJAgTg2TMaz9c6a5/B/qCtLjENkasUTlOVlaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592317; c=relaxed/simple;
	bh=cMwu6LCZ5fxrnHhNhydA2Wv5qRKu/VyRU+w0El3uzEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdqe8oT8c1/95ZfevOvYmnY0oFgwt1iOG83MsdRMAxxUSkU54Ah1l3ykJx7BZB05A+Tq9cI997Q/ku5W6t31JAz9nn1ziZpMuHYcmMiCZye6MfKuaHiPqMqhKvW6j/PJydatn386ElOCStugNz8poOhAPZrbpfKDm1UQNnOktjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fo9lH2av; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fo9lH2av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A09C4CEF1;
	Mon, 27 Oct 2025 19:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592317;
	bh=cMwu6LCZ5fxrnHhNhydA2Wv5qRKu/VyRU+w0El3uzEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fo9lH2av5fBubqx3yfhqAK+fumHXH9uxQbJ+3tpDiO3DFyqqEGjHrdf43y2ufjQBg
	 5hYT7RCKirEgwQpTJ4+kEIb0xvR92rPKoXbBP3gC/mJ5HGsXlKyiCB8AkLTReggbyV
	 x59b2HU7lr3Ec+B+4HEPtUxoBRuuw4DHFWqDQOFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/157] tls: wait for pending async decryptions if tls_strp_msg_hold fails
Date: Mon, 27 Oct 2025 19:35:09 +0100
Message-ID: <20251027183502.582185242@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b8a6ff84abbcbbc445463de58704686011edc8e1 ]

Async decryption calls tls_strp_msg_hold to create a clone of the
input skb to hold references to the memory it uses. If we fail to
allocate that clone, proceeding with async decryption can lead to
various issues (UAF on the skb, writing into userspace memory after
the recv() call has returned).

In this case, wait for all pending decryption requests.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/b9fe61dcc07dab15da9b35cf4c7d86382a98caf2.1760432043.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0e378d7cb6903..baed07edc6395 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1724,8 +1724,10 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 
 	if (unlikely(darg->async)) {
 		err = tls_strp_msg_hold(&ctx->strp, &ctx->async_hold);
-		if (err)
-			__skb_queue_tail(&ctx->async_hold, darg->skb);
+		if (err) {
+			err = tls_decrypt_async_wait(ctx);
+			darg->async = false;
+		}
 		return err;
 	}
 
-- 
2.51.0



