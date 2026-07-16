Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED85022301;
	Thu, 16 Jul 2026 13:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210110; cv=none; b=ojnU7TEut96U8oHc4eFOSaYFwGdiarB2565meDpIoJk/0BPkhymHU/BN67iSZlYvxc+VwmJ+jWF92Ff+hawaTFNhi1lif39R/wKFac8htdNGjDeIlOoVgu1lD+K38+cs7KJZUtKoAdqZZUglbFhKoPIG7ROUqfC/0nPDZNtm01M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210110; c=relaxed/simple;
	bh=ZTEj5kDbEH/HfTcOFd1SrAnjYRcsUq8zLcuEIGI4upU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIk8GcyuAK2mamaNeFWaR8p2AkbTz0rTjIqknnq1BticuSUUJHuqAuLRRq2MsF0zY+c52ZVYs3RTqec/qGS9pU7jqvGEmkvjqiq+hVJybbGcr+XrdAHwpPhJHERwNVntr2gPZmFhmIEYu27rGeMfNjEjTb5lVfbpwjSPseilFqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6qh/5ZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6qh/5ZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5391F000E9;
	Thu, 16 Jul 2026 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210108;
	bh=27pM7y8oM1ullJ71Yd0KMnqDlC9Wg/oOib/XgzsppFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6qh/5ZIHjZdKlIHm+1m1tfoddmbvZeG3PiZw7zeRY/COnUyNp6q8IGSHMC8X5lNG
	 F9NcVh6FYDlA1pchz2YiF23ueGbI0TI06glmRgYXlPUWqKSD0ReR5+xXN1LPh/YFGY
	 q2qHe8uOs5cGoXuF8FVuVvmb2+TWz0J8n/mTXJd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 439/518] iommufd: Propagate allocation failure in iommufd_veventq_deliver_fetch()
Date: Thu, 16 Jul 2026 15:31:47 +0200
Message-ID: <20260716133057.446852710@linuxfoundation.org>
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

commit 489e63dd120bad52eba63f5506c214750cd5bc75 upstream.

When the kzalloc_obj() fails in iommufd_veventq_deliver_fetch(), it returns
NULL, falsely advertising to userspace that the queue is empty.

Propagate the -ENOMEM properly to the caller.

Fixes: e36ba5ab808e ("iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC")
Link: https://patch.msgid.link/r/25d29feac909e36f78c145fa99ef2d4cb7a415da.1780343944.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -264,8 +264,10 @@ iommufd_veventq_deliver_fetch(struct iom
 		/* Make a copy of the lost_events_header for copy_to_user */
 		if (next == &veventq->lost_events_header) {
 			vevent = kzalloc_obj(*vevent, GFP_ATOMIC);
-			if (!vevent)
+			if (!vevent) {
+				vevent = ERR_PTR(-ENOMEM);
 				goto out_unlock;
+			}
 		}
 		list_del(&next->node);
 		if (vevent)
@@ -315,6 +317,12 @@ static ssize_t iommufd_veventq_fops_read
 		return -EINVAL;
 
 	while ((cur = iommufd_veventq_deliver_fetch(veventq))) {
+		if (IS_ERR(cur)) {
+			if (done == 0)
+				rc = PTR_ERR(cur);
+			break;
+		}
+
 		/* Validate the remaining bytes against the header size */
 		if (done >= count || sizeof(*hdr) > count - done) {
 			iommufd_veventq_deliver_restore(veventq, cur);


