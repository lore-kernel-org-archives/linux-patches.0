Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE68C1E04B8;
	Wed, 19 Feb 2025 08:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955173; cv=none; b=RXK6wTBsvu6z8s7zZWOMDAXEIYHkn1FXvQ82CJb5hKJ8G+MPzfqWr6L9kKEpxqmidioT5Ln2TXxKLkdfpTFO7AMsaYFqvSSacBhvAlQjO1dvF8xRGWLJ8kunAaIyVYYIESzU2p/PSllD6BBd18fdP/ogg808lPj4AwediWX3s0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955173; c=relaxed/simple;
	bh=pNTqSBkiHs87sc5WfmhWyHL93om9C4QqrUZje59xHBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soMFg0wPJDOez/OyTDwwp2VC5hNGDWrHQKHC22Zh5lGu2jWeOn3R3vS0lyoE/r0pzvqqMuyJimdaYD/Rei+q7mNAXtlY5fe1VBR4BxxIChccmZ7s0Y5249rE6DB3XS+8omSsRcY07Q3Wdpbw+aEpC7m63QxnCHm5Szr5eBwm8WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nivcEaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nivcEaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618E7C4CEE6;
	Wed, 19 Feb 2025 08:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955172;
	bh=pNTqSBkiHs87sc5WfmhWyHL93om9C4QqrUZje59xHBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nivcEaaLGJFvvQ0OyeSHsvyJ5jFmhH80cjRsDTSFcdm+TtQK2ZosB9Faa72BTTth
	 Z2dx8y6UepXEZDzaQjWYpZMyQNLn6Pss0RIiRVOB83BNwheeTUn8RQI0cagGaqt4hl
	 spRrIMFLFYtPXLuPoZb8vISVTMkKBTNHyJ4irfkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.12 155/230] iommu: Fix potential memory leak in iopf_queue_remove_device()
Date: Wed, 19 Feb 2025 09:27:52 +0100
Message-ID: <20250219082607.756797395@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 9759ae2cee7cd42b95f1c48aa3749bd02b5ddb08 upstream.

The iopf_queue_remove_device() helper removes a device from the per-iommu
iopf queue when PRI is disabled on the device. It responds to all
outstanding iopf's with an IOMMU_PAGE_RESP_INVALID code and detaches the
device from the queue.

However, it fails to release the group structure that represents a group
of iopf's awaiting for a response after responding to the hardware. This
can cause a memory leak if iopf_queue_remove_device() is called with
pending iopf's.

Fix it by calling iopf_free_group() after the iopf group is responded.

Fixes: 199112327135 ("iommu: Track iopf group instead of last fault")
Cc: stable@vger.kernel.org
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250117055800.782462-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/io-pgfault.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -478,6 +478,7 @@ void iopf_queue_remove_device(struct iop
 
 		ops->page_response(dev, iopf, &resp);
 		list_del_init(&group->pending_node);
+		iopf_free_group(group);
 	}
 	mutex_unlock(&fault_param->lock);
 


