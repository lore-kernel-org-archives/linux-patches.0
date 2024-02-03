Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432D810A13;
	Sat,  3 Feb 2024 04:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933331; cv=none; b=aGiy6c93UdC73eqPNBZCc7GHXWkAYonhK4j7lP8TVijMUd4p5PUDl2H4SQkuOxLvm+lZD1T2x51RzBeKCbYHTY571bMRJPFKq7y3gTcwXfK/ngQmAvjRcuVRM5d+C0m0MSj4dqqFyPVB8e9N3A/59mHUUuKaWFhn91HVGSnA3YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933331; c=relaxed/simple;
	bh=gk4+CX2Oer8H5kuv1ba5l4pJ6fK+k0pFwDYKSrUgX2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CW//srlEhgF5tOS7xV9CZ1Iy1wIqHqTGNsOwrYZViQSqX1/dmF8pIatXWlrdwbFeQJUOtK2d4atNDT6Gm//fQDcQ/sVzV6RIrdCWw5dPISKZfrNosZGIOWSXHa5c0QWDLQmrkhh7jL06AcrDWDXJdXoMKcRD5jhBKJum6iULwas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcO+u8YG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcO+u8YG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A697C43390;
	Sat,  3 Feb 2024 04:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933331;
	bh=gk4+CX2Oer8H5kuv1ba5l4pJ6fK+k0pFwDYKSrUgX2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcO+u8YGla2CBZS/KtwjhQA3kDi/5cH0jHkiNnla725vcBrXT9fU0jeN9yxZmK0Gs
	 ZRTgvbBbqLiJzrq6cCAYU6S7/fqbmt/Srf4LvsV1Qt6lUc1ASsvkHKPxRgEBDLvggA
	 /LN059IUwhqzd2bIiL3XAGdHBT7ab++xR3UzRDMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/219] crypto: octeontx2 - Fix cptvf driver cleanup
Date: Fri,  2 Feb 2024 20:03:21 -0800
Message-ID: <20240203035320.337089061@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Bharat Bhushan <bbhushan2@marvell.com>

[ Upstream commit c480a421a4faf693c38e60b0fe6e554c9a3fee02 ]

This patch fixes following cleanup issues:
 - Missing instruction queue free on cleanup. This
   will lead to memory leak.
 - lfs->lfs_num is set to zero before cleanup, which
   will lead to improper cleanup.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c      | 6 ++++--
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
index 71e5f79431af..6e4a78e1f3ce 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -419,8 +419,8 @@ int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_mask, int pri,
 	return 0;
 
 free_iq:
-	otx2_cpt_free_instruction_queues(lfs);
 	cptlf_hw_cleanup(lfs);
+	otx2_cpt_free_instruction_queues(lfs);
 detach_rsrcs:
 	otx2_cpt_detach_rsrcs_msg(lfs);
 clear_lfs_num:
@@ -431,11 +431,13 @@ EXPORT_SYMBOL_NS_GPL(otx2_cptlf_init, CRYPTO_DEV_OCTEONTX2_CPT);
 
 void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs)
 {
-	lfs->lfs_num = 0;
 	/* Cleanup LFs hardware side */
 	cptlf_hw_cleanup(lfs);
+	/* Free instruction queues */
+	otx2_cpt_free_instruction_queues(lfs);
 	/* Send request to detach LFs */
 	otx2_cpt_detach_rsrcs_msg(lfs);
+	lfs->lfs_num = 0;
 }
 EXPORT_SYMBOL_NS_GPL(otx2_cptlf_shutdown, CRYPTO_DEV_OCTEONTX2_CPT);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 392e9fee05e8..6f3373f9928c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -249,8 +249,11 @@ static void cptvf_lf_shutdown(struct otx2_cptlfs_info *lfs)
 	otx2_cptlf_unregister_interrupts(lfs);
 	/* Cleanup LFs software side */
 	lf_sw_cleanup(lfs);
+	/* Free instruction queues */
+	otx2_cpt_free_instruction_queues(lfs);
 	/* Send request to detach LFs */
 	otx2_cpt_detach_rsrcs_msg(lfs);
+	lfs->lfs_num = 0;
 }
 
 static int cptvf_lf_init(struct otx2_cptvf_dev *cptvf)
-- 
2.43.0



