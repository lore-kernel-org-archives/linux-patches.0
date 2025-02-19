Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6C6176ADE;
	Wed, 19 Feb 2025 09:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957604; cv=none; b=d0tTMKCOUAw0yoeCPXBHuCoMj1N+t9NcUJ5gNI7iQHYsKkHaZzzspVDue0Cc9CoT8irc1XuJ+WDk80rLfSgq+xj4oWj5XEW80V3lPTm/XyEaIKeYaIZmqJQ0gv4m+QfttAT/MDcbIPBJkB3QbqkVlpOWMoPs++TZExeIbk6ls0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957604; c=relaxed/simple;
	bh=yu9g86Ji4ybP9JTNGDf6OpdWlsRJCSPLa+si5kF1hkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5PFpZWBWEFKNVAE0jAf2kwFdqnmshruauX6GDHn5jUrZtpR22kSTiGSwaZyfoVDf75frPq4MhdEeFY/rfeeURQaowLYbImSsnxx5Dvib1UC/VHcaGfcvDvbWWiGOhZqq0gY6/2cpgttMT/526AtedjRmn8ss6VXfzzmrnLF5so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGV7Rtl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGV7Rtl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAA9C4CED1;
	Wed, 19 Feb 2025 09:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957603;
	bh=yu9g86Ji4ybP9JTNGDf6OpdWlsRJCSPLa+si5kF1hkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGV7Rtl0qRv73z4kLKRnPyaYqzqJ6KBMfgBgQixT7Q/UcCdhiCDtaJgOvbwKR1l6T
	 pO05YZu/x65uC+MSJA6b+nzzJmDTEOLWtlFd1b4TlqgMvsPyC86t+UIcct7c9Blarn
	 O5TPMM35YF7B7JrJRgosqzfIbhDs88StNeZ/46xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Bin Lan <lanbincn@qq.com>
Subject: [PATCH 6.1 561/578] iommu: Return right value in iommu_sva_bind_device()
Date: Wed, 19 Feb 2025 09:29:25 +0100
Message-ID: <20250219082715.027174877@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 89e8a2366e3bce584b6c01549d5019c5cda1205e upstream.

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
Signed-off-by: Bin Lan <lanbincn@qq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iommu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -999,7 +999,7 @@ iommu_dev_disable_feature(struct device
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void *drvdata)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline void iommu_sva_unbind_device(struct iommu_sva *handle)


