Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026857;
	b=UuY68u6XfxrueT6ISrZEcNYomO1rdkvzKA8GoB+K0RPhDSJidB50qfisv6HXqWXfQUJH
	 RSKkzsW6q8TOHWHA6Kl1RgWR0T445IDFeKSO1500Xjlg7r3O4E+QKwjUU/GzqozYLtBrd
	 Yq9JAQeJYeCjNJSPQY/1dHnGrPhoSnV31hghEcdnvFUBA1Y0Buau9pdh7aFD6G7L3Ze7G
	 aHMbXFS9ookhWdv5ODCBqsSjfUSBYW0lmIuoIRr06YpUpP4jbZWLbAKteCE+qzugcpmij
	 rgYaAtuloZGgexej9Mzj130zJAbXEAKOEXW3iNc+caUAykaom7PVbGTWL3eluxUSq7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j/uOGlsI624jgb7G7QlqRhDHAO5a7YsviJfMsnnUowQ=;
	b=yPyzUPbCjyNF3a5kdvCDadOGS07olcItGsj+xBk5CivK8HzkCYCCycKg8P47ELQWHsE3
	 iakU2i5ir1cSG77wDTdKSfmdkxWwVnJQe47iHxMPZame2RjoSf8f3ro1Ul9+7NRLcCEA9
	 L4weJE5RI2ImWGPOeQcfpf2bGkrchRNOQZ+RXhfvh66o7w2Mxu0Qt2IB3rkzBK2WoeoP8
	 ZeyS7V2ED+oYWk67XgsEQUKijo2ccmq2EBvsuEkmErOxA6BfAu9mD1sTNOrHrd+Hb8Tzw
	 rjPHKWdailZMQBxrS3AgPQj9kmRkqfbrri9RfV3abNX9HCPooE558GNL09oQZXYPN7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfvpOhw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF7B606A32C;
	Wed, 18 Nov 2026 18:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfvpOhw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052E11F000C4;
	Wed, 18 Nov 2026 18:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026857;
	bh=j/uOGlsI624jgb7G7QlqRhDHAO5a7YsviJfMsnnUowQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfvpOhw082oSIULcu33LzVuqjETNS/jsz4CepK5BrptnjqEB7DSbc5F6rt7A5+pvx
	 8LwZHoegvS4ALli8/QO6u1RfStVD/9KpCcKU3BYMqMMX3rgRl4ohiyQNhZmh7/r/+K
	 kLfPXMB917p3qBKvtFeCCdBJlsL8edRhnuDxk2zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1557/2151] iommufd: Keep reserved IOVA ranges when a replace within one IOAS fails
Date: Wed, 18 Nov 2026 15:54:52 +0100
Message-ID: <20261118150218.612660373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 1e67cca28490f897788c128c650a6f2cbb565403 ]

iommufd_device_do_replace() installs the group's reserved IOVA ranges in
the new hwpt's IOAS only when it differs from the old hwpt's IOAS. If the
replace fails in iommufd_device_do_replace() or
iommufd_group_do_replace_reserved_iova(), the error paths remove the
ranges from the new hwpt's IOAS whether or not the IOAS is shared
between the old and new hwpt, which removes the ranges that the old hwpt
still needs.

For example, on x86 with intel-iommu, after a replace within a shared
IOAS fails with -ENODEV, IOMMU_IOAS_IOVA_RANGES goes from

  0x0-0xfedfffff
  0xfef00000-0xffffffffffff

to

  0x0-0xffffffffffff

and IOMMU_IOAS_MAP at 0xfee00000 succeeds.

Remove the ranges on failure only when the replace installed them, and
look up the old hwpt_paging before the replace so that the error path
can compare the IOAS.

Fixes: e88d4ec154a8 ("iommufd: Add iommufd_device_replace()")
Assisted-by: LLM
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Link: https://patch.msgid.link/20260929031402.1998253-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/device.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 3216deab98e39..ccc33fc6eb70e 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -766,7 +766,8 @@ iommufd_group_do_replace_reserved_iova(struct iommufd_group *igroup,
 	return 0;
 
 err_unresv:
-	iommufd_group_remove_reserved_iova(igroup, hwpt_paging);
+	if (!old_hwpt_paging || hwpt_paging->ioas != old_hwpt_paging->ioas)
+		iommufd_group_remove_reserved_iova(igroup, hwpt_paging);
 	return rc;
 }
 
@@ -805,6 +806,7 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 		return NULL;
 	}
 
+	old_hwpt_paging = find_hwpt_paging(old_hwpt);
 	if (attach_resv) {
 		rc = iommufd_group_do_replace_reserved_iova(igroup, hwpt_paging);
 		if (rc)
@@ -815,7 +817,6 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 	if (rc)
 		goto err_unresv;
 
-	old_hwpt_paging = find_hwpt_paging(old_hwpt);
 	if (old_hwpt_paging && pasid == IOMMU_NO_PASID &&
 	    (!hwpt_paging || hwpt_paging->ioas != old_hwpt_paging->ioas))
 		iommufd_group_remove_reserved_iova(igroup, old_hwpt_paging);
@@ -836,7 +837,8 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 	/* Caller must destroy old_hwpt */
 	return old_hwpt;
 err_unresv:
-	if (attach_resv)
+	if (attach_resv &&
+	    (!old_hwpt_paging || hwpt_paging->ioas != old_hwpt_paging->ioas))
 		iommufd_group_remove_reserved_iova(igroup, hwpt_paging);
 err_unlock:
 	mutex_unlock(&igroup->lock);
-- 
2.53.0



