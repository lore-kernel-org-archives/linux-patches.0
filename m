Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF2346EF81;
	Tue, 21 Jul 2026 18:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659647; cv=none; b=MhJfEd0zEvypl/2OUemcZ7uPW2Eb65TZuBWQR/6gbn58t+BJeBm3xn4VGmqkCsYQTLtBAMA3SfmvaD1wvIUC/r6qyawFCHrgjIA5fmaDGRAt8SgEyCYjCjLo4AKdb++VcDTBNwJgpOCrlLFtaBkJ2WXkMCT/AnQUmnWsfLWqlqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659647; c=relaxed/simple;
	bh=ECQz8g0vHC/KiiNtcUHf4fPj62Jc+4G6ayxZMhgaObw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMuor02snCVgw5Z0xEcH9lQiqrznMqwHm6Q/R1T5XkKuRNqlcQe3YLClXVr/cgcYNtP9j2+SaeSxShdnjO7/fdvxSNX5bT/l8viJ4Vrl9lNIrghWx56hKjur6Q5Q/NKGEYrYpxdN8dIx8OTvE0XLxL0Okj8j5PIiwsNcK2ljA34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCBU/Cuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCBU/Cuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7261F000E9;
	Tue, 21 Jul 2026 18:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659645;
	bh=lfXqEZzeL6/8odMnqcqSj8yJxTGG2QOBx5TOweAfD74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCBU/Cuz0wCPjTYEOX1eu/mO2W5l/MVULhHS2RpDyZkpf7Dnhdz5UUtDyGx3AeJ9k
	 +SXQYbO8r6qUKIeXZXv0F7RzFM8OC/Sf4SZ4tceA/J89Isx45L8Iyj8h8qCrZiLaL6
	 Wh/x9DY9l0hw2Di2h7i2efP7dvXB2xHXFtnXB62o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1599/1611] iommufd: Propagate allocation failure in iommufd_veventq_deliver_fetch()
Date: Tue, 21 Jul 2026 17:28:35 +0200
Message-ID: <20260721152551.441474378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 489e63dd120bad52eba63f5506c214750cd5bc75 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -272,8 +272,10 @@ iommufd_veventq_deliver_fetch(struct iom
 		/* Make a copy of the lost_events_header for copy_to_user */
 		if (next == &veventq->lost_events_header) {
 			vevent = kzalloc(sizeof(*vevent), GFP_ATOMIC);
-			if (!vevent)
+			if (!vevent) {
+				vevent = ERR_PTR(-ENOMEM);
 				goto out_unlock;
+			}
 		}
 		list_del(&next->node);
 		if (vevent)
@@ -323,6 +325,12 @@ static ssize_t iommufd_veventq_fops_read
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


