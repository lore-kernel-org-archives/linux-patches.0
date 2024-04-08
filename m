Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94258172D;
	Mon,  8 Apr 2024 13:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582947; cv=none; b=BYtqLUSxw13vaocRVbownVYNAc3x8mT0SWvOWF0eUvRoleNxPy4PRBz2QVU+sAvCYb9Z4zeo2R4JxomzDPbvKBUY7KC621+tyF3rd3MMbRiFMKr7pIu9QO3YzX0mwGNu++aq+63iNscC0kOk401IBir/tdzElwEZcPYq3BNqF+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582947; c=relaxed/simple;
	bh=FL/oA1kust6SDV9HCQnJ+w1VgW5iABd9OcNMA9eRdBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaT5Z2Gx0fE7iQ4IE3jw5naDDJOLShHDpdSc8Y5QcH1lQVPk8HsOQ4cwo0W2ar6g2uUabA7kIL1MBOW0KzOb/57l18wTT3GD4dlCQz0R57/c036u3g7zp3cznuVwkNTOb9ErACkFGopWKfgH2T+ZdFENyDoDxVTmLE1u9EYJKu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+G3Ex+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+G3Ex+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02771C433C7;
	Mon,  8 Apr 2024 13:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582947;
	bh=FL/oA1kust6SDV9HCQnJ+w1VgW5iABd9OcNMA9eRdBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+G3Ex+kkEp1wnXyLPxFkBkQ3UAkbZfHxTka9cZb1oQRhd5+5A3XU/xns3RoYRX8G
	 UZl8gneJctiqimYD/f5pp//Cd3g5rCxhZaEWKMY6hXZTVLjGi2Uvcb58Wk8nJPpp3l
	 AnpMnVar8Db4fyGT1bQqDP2oQBhBlT1e03XDaCRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 141/252] i40e: Remove back pointer from i40e_hw structure
Date: Mon,  8 Apr 2024 14:57:20 +0200
Message-ID: <20240408125311.027967959@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 39ec612acf6d075809c38a7262d7ad09314762f3 ]

The .back field placed in i40e_hw is used to get pointer to i40e_pf
instance but it is not necessary as the i40e_hw is a part of i40e_pf
and containerof macro can be used to obtain the pointer to i40e_pf.
Remove .back field from i40e_hw structure, introduce i40e_hw_to_pf()
and i40e_hw_to_dev() helpers and use them.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 6dbdd4de0362 ("e1000e: Workaround for sporadic MDI error on Meteor Lake systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h       | 11 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c  | 22 ++++++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_osdep.h |  8 +++----
 drivers/net/ethernet/intel/i40e/i40e_type.h  |  1 -
 4 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 3cc0b87def3fa..6f08c8fe653bd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1322,4 +1322,15 @@ static inline u32 i40e_is_tc_mqprio_enabled(struct i40e_pf *pf)
 	return pf->flags & I40E_FLAG_TC_MQPRIO;
 }
 
+/**
+ * i40e_hw_to_pf - get pf pointer from the hardware structure
+ * @hw: pointer to the device HW structure
+ **/
+static inline struct i40e_pf *i40e_hw_to_pf(struct i40e_hw *hw)
+{
+	return container_of(hw, struct i40e_pf, hw);
+}
+
+struct device *i40e_hw_to_dev(struct i40e_hw *hw);
+
 #endif /* _I40E_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 8bfecf81d26f6..17ab6a1c53971 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -125,6 +125,17 @@ static void netdev_hw_addr_refcnt(struct i40e_mac_filter *f,
 	}
 }
 
+/**
+ * i40e_hw_to_dev - get device pointer from the hardware structure
+ * @hw: pointer to the device HW structure
+ **/
+struct device *i40e_hw_to_dev(struct i40e_hw *hw)
+{
+	struct i40e_pf *pf = i40e_hw_to_pf(hw);
+
+	return &pf->pdev->dev;
+}
+
 /**
  * i40e_allocate_dma_mem_d - OS specific memory alloc for shared code
  * @hw:   pointer to the HW structure
@@ -135,7 +146,7 @@ static void netdev_hw_addr_refcnt(struct i40e_mac_filter *f,
 int i40e_allocate_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem,
 			    u64 size, u32 alignment)
 {
-	struct i40e_pf *pf = (struct i40e_pf *)hw->back;
+	struct i40e_pf *pf = i40e_hw_to_pf(hw);
 
 	mem->size = ALIGN(size, alignment);
 	mem->va = dma_alloc_coherent(&pf->pdev->dev, mem->size, &mem->pa,
@@ -153,7 +164,7 @@ int i40e_allocate_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem,
  **/
 int i40e_free_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem)
 {
-	struct i40e_pf *pf = (struct i40e_pf *)hw->back;
+	struct i40e_pf *pf = i40e_hw_to_pf(hw);
 
 	dma_free_coherent(&pf->pdev->dev, mem->size, mem->va, mem->pa);
 	mem->va = NULL;
@@ -15653,10 +15664,10 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
  **/
 static inline void i40e_set_subsystem_device_id(struct i40e_hw *hw)
 {
-	struct pci_dev *pdev = ((struct i40e_pf *)hw->back)->pdev;
+	struct i40e_pf *pf = i40e_hw_to_pf(hw);
 
-	hw->subsystem_device_id = pdev->subsystem_device ?
-		pdev->subsystem_device :
+	hw->subsystem_device_id = pf->pdev->subsystem_device ?
+		pf->pdev->subsystem_device :
 		(ushort)(rd32(hw, I40E_PFPCI_SUBSYSID) & USHRT_MAX);
 }
 
@@ -15726,7 +15737,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	set_bit(__I40E_DOWN, pf->state);
 
 	hw = &pf->hw;
-	hw->back = pf;
 
 	pf->ioremap_len = min_t(int, pci_resource_len(pdev, 0),
 				I40E_MAX_CSR_SPACE);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_osdep.h b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
index 2bd4de03dafa2..997569a4ad57b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
@@ -18,10 +18,10 @@
  * actual OS primitives
  */
 
-#define hw_dbg(hw, S, A...)							\
-do {										\
-	dev_dbg(&((struct i40e_pf *)hw->back)->pdev->dev, S, ##A);		\
-} while (0)
+struct i40e_hw;
+struct device *i40e_hw_to_dev(struct i40e_hw *hw);
+
+#define hw_dbg(hw, S, A...) dev_dbg(i40e_hw_to_dev(hw), S, ##A)
 
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
 #define rd32(a, reg)		readl((a)->hw_addr + (reg))
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 232131bedc3e7..658bc89132783 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -525,7 +525,6 @@ struct i40e_dcbx_config {
 /* Port hardware description */
 struct i40e_hw {
 	u8 __iomem *hw_addr;
-	void *back;
 
 	/* subsystem structs */
 	struct i40e_phy_info phy;
-- 
2.43.0



