Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020342;
	b=uujAx58EYncrL7OATp/8ib/Zi1wUu5FfLoYp3AnQ5rzzEiSNYRyLXBFo5seaTmEQw0Y7
	 3+rZWNq/OsGMBNsfEWPyKyNr7yTK6dB2W5EK99GH0C6Fvg5oUu8yUzMKzpzfwyHS4JHOX
	 g6HCUS6QcchTJtO1B7ITNSw9MscG328giz4c3sfTPQtLoIq77cKo6933XBZUht30BMr3O
	 cbNJero0g/51wyi+F2VZf3F3sx66AO2sA3V006kro1Cpf1loW7XbKEoUKWmgGbSij3wu1
	 AxY5vLsgzVRH2koEWrWKurTON0wmVxUSJV+LUQwT0eThwKcUSJHe6xRCqEVRrnPzzBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QlRfoJ2OcEtEM+KOUU4q0Q+pkD1G41NOEtnIqfZ96/s=;
	b=q3bl9+siqJA/+2JMNHCNRJlB0qFw8rcrPoKgDujefneFVvo8NegYr0ViRDAP1/m/xxlf
	 dMgaFFai0KfZIoq1MfB0fq6Q/24G/oRI5ibWCAiS+1jPr/8r3mHZtUS8F21kR6lgbbHfI
	 R9p+2tMZGz69zza48+TSd4jfl84uO4MxVHpm7tRslIN/X57qvLeOpXClRYMjOYP3h3Giu
	 IFMh8a2R4VGhDppFovtYmFvkBsLT8s0OYjTA6cdc3JWQ8gEdWDafBsC9m/vdND0VquJpl
	 ibmWBVSQsYibl1L/hgoXglWRUPIc66LmIfvR8KDUTKESr/O9dEH+MYXzcg/8gA9MpRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aX3k7m10;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54BB606A32F;
	Wed, 18 Nov 2026 16:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aX3k7m10
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446171F000C4;
	Wed, 18 Nov 2026 16:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020341;
	bh=QlRfoJ2OcEtEM+KOUU4q0Q+pkD1G41NOEtnIqfZ96/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aX3k7m10e9qCYmPocgi/2CpBnYzhoppV4AwGp2OYMt8MgsLTdCuDNXxZCdsiWCVhQ
	 X2YD7zMD24mpaaVAl0RHwIUjutE1YReGjk0xG3NV/dJyYTo5TBwUZe58G/lPImtS6G
	 PsfORwxmJG9DkyCG58Mj3hGvUTr0z1rgRckmjKZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1916/2651] iommufd: Keep reserved IOVA ranges when a replace within one IOAS fails
Date: Wed, 18 Nov 2026 15:52:36 +0100
Message-ID: <20261118150355.742618114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a664c70a6fe73..1b0bdf57ac8ab 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -849,7 +849,8 @@ iommufd_group_do_replace_reserved_iova(struct iommufd_group *igroup,
 	return 0;
 
 err_unresv:
-	iommufd_group_remove_reserved_iova(igroup, hwpt_paging);
+	if (!old_hwpt_paging || hwpt_paging->ioas != old_hwpt_paging->ioas)
+		iommufd_group_remove_reserved_iova(igroup, hwpt_paging);
 	return rc;
 }
 
@@ -889,6 +890,7 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 		return NULL;
 	}
 
+	old_hwpt_paging = find_hwpt_paging(old_hwpt);
 	if (attach_resv) {
 		rc = iommufd_group_do_replace_reserved_iova(igroup, hwpt_paging);
 		if (rc)
@@ -899,7 +901,6 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 	if (rc)
 		goto err_unresv;
 
-	old_hwpt_paging = find_hwpt_paging(old_hwpt);
 	if (old_hwpt_paging && pasid == IOMMU_NO_PASID &&
 	    (!hwpt_paging || hwpt_paging->ioas != old_hwpt_paging->ioas))
 		iommufd_group_remove_reserved_iova(igroup, old_hwpt_paging);
@@ -920,7 +921,8 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
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



