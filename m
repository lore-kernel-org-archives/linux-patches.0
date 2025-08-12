Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EDE2FD1C2;
	Tue, 12 Aug 2025 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024930; cv=none; b=F8OiVlvSanE0xmEkvWEs7zNi6sZHBM47tvhwlK6mmXEPkjxRyfXZ4wLHVLVCEGeHp/rAkB+JPw5Y2SQLS71kdzCl3ZW4uxC5SIt3G38MfdzFvDiUUQfOucWkQZCaVR5WU+5E1qisGEQ8ATl6iQ1zYz4zDUpvVYmx7QYdHLFXuzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024930; c=relaxed/simple;
	bh=VOHNxtXjo9WHXj9oXv1AsVsEPHdiMx2NqcLcgxyQViY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAs0BHqRJPLW9IT7mY05LVmokPIwPQAi/Il+Uz7mdnd05/xx5xjAE2lPGvjLMe0iTeREgaX9WC5QJ0vO7FsEkBXORyosqdvrtb3RlBGcODjXzPt9D+tSF0dSyz16o4FytXimsBKaBYI0rEGwfs4xV0UBqRFFIYr+8Qcwu/NfQso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVMGZVyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVMGZVyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E96C4CEF0;
	Tue, 12 Aug 2025 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024929;
	bh=VOHNxtXjo9WHXj9oXv1AsVsEPHdiMx2NqcLcgxyQViY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVMGZVypWhKEKBp8NfIBTWEfgy2vypcnychYaV3Ph0IAgrvtSz77tbQ94LbjsCxlP
	 XPr5RNMC2dth3sZOGT+hfs60xxT9YJ8PVUhlEBmukwB0HDJHsd/W1ADVCpqLhl7izx
	 nnXZa1Q55zKrBi1OcHFc5dmUZOqAsdFMU80emRCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 491/627] vfio: Prevent open_count decrement to negative
Date: Tue, 12 Aug 2025 19:33:06 +0200
Message-ID: <20250812173445.262903733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Pan <jacob.pan@linux.microsoft.com>

[ Upstream commit 982ddd59ed97dc7e63efd97ed50273ffb817bd41 ]

When vfio_df_close() is called with open_count=0, it triggers a warning in
vfio_assert_device_open() but still decrements open_count to -1. This allows
a subsequent open to incorrectly pass the open_count == 0 check, leading to
unintended behavior, such as setting df->access_granted = true.

For example, running an IOMMUFD compat no-IOMMU device with VFIO tests
(https://github.com/awilliam/tests/blob/master/vfio-noiommu-pci-device-open.c)
results in a warning and a failed VFIO_GROUP_GET_DEVICE_FD ioctl on the first
run, but the second run succeeds incorrectly.

Add checks to avoid decrementing open_count below zero.

Fixes: 05f37e1c03b6 ("vfio: Pass struct vfio_device_file * to vfio_device_open/close()")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.pan@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250618234618.1910456-2-jacob.pan@linux.microsoft.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1fd261efc582..5046cae05222 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -583,7 +583,8 @@ void vfio_df_close(struct vfio_device_file *df)
 
 	lockdep_assert_held(&device->dev_set->lock);
 
-	vfio_assert_device_open(device);
+	if (!vfio_assert_device_open(device))
+		return;
 	if (device->open_count == 1)
 		vfio_df_device_last_close(df);
 	device->open_count--;
-- 
2.39.5



