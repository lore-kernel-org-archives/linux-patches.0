Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5665111CBA;
	Tue, 17 Jun 2025 15:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174271; cv=none; b=LIlnLSCCg7E1qsL/EBZBlE6iRX7R8zJcD+OSYDvHRXE/d/PpmHpcELH4Hsa07nSk++xAIGoOslMNrmuKI0f/nJqy1pXZ63nhXayPimk75AlSSuPWpJtZFDXp4ga8iCBuqjXs7W9SGGAYhSxQpI2etf3BygEycmrXu5IA7l8CzfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174271; c=relaxed/simple;
	bh=CvdF3J/SsBl8So+Rnlmzy3d0b3OXPUn0dKWcXOyZxkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGWe5F0PIFSg7zuZ6j7RnmoCLes0BTyF+sYGD1Bkfk9PpmvrkgJYKuM187NuegDreJBNApPEZGDJxc2y2IF9umLNrAtxZriI+Gr9tbk9k/P65AAmpfqA8zQZd0Uw3wNUMNb6rXzw0lmLd/a/JMOtKWCnkkyESeEnRkg0Em/9h2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfC5nmnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfC5nmnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD87AC4CEE3;
	Tue, 17 Jun 2025 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174271;
	bh=CvdF3J/SsBl8So+Rnlmzy3d0b3OXPUn0dKWcXOyZxkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfC5nmnHXKo366Xaz+KLdsA1Roamj6R0/rM+w/se0WkVoCZqDjanMfEw31cntIaWb
	 FebIiUrdcQJZo/KgzKBKTQb/S48wRJwe36MKJa2sgVqYMjN4SdWtnTfHG4iHiVYcCe
	 LzAWbb5MoSFBbdwSxs1/OeDE08QjCoMFX+OxVMH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/356] crypto: sun8i-ce - move fallback ahash_request to the end of the struct
Date: Tue, 17 Jun 2025 17:22:31 +0200
Message-ID: <20250617152339.673429289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit c822831b426307a6ca426621504d3c7f99765a39 ]

'struct ahash_request' has a flexible array at the end, so it must be the
last member in a struct, to avoid overwriting other struct members.

Therefore, move 'fallback_req' to the end of the 'sun8i_ce_hash_reqctx'
struct.

Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 93d4985def87a..65cc1278ee155 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -293,8 +293,8 @@ struct sun8i_ce_hash_tfm_ctx {
  * @flow:	the flow to use for this request
  */
 struct sun8i_ce_hash_reqctx {
-	struct ahash_request fallback_req;
 	int flow;
+	struct ahash_request fallback_req; // keep at the end
 };
 
 /*
-- 
2.39.5



