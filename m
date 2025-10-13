Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A77D30AABF;
	Mon, 13 Oct 2025 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369515; cv=none; b=SM5LieCOmTnvQuIRTP1s7MNajjruaUvi4opsuN0B+YppfqX+sVOuqIassBs5o6XN9sJPvDypPl9AZ/sVh81N66QfxXvfVfX9YUYskC+CXyAWqE6Wf9NS0auN19v9beuVceJVtleE3jODjjYbo6SamRXP/em1+yKy+7fb15qQesw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369515; c=relaxed/simple;
	bh=24IvCLT9gB4r3TlAvUo6rhILSoUoxD8xpTjHyIkeECM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyaD4Q7/l/cK6C0tO0NA6/ZyBQtW63lrmWa9SUKjgNC/gMJvHajSI/GfDIQ88E57MWPT490/EVOSXFCMO299mYsNLaZOMzkbCEk4x8993bjjkZB80FtaCIeyLfj7FS6ezGQ3yep8PHMZe21/FNdUPhM6p0Q7nnWtBe5Ddf4z9PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IztZCLgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IztZCLgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA52BC4CEE7;
	Mon, 13 Oct 2025 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369515;
	bh=24IvCLT9gB4r3TlAvUo6rhILSoUoxD8xpTjHyIkeECM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IztZCLgLnGeF9z/xN4MXZuCzDcARH2QwkBC/VFuSi2D0qKBEyeteH0jQPKlkc8Smd
	 +PZniC8AjTdXA+jR+k45lGy0hAqkY1fhEVJKeZl0Ua2F90rzA2+/vjOdE86y85YVLT
	 rJ9D4sU6gx5rjwMux6Z91Vzl2VDjejPjmuulExdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 241/563] crypto: keembay - Add missing check after sg_nents_for_len()
Date: Mon, 13 Oct 2025 16:41:42 +0200
Message-ID: <20251013144420.016246341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 4e53be21dd0315c00eaf40cc8f8c0facd4d9a6b2 ]

sg_nents_for_len() returns an int which is negative in case of error.

Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index 8f9e21ced0fe1..48281d8822603 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -232,7 +232,7 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 	struct device *dev = rctx->hcu_dev->dev;
 	unsigned int remainder = 0;
 	unsigned int total;
-	size_t nents;
+	int nents;
 	size_t count;
 	int rc;
 	int i;
@@ -253,6 +253,9 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 	/* Determine the number of scatter gather list entries to process. */
 	nents = sg_nents_for_len(req->src, rctx->sg_data_total - remainder);
 
+	if (nents < 0)
+		return nents;
+
 	/* If there are entries to process, map them. */
 	if (nents) {
 		rctx->sg_dma_nents = dma_map_sg(dev, req->src, nents,
-- 
2.51.0



