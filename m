Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6755A34A773;
	Tue, 12 May 2026 18:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608961; cv=none; b=Qm1Cri4mKzt9wmplctkIGvjQMRZEi2dEjpKRWHqD9FZtkwIwrFGuXjaSbdudAHfyHL6sWR4yodxlWGCXgsieO1JuBv2xcx0YU3ofb+gi82Xx0gq8jCDL7Klj9WCtgZXfimSrS7qX3wkRaojVL7939L+eDrZqVMYcqDgJB3Re8qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608961; c=relaxed/simple;
	bh=tRrl4Rd14N3xKFGjXVIoQIUlfeiaR0qYMqn6Wza+RVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahyv/Sd9OFeE98SNbxaLOAoX7Ybtnr2VXGD6MKpopzusxTC6a1IkVhzLpKiUx3Vl4d1wYWwA+5Yp8/ica5l+q0Vkd9QTB0oD9K9B/lbTEt8qe1+T/VawY+7UaXB34zPGj7n8WmTpdO4gkiLnxZqyBwOeX4SPXNKop6b0FnI8OqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feVe62+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feVe62+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AA4C2BCB0;
	Tue, 12 May 2026 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608961;
	bh=tRrl4Rd14N3xKFGjXVIoQIUlfeiaR0qYMqn6Wza+RVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feVe62+Rc+f/bTI2e95MUW002iLhKxGDeVUl1cg1M/p1smMHz2/iaGyQ/FErjdY90
	 A2f6iYsoXfj5oXLQPaw3ehEY7sRBOHjqdrdp95D5ktlPMmxqEuIHLg7i3WgcrdfzhH
	 JWYPbFmxHsU7nnmCqgXgHcDQdIQRDQOMBGXBB8KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sina Hassani <sina@openai.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 012/307] iommufd: Fix a race with concurrent allocation and unmap
Date: Tue, 12 May 2026 19:36:47 +0200
Message-ID: <20260512173940.384716940@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -814,6 +814,16 @@ again:
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


