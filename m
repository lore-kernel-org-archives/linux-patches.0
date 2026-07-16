Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50369322A1F;
	Thu, 16 Jul 2026 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210094; cv=none; b=Z5kE2LmoJ4VqoYVxM8hkDtORL/f57cB7UCyTVkQE1QPxhw7cBkk7KKKveXWQN+m6fBXpsuoloog+zprzWi14lLqnPlWfmc77Zks3eGqTIYKtbj73VZDXPoUFbOeP3M4SwJL1J237PJ4hKOxPUnPAy7LS1K7IJgBTqOMAZvAlzYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210094; c=relaxed/simple;
	bh=OuZmm9d8b6WneCikAfV/f4BSLu6vWOkHYdyNfbBnCtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drFKTYg6UIWp2pwMgnxqKwwwlNTCzD5Gxti58+mWNSAl9k8RJpBDNtlin41o7pP80YFfZ7LNQTRdROp17LbUc2sA4RTXscW2KBLXDvTk6n+OBovu5q/1qZ/o1KCAmdlE/vIs0eKMUDm7rN1I+8LTGx1XxjhbHRRWyLZw/ouZQH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CN1cSbpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CN1cSbpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA49B1F000E9;
	Thu, 16 Jul 2026 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210093;
	bh=HqieAL4Y1IGtS98xH0jH0vrI/NmgzOSpV5xg1z/eJBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CN1cSbpJ5P1pwoMY5hB+CdxwzeaL8qlBy1g9k9CmJzXK8DjhTpY2fkFgQg6XtueLX
	 XoCbBESsW2eqKFV+HQlV2jTU45coS2Gp3fqnlo58g2V/yO+Y2tEPb8VRtf/4ZQ47Vm
	 g7qvUzDkPxPWzLt8BuOqhU+PgTWdkDdwdqE9kZcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 7.1 434/518] iommufd: Fix data_len byte-count vs element-count mismatch
Date: Thu, 16 Jul 2026 15:31:42 +0200
Message-ID: <20260716133057.340525441@linuxfoundation.org>
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

commit 85345becfead3255a5f875d4b4d82ea01d926239 upstream.

kzalloc_flex() computes the allocation size. With event_data typed as u64,
data_len is interpreted as a u64 element count. Yet, every caller and the
read path treat data_len as a byte count. The current code over-allocates
by sizeof(u64) and the __counted_by() annotation overstates the length by
the same factor.

Re-type event_data as u8. No functional change in user-visible behavior.

Fixes: e36ba5ab808e ("iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC")
Link: https://patch.msgid.link/r/f7665f839b9dce917d6bd394375a1cf56568d86b.1779408671.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/iommufd_private.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -602,7 +602,7 @@ struct iommufd_vevent {
 	struct iommufd_vevent_header header;
 	struct list_head node; /* for iommufd_eventq::deliver */
 	ssize_t data_len;
-	u64 event_data[] __counted_by(data_len);
+	u8 event_data[] __counted_by(data_len);
 };
 
 #define vevent_for_lost_events_header(vevent) \


