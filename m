Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40174315F;
	Wed, 19 Jun 2024 13:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803051; cv=none; b=BitGkmzBsE0MkoY9cwcwlifijFnp61BfUbQO4v6Etnzi8KabAR8skhvAjpzf9J8skTmTRIQ8CX9JwxGHbvlJo0K3cTEprxfMuLY+R/nbWEdxfTVAj+cnznAQx9/eVmehFgxAut2MitZR2Fu/1ZtuEugmTXbTBzy6JR+cVJ3DdxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803051; c=relaxed/simple;
	bh=F5xiAuW6MjxSgJ4y54rr1haHf5CXP4fIgUSqGlh5n5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaHcQdHg7NonkorAnN8PRYz+TYwChfogZj3Gd6q1v4Wbyg2/fV9Ly5rTnQPYW2G9FxQSviIRnwGVP5SqG/YGgrTzm/2eWqkcI/tXSjkQYyFQ4e6/Pt+MqmeZ/11QfCzUryenIcHAc2AxYRfJDCzAhG2mB+g8x4h6U+k7/TlMOQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/NhnAG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/NhnAG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DCCC2BBFC;
	Wed, 19 Jun 2024 13:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803051;
	bh=F5xiAuW6MjxSgJ4y54rr1haHf5CXP4fIgUSqGlh5n5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/NhnAG8YMDK2NLNUMRM7405LWaLimeGJtYSuNk2i/Wv3F2ixjAphgacnqMGfY3Hz
	 9w5bloIoLb4CwP1lFZQ7IAxZovb7uHmhmev9KoBP/5kkBUxcDtFeRZBUbZ0rkb59zD
	 BCy50vdK2cl51XWA+0rTSifTYB4W3E4951n3JNwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 136/281] iommu: Return right value in iommu_sva_bind_device()
Date: Wed, 19 Jun 2024 14:54:55 +0200
Message-ID: <20240619125615.075992180@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 89e8a2366e3bce584b6c01549d5019c5cda1205e ]

iommu_sva_bind_device() should return either a sva bond handle or an
ERR_PTR value in error cases. Existing drivers (idxd and uacce) only
check the return value with IS_ERR(). This could potentially lead to
a kernel NULL pointer dereference issue if the function returns NULL
instead of an error pointer.

In reality, this doesn't cause any problems because iommu_sva_bind_device()
only returns NULL when the kernel is not configured with CONFIG_IOMMU_SVA.
In this case, iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_SVA) will
return an error, and the device drivers won't call iommu_sva_bind_device()
at all.

Fixes: 26b25a2b98e4 ("iommu: Bind process address spaces to devices")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20240528042528.71396-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iommu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 2e925b5eba534..3b67d59a36bf9 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1537,7 +1537,7 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline void iommu_sva_unbind_device(struct iommu_sva *handle)
-- 
2.43.0



