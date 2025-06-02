Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783DC17BB6;
	Mon,  2 Jun 2025 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876028; cv=none; b=ULyZXoMlSHi7fOc9uTRA/ptlljKJG+1NXCqORE7Zu8/vVDR1AYjh+bldkhyTymx8OqgOtHa0yR4zkB1G0s65wg7AuGYU0OjRsSUvtWZmpxBslWJajQZsRKV1+plxnwUaOicbMGhJKf55wgVjgO/7QnouhFq35k9If6WM2Z3YYzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876028; c=relaxed/simple;
	bh=RAloyMz/GKBAzUb1SsUD+Mqvb7z4qdwtVmej2bEGDtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VffKTxaJSP6qQZgMoS0lXJl+SIg1pahuot7xIx/UR8XNai5jySpBIW0vk1sEa/BaaLgs+Go97SV3OY8XiSp+stVtRjKIjwbTy+IOUTqmibVQ9bIGbs3xB7r7skGzekZGA2PMcEL/GxjxaOKtBJc6JQV0LuCev1SFWlvY7A/FILI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vS6AQ8FZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vS6AQ8FZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AA9C4CEEB;
	Mon,  2 Jun 2025 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876028;
	bh=RAloyMz/GKBAzUb1SsUD+Mqvb7z4qdwtVmej2bEGDtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vS6AQ8FZCtaEklh/Moa0VJLH8m1bv+4c8roqprltjKICBwBINY2SFfclMb327urYo
	 QaA3afF59y/TbEslMYEGeb1ZuveBvt7KfB5N4vaU4Q+AU8T95lTEXUuagDCFaWOyTz
	 ZRndQVE9+m/gNx7o/R2oLl/s7cXipW9a7Dr2kMqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Gupta <shashankg@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/207] crypto: octeontx2 - suppress auth failure screaming due to negative tests
Date: Mon,  2 Jun 2025 15:46:59 +0200
Message-ID: <20250602134300.596849065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shashank Gupta <shashankg@marvell.com>

[ Upstream commit 64b7871522a4cba99d092e1c849d6f9092868aaa ]

This patch addresses an issue where authentication failures were being
erroneously reported due to negative test failures in the "ccm(aes)"
selftest.
pr_debug suppress unnecessary screaming of these tests.

Signed-off-by: Shashank Gupta <shashankg@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
index 811ded72ce5fb..798bb40fed68d 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -410,9 +410,10 @@ static int cpt_process_ccode(struct otx2_cptlfs_info *lfs,
 				break;
 			}
 
-			dev_err(&pdev->dev,
-				"Request failed with software error code 0x%x\n",
-				cpt_status->s.uc_compcode);
+			pr_debug("Request failed with software error code 0x%x: algo = %s driver = %s\n",
+				 cpt_status->s.uc_compcode,
+				 info->req->areq->tfm->__crt_alg->cra_name,
+				 info->req->areq->tfm->__crt_alg->cra_driver_name);
 			otx2_cpt_dump_sg_list(pdev, info->req);
 			break;
 		}
-- 
2.39.5



