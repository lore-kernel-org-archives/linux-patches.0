Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E337A28C2BF;
	Thu, 20 Aug 2026 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247130; cv=none; b=a8Y/5lSBxVv+WlvEgV8znx44nxAhLe2MNOwArXNjIzJCfnQwOY5YEAka8uzg7Ol2AfAgSNuyjIuYIN/H/uYLxqHjRSmGwvmAluNVkoHi97oZJkafLd1kwEm465QV4J+GDHukARVN2wfBV5flL5eeiZFHdV4+GiRcb08oKy2hsVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247130; c=relaxed/simple;
	bh=4Glc8HbGMfUNSaT0dFoWnN7+yEn45t6XfhnA4/RGH2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9FbamT+nwcQF3AZdDJ4CLdCkp6Kb0Aq+l8D580imej2li2zPtkEDVbDDE2vN4j6cW9HSXsTrEcYg9vu/yOMv+RM8q8EHNG+3yz4uFB5984hJ+O+5ofa9ZQDyVxltZat/CEo80f7OX/d+IwoNh3Alh/3eUDf9/JRdnE7RHHLP2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MExWU/Ym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MExWU/Ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8A61F000E9;
	Thu, 20 Aug 2026 17:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247128;
	bh=xoYVuCAa87ZAHBPj+m/QsFBsl6PYieW/0SpgzpKBo8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MExWU/YmwoAgOOqDmtpOUCKCu34V30svfb5aUUYDWv8Az+xxN1GDaXtLjR1pq4ade
	 M2Y+3UtFJj3+/Hcky6CLN+4IdDkrwuQbHMsGQ7SLIpn0oENuDPoL89cTToh9+UZcO/
	 56C14BByLtbrfxmWHTOmcNjlo6vlITpDPxwoTxFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/220] iommufd: Fix wrong hwpt passed to iommufd_auto_response_faults on replace
Date: Thu, 20 Aug 2026 16:55:32 +0200
Message-ID: <20260820145227.739881567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

[ Upstream commit ba5c0f28a26e7d9be1e0997f8920dd638e2782fd ]

iommufd_hwpt_replace_device() calls:

	iommufd_auto_response_faults(hwpt, old_handle);

passing the *new* hwpt together with the handle of
the device's *old* domain. This should be a parameter mismatch:

1. Semantically, iommufd_auto_response_faults(x, handle) scans
   x->fault's deliver list and response xarray for groups matching
   "handle". A group is queued under the hwpt that was attached at
   fault-delivery time. old_handle is fetched *before* the domain switch,
   so its group lives on old->fault, not on the new hwpt->fault.

2. Historically, the first argument was "old". The routine was
   introduced by commit b7d8833677ba ("iommufd: Fault-capable hwpt
   attach/detach/replace") as __fault_domain_replace_dev() in
   fault.c, correctly calling iommufd_auto_response_faults(old, curr).
   Commit fb21b1568ada ("iommufd: Make attach_handle generic than
   fault specific") moved this into iommufd_hwpt_replace_device() in
   device.c and swapped it to "hwpt". This should be a refactor regression,
   not an intentional change.

Fix this by passing "old" instead.

Link: https://patch.msgid.link/r/9D652384339C69D5+20260710122952.885325-1-peiyang_he@smail.nju.edu.cn
Fixes: fb21b1568ada ("iommufd: Make attach_handle generic than fault specific")
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -453,7 +453,7 @@ static int iommufd_hwpt_replace_device(s
 		goto out_disable_iopf;
 
 	if (old->fault) {
-		iommufd_auto_response_faults(hwpt, old_handle);
+		iommufd_auto_response_faults(old, old_handle);
 		if (!hwpt->fault)
 			iommufd_fault_iopf_disable(idev);
 	}


