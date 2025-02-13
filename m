Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9DF26B0A4;
	Thu, 13 Feb 2025 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458140; cv=none; b=U6ffUvYJSNZnGuaWQ8Emcbc0d+1TBtuEuuG4pLWbo8RJhtTYqObQj5ELYMFcjiIxqEDKo54/FbVNFSUItOIgI+JAk8AAkREx9l9nhgklMXqG5f83XK+WziDPx/M7MWOYWUFozC0jXSC3gjXE0ikokzKmDq1lNct8ougTRuScgBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458140; c=relaxed/simple;
	bh=SsbSo7L4SOreKGgca9NtDz81mjuBdUrv90yjDU8/Bww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hy2/b+zkk8Im1fXKfD8VSVY4hNVoXoHc5UhX4F5bkq+dSN5+ca+KrfMF2zL94WQDZ/B/Bieik57A37342pecl88nZ+spvfbiPQv3+fsrXyr2h3/f6F03LE2k3dmtxt8xlnxcBc76MZg91A2RFynLGvsvbSh4NLEw/VtaeHtGyOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBXaKs8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBXaKs8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F38C4CEE5;
	Thu, 13 Feb 2025 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458140;
	bh=SsbSo7L4SOreKGgca9NtDz81mjuBdUrv90yjDU8/Bww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBXaKs8d4gg1+RBWDlGQN40spbrZTWt4Lu3/TM9rP2lZvyPz04XLke54RFxWK5cD7
	 IBGZqA5TKHcRX+aBQQKUN6f9vdxEuQyavvKZLRrEfplTaGk3OrO8iiR/pZZ6PxjXqp
	 oNt5PQ+Tg1HKXkf+yKX8v49bE0EnhlsJoVHEUIaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.12 314/422] iommufd/fault: Destroy response and mutex in iommufd_fault_destroy()
Date: Thu, 13 Feb 2025 15:27:43 +0100
Message-ID: <20250213142448.664680245@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 3f4818ec139030f425476bf8a10b616bab53a7b5 upstream.

Both were missing in the initial patch.

Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Link: https://patch.msgid.link/r/bc8bb13e215af27e62ee51bdba3648dd4ed2dce3.1736923732.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/fault.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -208,6 +208,7 @@ void iommufd_fault_destroy(struct iommuf
 {
 	struct iommufd_fault *fault = container_of(obj, struct iommufd_fault, obj);
 	struct iopf_group *group, *next;
+	unsigned long index;
 
 	/*
 	 * The iommufd object's reference count is zero at this point.
@@ -220,6 +221,13 @@ void iommufd_fault_destroy(struct iommuf
 		iopf_group_response(group, IOMMU_PAGE_RESP_INVALID);
 		iopf_free_group(group);
 	}
+	xa_for_each(&fault->response, index, group) {
+		xa_erase(&fault->response, index);
+		iopf_group_response(group, IOMMU_PAGE_RESP_INVALID);
+		iopf_free_group(group);
+	}
+	xa_destroy(&fault->response);
+	mutex_destroy(&fault->mutex);
 }
 
 static void iommufd_compose_fault_message(struct iommu_fault *fault,


