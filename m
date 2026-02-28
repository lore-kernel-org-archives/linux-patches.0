Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4403734164B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301169; cv=none; b=D9tIDN3qjdgVYx1GwRcif9N+RW3g3bqJsmD2b+5xL5ZNSjNFJdueMuYDL4HxxQnViJ+s2RjtqLB9dPJBYRYkYhmGESgPzv2CenKmfR57KnELDC5uEVy0FkfJo8G/iVpJcqyXPCHyvDhAlLNpstqZepwcZUMIrc6ViL3mtobyk20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301169; c=relaxed/simple;
	bh=wa9SgM5VuYcoV5xYsyuevJVQEAqVrSY4rN/akS6gnJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV3V13moMvfZZmvyoUYE1kUWuEAOeOCp6Pu8Cvdp8SN5rY1FKdkS9q8CeFjAHiWAjlO50ClcnQhAzkeyPeFBuUPhjTBGhjfEmjMJN9R/ploETR47HGibMN9zqti+G5Ktd2ozzzb+fWh1E4Ip7T9GPW+Vix7dZxJI3Vr0fmA0dpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFUszBz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFUszBz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED3CC19425;
	Sat, 28 Feb 2026 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301169;
	bh=wa9SgM5VuYcoV5xYsyuevJVQEAqVrSY4rN/akS6gnJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFUszBz9z/9KDN3NPfYsNS0pUNP/DswSTT8cAJi1sLjKIkuI70IovGjQKf6kdjrLt
	 7Dv+5lXxIEXuZkNfG7pq7qcoI322C1YjarYL4m4GQI/+IQRs6lkyICs43lltFDeAP0
	 mDYV53sILM8zvRn9eU7i5k8f8S574oXoIihNjdn8Lr5AZQPPrDf099snXG70dQqKn/
	 Bu7pDAiauxQOljdLYRuBd0N3v+Z4d/ifgm/niFaQLnd9LUtWp9iGis4303nUEdoT8Z
	 SGcfr7nVY5KzogaFJ5vjdbd/0+tedLH7YIonDT0G4u5hqnKx1uTadLRAQGZh+1V3o1
	 4G45SiTDUhDsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tuo Li <islituo@gmail.com>,
	Scott Branden <scott.branden@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 335/752] misc: bcm_vk: Fix possible null-pointer dereferences in bcm_vk_read()
Date: Sat, 28 Feb 2026 12:40:46 -0500
Message-ID: <20260228174750.1542406-335-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tuo Li <islituo@gmail.com>

[ Upstream commit ba75ecb97d3f4e95d59002c13afb6519205be6cb ]

In the function bcm_vk_read(), the pointer entry is checked, indicating
that it can be NULL. If entry is NULL and rc is set to -EMSGSIZE, the
following code may cause null-pointer dereferences:

  struct vk_msg_blk tmp_msg = entry->to_h_msg[0];
  set_msg_id(&tmp_msg, entry->usr_msg_id);
  tmp_msg.size = entry->to_h_blks - 1;

To prevent these possible null-pointer dereferences, copy to_h_msg,
usr_msg_id, and to_h_blks from iter into temporary variables, and return
these temporary variables to the application instead of accessing them
through a potentially NULL entry.

Signed-off-by: Tuo Li <islituo@gmail.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Link: https://patch.msgid.link/20251211063637.3987937-1-islituo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/bcm-vk/bcm_vk_msg.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/bcm-vk/bcm_vk_msg.c b/drivers/misc/bcm-vk/bcm_vk_msg.c
index 1f42d1d5a630a..665a3888708ac 100644
--- a/drivers/misc/bcm-vk/bcm_vk_msg.c
+++ b/drivers/misc/bcm-vk/bcm_vk_msg.c
@@ -1010,6 +1010,9 @@ ssize_t bcm_vk_read(struct file *p_file,
 	struct device *dev = &vk->pdev->dev;
 	struct bcm_vk_msg_chan *chan = &vk->to_h_msg_chan;
 	struct bcm_vk_wkent *entry = NULL, *iter;
+	struct vk_msg_blk tmp_msg;
+	u32 tmp_usr_msg_id;
+	u32 tmp_blks;
 	u32 q_num;
 	u32 rsp_length;
 
@@ -1034,6 +1037,9 @@ ssize_t bcm_vk_read(struct file *p_file,
 					entry = iter;
 				} else {
 					/* buffer not big enough */
+					tmp_msg = iter->to_h_msg[0];
+					tmp_usr_msg_id = iter->usr_msg_id;
+					tmp_blks = iter->to_h_blks;
 					rc = -EMSGSIZE;
 				}
 				goto read_loop_exit;
@@ -1052,14 +1058,12 @@ ssize_t bcm_vk_read(struct file *p_file,
 
 		bcm_vk_free_wkent(dev, entry);
 	} else if (rc == -EMSGSIZE) {
-		struct vk_msg_blk tmp_msg = entry->to_h_msg[0];
-
 		/*
 		 * in this case, return just the first block, so
 		 * that app knows what size it is looking for.
 		 */
-		set_msg_id(&tmp_msg, entry->usr_msg_id);
-		tmp_msg.size = entry->to_h_blks - 1;
+		set_msg_id(&tmp_msg, tmp_usr_msg_id);
+		tmp_msg.size = tmp_blks - 1;
 		if (copy_to_user(buf, &tmp_msg, VK_MSGQ_BLK_SIZE) != 0) {
 			dev_err(dev, "Error return 1st block in -EMSGSIZE\n");
 			rc = -EFAULT;
-- 
2.51.0

