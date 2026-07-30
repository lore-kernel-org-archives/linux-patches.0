Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5EC40FD86;
	Thu, 30 Jul 2026 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426575; cv=none; b=nxdKY24LGldsR6qOsOfyCg+s2YPtWY69yy56pJqM4oiMh5jcBdt3XWDONp05QtrpLrS6GhDxTAqDjOvDK3NdORs1g8zNbOhPsUVH58aRZWIuHl+T7S+D+y9JOMjbvhRqD71FHSPDbUEBY4fG4eIkWaBioArTNxzRcbzEvyTWuVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426575; c=relaxed/simple;
	bh=AezXpYofsilQQesi2acaOjkxQ/ooabYy06xEpq+uPIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkON98H/dDXdGByKBhmrZsthB5ZcZJhte8pIVbvqAeKydpGs9tTKghC9s0ekOkDOy9NVkp44pTFZw34GklIHuuYrpC3zf8mF3iQCpG/RZNILU1Yx47jdUuGiKfe9QcP+6frL3rvVsEETe16MQ47vL0v9r7fSMZA27eOq9sjuLpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nx00dOw6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nx00dOw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F9D1F000E9;
	Thu, 30 Jul 2026 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426572;
	bh=/ZkXZyVoH46+uP0MiD7wZYrdb3yNMbkx7GtBmdJV1dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nx00dOw6DrIhGliFVV6p65Qy/1ASBjBRn5yQrY2wvdCog9j0zqSnOt2MtQuBQWJ3C
	 flhPmNlml2bKoRz47gIgdQ2/7obgrLLpj52LmsS5zXYHGmiDwbv3PiA0trIXC4XU3K
	 uKA5AU/tpOWrbsbVyL1nIyRCKbG4OnwlQV9PDMn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 465/602] iommufd: Reject invalid read count in iommufd_fault_fops_read()
Date: Thu, 30 Jul 2026 16:14:17 +0200
Message-ID: <20260730141445.732344959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 47916a54eeb2a9e654512ee609f71bd5b29db702 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/fault.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -273,6 +273,9 @@ static ssize_t iommufd_fault_fops_read(s
 		if (done >= count ||
 		    group->fault_count * fault_size > count - done) {
 			iommufd_fault_deliver_restore(fault, group);
+			/* Read count doesn't fit the first fault group */
+			if (done == 0)
+				rc = -EINVAL;
 			break;
 		}
 


