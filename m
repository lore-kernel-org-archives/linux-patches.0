Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676C825B0BC;
	Sat, 30 May 2026 17:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163139; cv=none; b=lizC/zjvhJu/AISv70bnwjTyjF2fMGLdjonQaHhGYqcqAngba5xICHcfl6ZQCRtoE7EWjuWWYMmDaqWpY3jwJfct6QAL1GavFBwG3/Nc2Jy/m0lybv/LKEn5YYeXZuPZr5mIRj7FMgf0zWTl7vjGkdVmncsH73JLoyQ2/d8NbXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163139; c=relaxed/simple;
	bh=jTPWl/98BGhDvsL1xk3rIF2f6zHHHIEB6kT+oqX/FYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvl6tULzoXD01iGRGCdocoP5IfJngNQXprXBx6Uv/RRF5i2WSGXE0mu/x/PtuqjT9KKY19ZPJQF5jRxK9YAaA2zef/QPGfbP9YdR9SUaX2e7Lh0zbDURgfL3vonGWB3yHVE6jrda8mQ66wK6W/6Nf8RZuZyH/2C2E/4ZjXCfs6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6a6miaB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6a6miaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7581D1F00893;
	Sat, 30 May 2026 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163138;
	bh=Mpe9qvu9FN3HuF1lidVRvwnXD4I2aD4omM0CU1HOKuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6a6miaBQVLIKBJcXZXeoTrNwbelBwVmnEm/JUelN3AHJf9Q/aIL5rbZ6seEkRoAb
	 TaAhY1oh8nGY/AzMprfJGVXdjykFuEpubCKUIZpFum7hOH2E4DuHcA+kStOxUJHvGv
	 3xz/nBnOcrH+fcQQLofN4Nh3066ZRt7khG+rFHpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH 5.15 169/776] iommu: fix a reference count leak in iommu_sva_bind_device()
Date: Sat, 30 May 2026 17:58:03 +0200
Message-ID: <20260530160244.860317319@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Karasulli <vsntk18@gmail.com>

commit b34289505180 ("iommu: disable SVA when CONFIG_X86 is set")
disables SVA to mitigate a security vulnerability.

Due the current placement of the condition check,
function returns after iommu_group_get() without a corresponding
iommu_group_put(). So move the condition check above.

This is a stable-only fix applicable to linux-5.15.y.

Fixes: b34289505180 ("iommu: disable SVA when CONFIG_X86 is set")
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2:
  - addressed formatting mistakes in the changelog

 drivers/iommu/iommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3061,6 +3061,9 @@ iommu_sva_bind_device(struct device *dev
 	struct iommu_sva *handle = ERR_PTR(-EINVAL);
 	const struct iommu_ops *ops = dev->bus->iommu_ops;
 
+	if (IS_ENABLED(CONFIG_X86))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!ops || !ops->sva_bind)
 		return ERR_PTR(-ENODEV);
 
@@ -3068,9 +3071,6 @@ iommu_sva_bind_device(struct device *dev
 	if (!group)
 		return ERR_PTR(-ENODEV);
 
-	if (IS_ENABLED(CONFIG_X86))
-		return ERR_PTR(-EOPNOTSUPP);
-
 	/* Ensure device count and domain don't change while we're binding */
 	mutex_lock(&group->mutex);
 


