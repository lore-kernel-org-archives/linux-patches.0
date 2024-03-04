Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBBC8F58;
	Mon,  4 Mar 2024 21:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588263; cv=none; b=N/nJZ7RsIYfuFfg9gg7nF3AewLknqDSGUY3iOczUlvmvLMfaGEGrqqkEMlpEf9lU4vAihKZoTUohWrE2ehiUTJWoPFrYKGS9A17BVP3X1dwOIfpzcGeQpSamrJdVln+wv4/FGu0agaaZZJ8qA3dnSEsJS2422TgjsnuZvBVA3lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588263; c=relaxed/simple;
	bh=sQTy1R2BN9Tw+XZda3Js2NMe23eES6EaR+22ztkDgX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raCprc9B/6qASfv/cMM0cudyTxBWvJPWQdkS1EnD1p3ZxTyR9uOfpWOp/yIM8kyZQGgJgbOveQniwkG/qMj5m+A8qxJylLYrpyvNkp9n4938Mvu5Ll24d2C77Dsjz27U080bztBu/pjFpoVMUWFXVbqR/nXjt6/iFT2GNU3MCZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmnpAGTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmnpAGTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176A2C433F1;
	Mon,  4 Mar 2024 21:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588263;
	bh=sQTy1R2BN9Tw+XZda3Js2NMe23eES6EaR+22ztkDgX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmnpAGTNOOAEtUCsy6qMmH+f0+8yYjBiBb4tEXxnqQSch3c1ynx9QMEn7CfyYqkON
	 FbidnRfyAnYvbMUf3/hcyuhgbR9JnaPcTWPMXpYOCiMEG2YHCw3kBvB0QOKmRLiwlO
	 pwbKJjKoDamEQ4FUUszl1fk5ad5w4oz2oglCKTqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/143] tls: separate no-async decryption request handling from async
Date: Mon,  4 Mar 2024 21:22:40 +0000
Message-ID: <20240304211551.222446586@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 41532b785e9d79636b3815a64ddf6a096647d011 ]

If we're not doing async, the handling is much simpler. There's no
reference counting, we just need to wait for the completion to wake us
up and return its result.

We should preferably also use a separate crypto_wait. I'm not seeing a
UAF as I did in the past, I think aec7961916f3 ("tls: fix race between
async notify and socket close") took care of it.

This will make the next fix easier.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/47bde5f649707610eaef9f0d679519966fc31061.1709132643.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 13114dc55430 ("tls: fix use-after-free on failed backlog decryption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0af2a698c3d08..733dbae9b057c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -274,9 +274,15 @@ static int tls_do_decryption(struct sock *sk,
 		DEBUG_NET_WARN_ON_ONCE(atomic_read(&ctx->decrypt_pending) < 1);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
+		DECLARE_CRYPTO_WAIT(wait);
+
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  crypto_req_done, &ctx->async_wait);
+					  crypto_req_done, &wait);
+		ret = crypto_aead_decrypt(aead_req);
+		if (ret == -EINPROGRESS || ret == -EBUSY)
+			ret = crypto_wait_req(ret, &wait);
+		return ret;
 	}
 
 	ret = crypto_aead_decrypt(aead_req);
@@ -285,10 +291,7 @@ static int tls_do_decryption(struct sock *sk,
 		ret = ret ?: -EINPROGRESS;
 	}
 	if (ret == -EINPROGRESS) {
-		if (darg->async)
-			return 0;
-
-		ret = crypto_wait_req(ret, &ctx->async_wait);
+		return 0;
 	} else if (darg->async) {
 		atomic_dec(&ctx->decrypt_pending);
 	}
-- 
2.43.0



