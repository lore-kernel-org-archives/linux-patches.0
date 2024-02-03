Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B196F48CC5;
	Sat,  3 Feb 2024 04:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933746; cv=none; b=T2wC7Ke2L5VN0Mi61lJzITMSDxOCbxFsQmq7sFixtRvtW5NkKJUXGw7ySyw9sFRTH2rtMAB0owLs+E0JK+XzZuETFWtoxn5qeR1sd6UGKj6TWa3a8yK9gb8UI0tPZ0Gori7tgWFWYR/D9s63UIk/fuY4SfI8jneInjGTZGLi08E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933746; c=relaxed/simple;
	bh=yvMHHGQGxhZ/HZH/WV5fWqNwqG0DvJcJp1EetmAwwXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKyaDpB7LIxmAD/3dS354+3CVRgbD6WQKYo0bcfKJsdWUvVsCxAU8LCOCL2iD9P3rseh6z7fnPBRIGhh9OOKX7cDEqVPW3AxUM76BzrPGxoy+IVxW/PLIZ8niJ8rRT67+TbvwvSvCF6c5orntwZXmG/ue37KcyYqEQ8vx05O9ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aC+y4plg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aC+y4plg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7986BC43390;
	Sat,  3 Feb 2024 04:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933746;
	bh=yvMHHGQGxhZ/HZH/WV5fWqNwqG0DvJcJp1EetmAwwXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aC+y4plgQOllBEcmvGHJMzdv0vdWmSz+qSHMRj6aPlRdKL5HCFDPzvPAj9/f4GLJ3
	 AU7G5XOLkT7HRraV3hgQAdm6OjBxXmT6WnZAL80Dls7dvxW7s1wlcSggdibGjfYP7K
	 e5etQJFcjOSpghEvDRJisv9cqcfdzTol0eQidY80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 040/353] crypto: octeontx2 - Fix cptvf driver cleanup
Date: Fri,  2 Feb 2024 20:02:38 -0800
Message-ID: <20240203035405.071995563@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 6edd27ff8c4e..e4bd3f030cec 100644
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
index bac729c885f9..215a1b17b6ce 100644
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



