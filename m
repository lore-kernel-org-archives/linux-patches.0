Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3CF215764;
	Thu, 12 Dec 2024 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016174; cv=none; b=ofp0KeQ4O5UczriNSvgMMlk2JNam1smxgNrTeCeKrUWx6H5Mf6iAjGyhH8f3Vdh8m/bCZAjdRYGDTE3OdLgtq755JkCym2jG1fV76bK7xc/4FxA0vj0rTCQW+FGx1REFP7Ogtv8kCHbtAG9TxUvXrUMp6kKRqcD9aPmzjvQEiRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016174; c=relaxed/simple;
	bh=pOaXTeQyLgpt1RAPzKOq4mEDsbQfwb3XHj+jsN2yZ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEQH0IgTfW31NPhYrWRyRuW7GzeknjMfXk2DsLXDRq+gkf5BLPnpb8WDLQAwpTRI3RV3ycih0/QpMX6f7ljlCqZYH7cadfZXhd3Xv6QKZGWL0poE2LxVMEhwCCHhQoByZIx5xfeRDJOZvyBN9n0l214qsIPw3WKI7CdwQi8MsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tq2ZlVBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tq2ZlVBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27EAC4CECE;
	Thu, 12 Dec 2024 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016173;
	bh=pOaXTeQyLgpt1RAPzKOq4mEDsbQfwb3XHj+jsN2yZ1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tq2ZlVBQUu9TOaaJnzUBiZNEVWr+MIzHJOqZBKGwMpksPLkcWNPaHFbHNi1l4wzfu
	 vqOpHunp/NXIDpB0nBm5m+9TUOn2iAtZieCuE5KJk+6jq8AZfR2AJiSyI4MJ53+Df7
	 vju39XbxBvVcCqzY1hgeIuz3eJeqW2ToN5lSl1w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 133/466] iommufd: Fix out_fput in iommufd_fault_alloc()
Date: Thu, 12 Dec 2024 15:55:02 +0100
Message-ID: <20241212144312.060422762@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit af7f4780514f850322b2959032ecaa96e4b26472 upstream.

As fput() calls the file->f_op->release op, where fault obj and ictx are
getting released, there is no need to release these two after fput() one
more time, which would result in imbalanced refcounts:
  refcount_t: decrement hit 0; leaking memory.
  WARNING: CPU: 48 PID: 2369 at lib/refcount.c:31 refcount_warn_saturate+0x60/0x230
  Call trace:
   refcount_warn_saturate+0x60/0x230 (P)
   refcount_warn_saturate+0x60/0x230 (L)
   iommufd_fault_fops_release+0x9c/0xe0 [iommufd]
  ...
  VFS: Close: file count is 0 (f_op=iommufd_fops [iommufd])
  WARNING: CPU: 48 PID: 2369 at fs/open.c:1507 filp_flush+0x3c/0xf0
  Call trace:
   filp_flush+0x3c/0xf0 (P)
   filp_flush+0x3c/0xf0 (L)
   __arm64_sys_close+0x34/0x98
  ...
  imbalanced put on file reference count
  WARNING: CPU: 48 PID: 2369 at fs/file.c:74 __file_ref_put+0x100/0x138
  Call trace:
   __file_ref_put+0x100/0x138 (P)
   __file_ref_put+0x100/0x138 (L)
   __fput_sync+0x4c/0xd0

Drop those two lines to fix the warnings above.

Cc: stable@vger.kernel.org
Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Link: https://patch.msgid.link/r/b5651beb3a6b1adeef26fffac24607353bf67ba1.1733212723.git.nicolinc@nvidia.com
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/fault.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -415,8 +415,6 @@ out_put_fdno:
 	put_unused_fd(fdno);
 out_fput:
 	fput(filep);
-	refcount_dec(&fault->obj.users);
-	iommufd_ctx_put(fault->ictx);
 out_abort:
 	iommufd_object_abort_and_destroy(ucmd->ictx, &fault->obj);
 


