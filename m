Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F97442DFFA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301170; cv=none; b=eqwtvigPh4tFdN/ng4stgqcnZIybzr5ncLRLE0N/xCnSe8H6Vt/Vlj2la0rrpjvIOPvVReLqjlvGDnjHR/E2/+lENO3v+XTRBWXj6Lb2+R0xG1T6qBi9Ei7OObdvoT+EDrJJMjF9B9eeJtpReR2TMnEd81R0qQpSpssU9OpJYf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301170; c=relaxed/simple;
	bh=8YVmarEWy8ZbuTJFypcLTpsl2b93WJec7S8/DfoF4jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5snOXR2+pgpvQD3BrJndnAc6j+3mThDxXrPUTFE+ynmtg5Wv1M+zem0kCMBARO7MzKgWvTqO0EPkgarAiC1ZKg+tyCwEMjZWRcL86jfcAQ8D+FTRfS8aLBkFTjUCnaRm7xNU4HPrcrw15MAIHEkSDlCmc6l0pNCNYK63wBFhyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgdLOX1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgdLOX1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69769C19424;
	Sat, 28 Feb 2026 17:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301170;
	bh=8YVmarEWy8ZbuTJFypcLTpsl2b93WJec7S8/DfoF4jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgdLOX1+urbeqjkmdXUUS+rRNodXpimy2YzRkuVSTQkdFdpsVpO1tO5Gtt/f4yFqK
	 1duNCRbD6yw3USmve1lVkvJNAtYaQCSa+O7TEcBU/cgF9KJVvmnDfas3mD3w3J+hZ8
	 pUs0BPqRpiOW7VKVuHVvOVGdWg/dtgPsGkNZgEeCKL0kY00XlHf/mWlvoCZE5ejqu8
	 C4CMX54X5PDvVdUucyiN8RDcaguX7htT8qKGVThmu7y3ypZG6qAenjignqxtn5PE1O
	 +lPjkzMGV3oIkcTi7qOb0gDoYk3+rJbMROfMf1l+yQF2x/53yYXEYZ/MMqbbD8rIUl
	 Hfu5SV6onMbYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Liang Jie <liangjie@lixiang.com>,
	fanggeng <fanggeng@lixiang.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 336/752] pinctrl: mediatek: make devm allocations safer and clearer in mtk_eint_do_init()
Date: Sat, 28 Feb 2026 12:40:47 -0500
Message-ID: <20260228174750.1542406-336-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit 255b721c96046d4c57fa2268e4c72607868ce91f ]

mtk_eint_do_init() allocates several pointer arrays which are then
populated in a per-instance loop and freed on error. The arrays are
currently allocated with devm_kmalloc(), so their entries are left
uninitialised until the per-instance allocations succeed.

On a failure in the middle of the loop, the error path iterates over
the full nbase range and calls devm_kfree() on each element. For
indices which were never initialised, the corresponding array entries
contain stack garbage. If any of those happen to be non-zero,
devm_kfree() will pass them to devres_destroy(), which will WARN
because there is no matching devm_kmalloc() resource for such bogus
pointers.

Improve the robustness and readability by:

  - Using devm_kcalloc() for the pointer arrays so that all entries
    start as NULL, ensuring that only genuinely initialised elements
    may be freed and preventing spurious WARN_ON()s in the error path.
  - Switching the allocations to sizeof(*ptr) / sizeof(**ptr) forms,
    avoiding hard-coded element types and making the code more resilient
    to future type changes.
  - Dropping the redundant NULL checks before devm_kfree(), as
    devm_kfree() safely handles NULL pointers.

The functional behaviour in the successful initialisation path remains
unchanged, while the error handling becomes simpler and less
error-prone.

Reviewed-by: fanggeng <fanggeng@lixiang.com>
Signed-off-by: Liang Jie <liangjie@lixiang.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index 9f175c73613f8..2ea0902b4f660 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -539,24 +539,32 @@ int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin)
 		}
 	}
 
-	eint->pin_list = devm_kmalloc(eint->dev, eint->nbase * sizeof(u16 *), GFP_KERNEL);
+	eint->pin_list = devm_kcalloc(eint->dev, eint->nbase,
+				      sizeof(*eint->pin_list), GFP_KERNEL);
 	if (!eint->pin_list)
 		goto err_pin_list;
 
-	eint->wake_mask = devm_kmalloc(eint->dev, eint->nbase * sizeof(u32 *), GFP_KERNEL);
+	eint->wake_mask = devm_kcalloc(eint->dev, eint->nbase,
+				       sizeof(*eint->wake_mask), GFP_KERNEL);
 	if (!eint->wake_mask)
 		goto err_wake_mask;
 
-	eint->cur_mask = devm_kmalloc(eint->dev, eint->nbase * sizeof(u32 *), GFP_KERNEL);
+	eint->cur_mask = devm_kcalloc(eint->dev, eint->nbase,
+				      sizeof(*eint->cur_mask), GFP_KERNEL);
 	if (!eint->cur_mask)
 		goto err_cur_mask;
 
 	for (i = 0; i < eint->nbase; i++) {
-		eint->pin_list[i] = devm_kzalloc(eint->dev, eint->base_pin_num[i] * sizeof(u16),
+		eint->pin_list[i] = devm_kzalloc(eint->dev,
+						 eint->base_pin_num[i] * sizeof(**eint->pin_list),
 						 GFP_KERNEL);
 		port = DIV_ROUND_UP(eint->base_pin_num[i], 32);
-		eint->wake_mask[i] = devm_kzalloc(eint->dev, port * sizeof(u32), GFP_KERNEL);
-		eint->cur_mask[i] = devm_kzalloc(eint->dev, port * sizeof(u32), GFP_KERNEL);
+		eint->wake_mask[i] = devm_kzalloc(eint->dev,
+						  port * sizeof(**eint->wake_mask),
+						  GFP_KERNEL);
+		eint->cur_mask[i] = devm_kzalloc(eint->dev,
+						 port * sizeof(**eint->cur_mask),
+						 GFP_KERNEL);
 		if (!eint->pin_list[i] || !eint->wake_mask[i] || !eint->cur_mask[i])
 			goto err_eint;
 	}
@@ -592,12 +600,9 @@ int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin)
 
 err_eint:
 	for (i = 0; i < eint->nbase; i++) {
-		if (eint->cur_mask[i])
-			devm_kfree(eint->dev, eint->cur_mask[i]);
-		if (eint->wake_mask[i])
-			devm_kfree(eint->dev, eint->wake_mask[i]);
-		if (eint->pin_list[i])
-			devm_kfree(eint->dev, eint->pin_list[i]);
+		devm_kfree(eint->dev, eint->cur_mask[i]);
+		devm_kfree(eint->dev, eint->wake_mask[i]);
+		devm_kfree(eint->dev, eint->pin_list[i]);
 	}
 	devm_kfree(eint->dev, eint->cur_mask);
 err_cur_mask:
-- 
2.51.0

