Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEB13FE660;
	Thu, 16 Jul 2026 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211405; cv=none; b=uHW7ebK4N9/qquXtA/kvNajvaNLvVil4PKnxfU1ygGMBF+NWKX8vsWXZ2F9c77CsqHF4LHUZSPZ09b2F6R9fCPGrsG+d7UD/xWWLeM+dog2QVW9gEWimxjOSkOsEAAM1soo+cNh9cpLMBIyXoNuZ1o+Fj2uqp4pX7oFgD0BmuZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211405; c=relaxed/simple;
	bh=YfmcGeXq2jnmX2Ch6foTNpGg9MinSSiboXBR1ETh+cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwpuAkNb/m8Zdzfo7VPqhIZWI9JPWP7UtpK8AaGE80H3ridEm31Jf0/8cncFosOiv5Zll96/sbRHhVGNdYGRVK39h1fiHNitBUCPP2mQyb56B9SnDpNfwZj1G0766avyAoifsHU8N83gI2prvcq7CMhtI7HbjhYvED6sRPLVT1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6N1wmel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6N1wmel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719601F000E9;
	Thu, 16 Jul 2026 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211403;
	bh=YfqINDiU2cSMYjmkTp9arOazR6XKpSB1+mJbQc3y0Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6N1wmelCOryxVqvID5J6NDvUjdzjqU0Qn4NDepsXawhVYun/FWdM3zMuovfPt3XX
	 MQRJHbU/DINaI3JFVvlN7Qhf0jkmk8uJCgLjbonbhUrp5LAXk1Di4Zn+O62rwTLA+K
	 yKddQkAW7qK3k0vmdkJXV+5EamCFjXQozp3cYzHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 413/480] iommufd: Reject invalid read count in iommufd_fault_fops_read()
Date: Thu, 16 Jul 2026 15:32:40 +0200
Message-ID: <20260716133053.745167216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 47916a54eeb2a9e654512ee609f71bd5b29db702 upstream.

The read count must be large enough to hold one fault or a group's faults.

iommufd_fault_fops_read() does not validate the count, but returns 0 as if
the read had succeeded while leaving the pending fault in the queue.

Return -EINVAL in the undersize cases.

Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Link: https://patch.msgid.link/r/85c118a606fbedc5c132a1f5ec223a5ba23b92d2.1780343944.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -142,6 +142,9 @@ static ssize_t iommufd_fault_fops_read(s
 		if (done >= count ||
 		    group->fault_count * fault_size > count - done) {
 			iommufd_fault_deliver_restore(fault, group);
+			/* Read count doesn't fit the first fault group */
+			if (done == 0)
+				rc = -EINVAL;
 			break;
 		}
 


