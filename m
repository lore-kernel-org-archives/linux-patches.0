Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625380;
	b=sipp88R6oL4Is0LzGlY2onZVDvoOMD64t+j/xhEpju4MCXKIDkDBVRp6bPDx/ZQEkHJ9
	 r4PrhSTJxBV6qGJQao/eZpul/lkysV4yt9BWtU5mduatQJjIdZWMtfqCt0NZ/vdN+vtUz
	 fl1mqkg2RhL8ewfWVsz2GK8MEhSpDz0/DFSxL7QNF6Oq/pgy7C1GFscUqSozlKzbujLRH
	 gFiWD/0a+G4uBr/4lJWT21TLTsvUjlQVOZNri7Xz1sOBG3b6vOnRystcmEi4UZAi4Njhg
	 kJFgJBmm7/pL5j2MH/BEadw8yK9fEmiat/ft5QSbI7ZHNBDjZoQU7iZJ8qIE1FpMKaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jsnfnviSjCSjk1zVW6zdy+APwatC1THkP2ETG1YKYLs=;
	b=TjKvpXxVwR4GsfYnwOuCQDFHi9lZz7kH5UosJ91vvvc8/hzpnEXqv5ZfxuWUN7Em1YZ7
	 ZeZQOmfjoV+LarSLBsjvk7YyJXs57qf3LbNCmZHJ2jSWiP6PBrfAC5oWzjZhTpFs68Ex6
	 kfsFGUvWeyKxzOs3Wn/3MiQXXeZq9Q6d5uYZm6KZuHhXA+Y4Icw6eHc8dIQ92PQozQJ2n
	 sWWYJBI34L3HVFmtniyTyJsYCrP61ZW1VBtE1Y0MelnBD0F+otiglcD+oVQs3PwRRuvct
	 whogG+hXm7G9tXU7ayi31ssBhh7/M41EMNOTY3QvE/cZl4paiMP1xUqACFPM0KE88BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i++yUBRX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A5E606A31E;
	Wed, 25 Nov 2026 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i++yUBRX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3241F000C6;
	Wed, 25 Nov 2026 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625380;
	bh=jsnfnviSjCSjk1zVW6zdy+APwatC1THkP2ETG1YKYLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i++yUBRXTCpVAw3kg2JvBuhRd4LlKDsSDdCsk1Ky4W8pa0IAD05M00epNMhZdV61b
	 5tv4hWddmphb62i3kpZiQc6UU5D3YyuprkIhUNw/5Juy82D2rvu7bznhTRhW1NMhhy
	 ERC2DsrB21H5WsH1A5hnz6MECwYuLM4EHaP9cvMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 496/816] iommufd: Keep reserved IOVA ranges when a replace within one IOAS fails
Date: Wed, 25 Nov 2026 15:34:04 +0100
Message-ID: <20261125143900.671641746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context: no attach_resv variable or pasid check in this tree, so the error-path IOAS guard uses hwpt_paging and old_hwpt_paging is looked up right after old_hwpt. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/device.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 5dc9fa269e3a8..fd07f7f25e13f 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -592,7 +592,8 @@ iommufd_group_do_replace_reserved_iova(struct iommufd_group *igroup,
 	return 0;
 
 err_unresv:
-	iommufd_group_remove_reserved_iova(igroup, hwpt_paging);
+	if (!old_hwpt_paging || hwpt_paging->ioas != old_hwpt_paging->ioas)
+		iommufd_group_remove_reserved_iova(igroup, hwpt_paging);
 	return rc;
 }
 
@@ -625,6 +626,7 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 	}
 
 	old_hwpt = igroup->hwpt;
+	old_hwpt_paging = find_hwpt_paging(old_hwpt);
 	if (hwpt_paging) {
 		rc = iommufd_group_do_replace_reserved_iova(igroup, hwpt_paging);
 		if (rc)
@@ -635,7 +637,6 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 	if (rc)
 		goto err_unresv;
 
-	old_hwpt_paging = find_hwpt_paging(old_hwpt);
 	if (old_hwpt_paging &&
 	    (!hwpt_paging || hwpt_paging->ioas != old_hwpt_paging->ioas))
 		iommufd_group_remove_reserved_iova(igroup, old_hwpt_paging);
@@ -656,7 +657,8 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 	/* Caller must destroy old_hwpt */
 	return old_hwpt;
 err_unresv:
-	if (hwpt_paging)
+	if (hwpt_paging &&
+	    (!old_hwpt_paging || hwpt_paging->ioas != old_hwpt_paging->ioas))
 		iommufd_group_remove_reserved_iova(igroup, hwpt_paging);
 err_unlock:
 	mutex_unlock(&idev->igroup->lock);
-- 
2.53.0



