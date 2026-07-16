Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5529B22301;
	Thu, 16 Jul 2026 13:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210107; cv=none; b=nR2Lckv5GCsPZHhenL+4ZV8WZfDgwlfxAK5Iqaa/D552/PoaHn6ENXEuWpT8sSwd5csQdECS8IVq7Ee+pfZT2BUvfnPXXW5yVS2T43egKkFBG+Sd15aPoCxSFZ/ueX/HrCt1xojJSo6pHo9zr9yiQDE6nHJi64QkAT5z1H3VBAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210107; c=relaxed/simple;
	bh=0kuKDOpce1UJBSCa5tEyMpH/rsD4QjCGuGVUVLxSqM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcmouQH+hVSuyR/kktlALkW5ykeXPOeRc0mLDjYXO408a8Eev3uaXC8OfHWzvjSZrjUKhhSMYX9jFBxPcC0QjeZmnJywz2iz728RX7G3Donc03+e6/W/b1OJ5NlVayICxCuiHHURWm7hStClaUfEotDLNTP+DpH4+cE63bb1Lic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4fQ1FBF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4fQ1FBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA761F000E9;
	Thu, 16 Jul 2026 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210106;
	bh=Y81g0Q1yFp8IEr6aLNHqo7PimbuHt4qhjEzG8844lgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4fQ1FBFeu/uuxCBX5d4dZu974drK8AAxcUjNJFrCr8Ku8K8JNYXyakOiRwrZYpGg
	 1+06ZxBMXsjShwz8WqQnCLlT7v9SgQusmLFRvQ7rzZm8HT8kWWoJxe+YNBK55h8uGP
	 Mp3o64kcdvlUIgvxNoqu1Dvg6Du8lsAjePo8rsdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 438/518] iommufd: Reject invalid read count in iommufd_veventq_fops_read()
Date: Thu, 16 Jul 2026 15:31:46 +0200
Message-ID: <20260716133057.425473571@linuxfoundation.org>
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

commit 00203ca8323f9714630408c19a209b52397975e6 upstream.

The read count must be large enough to hold a vEVENT header. For a normal
vEVENT, it must also hold the trailing data following the header.

iommufd_veventq_fops_read() does not validate the count, but returns 0 as
if the read had succeeded while leaving the pending event in the queue.

Return -EINVAL in both undersize cases.

Fixes: e36ba5ab808e ("iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC")
Link: https://patch.msgid.link/r/e1111adcc8a8882fbfd84accd6674dc846dc5689.1780343944.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -310,6 +310,9 @@ static ssize_t iommufd_veventq_fops_read
 
 	if (*ppos)
 		return -ESPIPE;
+	/* Minimum read count is a vEVENT header */
+	if (count < sizeof(*hdr))
+		return -EINVAL;
 
 	while ((cur = iommufd_veventq_deliver_fetch(veventq))) {
 		/* Validate the remaining bytes against the header size */
@@ -323,6 +326,9 @@ static ssize_t iommufd_veventq_fops_read
 		if (!vevent_for_lost_events_header(cur) &&
 		    sizeof(*hdr) + cur->data_len > count - done) {
 			iommufd_veventq_deliver_restore(veventq, cur);
+			/* Read count doesn't fit a single normal vEVENT */
+			if (done == 0)
+				rc = -EINVAL;
 			break;
 		}
 


