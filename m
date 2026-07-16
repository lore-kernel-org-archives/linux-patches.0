Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66BF22301;
	Thu, 16 Jul 2026 13:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210112; cv=none; b=aGC1pvi3Y3H0UmKVvikknK8v4GsLisixThR1PKI4JtFLxh7TbRgVhLNwTt92UElaXG2uNMW2rkdqcBg4iN1HL+wbvC7at53niDf+fUswc1KrBDGHhHhTBEYJz/rUKG6ExXH6PI83m7sHE9R2H4hAAYIxJqVpHAgDof10ivU91ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210112; c=relaxed/simple;
	bh=Lb0QzgxtvbAl+IUYsMjxu0+kJKAGBCVI1MIFBVXa99Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYqGYaEDyJs/7PgF4OQb7BKd5iw+kAGzNa82US9Q8uGfndXiHWTmide5QKAcD3GnY6xG+rkeLngGdE/O/YkdKFgmcysdujntoc/taoUF6kwICnp9cLe2jIMkDSjnQAUclLC7XA12lIIj7FKCHCnoqF2RiU3FAJQzYeM7e8J8qyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBokp1Z/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBokp1Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0218A1F000E9;
	Thu, 16 Jul 2026 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210111;
	bh=mXOiTqc7NFS+EMU98aQpWziLJW0DMd0cUHlDyPV6Ftc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBokp1Z/w8s5iHxzVpkARWFSCPA4nQazmeQcbusy3mWR6T2vEdj+P/k8AnJzjNNYO
	 Tnj8xMeePq2rR+ri/qEXmB23QslLDa+6nIijT8Yd1Att3bmiYt2N33DBqEVpoYNovr
	 nZeSgKLeeQjTZPd8jp0vdNFW4cwOPUyKDQPj28zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 440/518] iommufd: Reject invalid read count in iommufd_fault_fops_read()
Date: Thu, 16 Jul 2026 15:31:48 +0200
Message-ID: <20260716133057.467288673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


