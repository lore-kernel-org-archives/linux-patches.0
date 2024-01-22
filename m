Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3115BAFD;
	Tue, 23 Jan 2024 01:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974374; cv=none; b=FZs4HV/8IE6eeHQSHRNcwXmKnu6Te0nf8QSyUPRBhCTVP8r2ydHn6i1REnYGjLCD3cMNxLVZovISa+QaWb+EX099nGixmuR7uy5pq8KpgzUcKYkwVyTcX7maKMIUFhhKcuj0pXEOeLD1QSQL9BzUUA9kvOVbso/FlJf6Ptr7DFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974374; c=relaxed/simple;
	bh=xqBhWhFpgNEugVu7Q1fvNGG6jrJfT2gzDn9evWPbZh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUd2/3lGPOc8vCGQQXnX7u6Zmr5BjFWj7MUO+wKkzppLFIOGnmO7/z2S56INg6mobYw5X2QsqMxEEsR8p1uy9vpiA6I04rzbbLqxLVUsHnnuFXEZ6XnAwXhnCwUseWk2HpsB+B0ZxV+2kIgjpjK+1l/L/AV4C7/lSoJczsJuj1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BG+CD0mQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BG+CD0mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15ECFC433C7;
	Tue, 23 Jan 2024 01:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974374;
	bh=xqBhWhFpgNEugVu7Q1fvNGG6jrJfT2gzDn9evWPbZh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BG+CD0mQOmvvWlMiYtGQvpLxHolKycQFBFF5rQqKvD9GM6BSotkU2rfrdYZob8jG2
	 hBTxu5YYIY2jItsvUQ6Av+Sp8DYw7Z5KBJaEbGS5aTqYugaaU/wnRBp9ukq7eC6tUo
	 TE3XY4HXI39kkmPvIfCoZLkKWmovZCrLYzncrFbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/583] crypto: sahara - improve error handling in sahara_sha_process()
Date: Mon, 22 Jan 2024 15:52:02 -0800
Message-ID: <20240122235814.328227766@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit 5deff027fca49a1eb3b20359333cf2ae562a2343 ]

sahara_sha_hw_data_descriptor_create() returns negative error codes on
failure, so make sure the errors are correctly handled / propagated.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 86ff5add2e15..117aa4296c2a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -987,7 +987,10 @@ static int sahara_sha_process(struct ahash_request *req)
 		return ret;
 
 	if (rctx->first) {
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[0]->next = 0;
 		rctx->first = 0;
 	} else {
@@ -995,7 +998,10 @@ static int sahara_sha_process(struct ahash_request *req)
 
 		sahara_sha_hw_context_descriptor_create(dev, rctx, req, 0);
 		dev->hw_desc[0]->next = dev->hw_phys_desc[1];
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[1]->next = 0;
 	}
 
-- 
2.43.0



