Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6976536A378;
	Tue, 12 May 2026 17:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608260; cv=none; b=noONy0LMoT+7UCkToHscbEoz+7ZkZx40nUpQIgN/KuyYVJi5Ir5NZt24eqcj8KqeMMjAmB1nw4+xgtVLrT4BBU7nCt9rcTPNyfRczUWrmZuRmmfPwlozweiXvYHH1cvCGCKaD0EaACT9St0RAPm6uvB0/gmGtPP51/2ZDGQ1Kco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608260; c=relaxed/simple;
	bh=L2/JZ3+07AAfHYvDHG5n8dW7mPFWYBlj0RbjGFHAt2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa2ChdsJSZMRA9XGFMbnqeO0ls72YCRKwXwWVLFMU0scUQLbsbNR26D0XcYkBi3Zp0FEIc6Y5bMPaC09EFkwVWEmLuYvqmRxRSlrM6T4w4hoVK6pnPLDlNb/tyPQtZJyxgf3bF9pM6zMg81AAJ8BYFsCr+7zRPbqARHA0gfLgLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQ5KYvxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQ5KYvxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F340CC2BCB0;
	Tue, 12 May 2026 17:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608260;
	bh=L2/JZ3+07AAfHYvDHG5n8dW7mPFWYBlj0RbjGFHAt2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQ5KYvxnTnTxSaNPuLkPtJaxBAgx3We27A+rhRUEXBG6Oj3DHie4gucHgdcpP5/iu
	 jPEEVP7pV6EgtDTKqt91aa9yqOUsMKoYWPVgJCm4LcQVPB5X3cMNVJnLsOHIaUauY0
	 CN5yaY66M7dtPL+5Ow08QYhi+RQd4n/GUNKfLCI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sina Hassani <sina@openai.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 011/270] iommufd: Fix a race with concurrent allocation and unmap
Date: Tue, 12 May 2026 19:36:52 +0200
Message-ID: <20260512173938.692378023@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Sina Hassani <sina@openai.com>

commit 8602018b1f17fbdaa5e5d79f4c8603ad20640c12 upstream.

iopt_unmap_iova_range() releases the lock on iova_rwsem inside the loop
body when getting to the more expensive unmap operations. This is fine on
its own, except the loop condition is based on the first area that matches
the unmap address range. If a concurrent call to map picks an area that
was unmapped in previous iterations, the loop mistakenly tries to unmap
it.

This is reproducible by having one userspace thread map buffers and pass
them to another thread that unmaps them. The problem manifests as EBUSY
errors with single page mappings.

Fix this by advancing the start pointer after unmapping an area. This
ensures each iteration only examines the IOVA range that remains mapped,
which is guaranteed not to have overlaps.

Cc: stable@vger.kernel.org
Fixes: 51fe6141f0f6 ("iommufd: Data structure to provide IOVA to PFN mapping")
Link: https://patch.msgid.link/r/CAAJpGJSR4r_ds1JOjmkqHtsBPyxu8GntoeW08Sk5RNQPmgi+tg@mail.gmail.com
Signed-off-by: Sina Hassani <sina@openai.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/io_pagetable.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -777,6 +777,16 @@ again:
 		unmapped_bytes += area_last - area_first + 1;
 
 		down_write(&iopt->iova_rwsem);
+
+		/*
+		 * After releasing the iova_rwsem concurrent allocation could
+		 * place new areas at IOVAs we have already unmapped. Keep
+		 * moving the start of the search forward to ignore the area
+		 * already unmapped.
+		 */
+		if (area_last >= last)
+			break;
+		start = area_last + 1;
 	}
 
 out_unlock_iova:


