Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63051355026;
	Tue, 16 Dec 2025 11:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885915; cv=none; b=MKa0YuQl3nqMQhPLPFuiTWHWftE/bbUDE7WSKf5+8llcBPeqZEjtYkqarJfykiYV4kz8vLLdSmtpdqlhBj6SGaP6wlNY/8zzbl9QBFuVvUjma1xEjZsV9+Hroq2Hnb8mMs0Lk2Bac3eIG53JB4p7BFOd/aVBx+4Lxc9SX2iAuzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885915; c=relaxed/simple;
	bh=CGRsz9c0j0fiw/czQRVnwcaZKMtVKlJwXcriLbkX/Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAseitulXW8m6KfQEaV8Fey+z4ZfbEk+2+1f9/ZsMiabYEP8HG1CaenpqsNogVvc+oN82EApkaz2kci7tDNh3yjhxhW4ml3GMVOjK1CK3t4LxxSGO/cGPupY/LUkboKFbJclhtQc1Gp71jNpJ74cJjprYaOfnmfkcXB4C4ThTp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQ+MRxHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQ+MRxHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E79C4CEF1;
	Tue, 16 Dec 2025 11:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885915;
	bh=CGRsz9c0j0fiw/czQRVnwcaZKMtVKlJwXcriLbkX/Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQ+MRxHFTPz49gzho2tBD7yx2MCRuYWM/X9shV0iJev2T9UXo3pv542llw/SVuB3x
	 0TtNE6vOb+ALwWuTYt4SYVSIQxy2A9ZyESRowHRCQ59NoE+mtNrfUCyfG077xN+qac
	 D54LBeVuJkEy8v0DwgDLPWHnb67JhCrsrAVXUokY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mkhlinux@outlook.com>,
	Roman Kisel <romank@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 249/507] Drivers: hv: Free msginfo when the buffer fails to decrypt
Date: Tue, 16 Dec 2025 12:11:30 +0100
Message-ID: <20251216111354.515090883@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Kisel <romank@linux.microsoft.com>

[ Upstream commit 510164539f16062e842a9de762616b5008616fa1 ]

The early failure path in __vmbus_establish_gpadl() doesn't deallocate
msginfo if the buffer fails to decrypt.

Fix the leak by breaking out the cleanup code into a separate function
and calling it where required.

Fixes: d4dccf353db80 ("Drivers: hv: vmbus: Mark vmbus ring buffer visible to host in Isolation VM")
Reported-by: Michael Kelley <mkhlinux@outlook.com>
Closes: https://lore.kernel.org/linux-hyperv/SN6PR02MB41573796F9787F67E0E97049D472A@SN6PR02MB4157.namprd02.prod.outlook.com
Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 1621b95263a5b..70270202209b6 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -410,6 +410,21 @@ static int create_gpadl_header(enum hv_gpadl_type type, void *kbuffer,
 	return 0;
 }
 
+static void vmbus_free_channel_msginfo(struct vmbus_channel_msginfo *msginfo)
+{
+	struct vmbus_channel_msginfo *submsginfo, *tmp;
+
+	if (!msginfo)
+		return;
+
+	list_for_each_entry_safe(submsginfo, tmp, &msginfo->submsglist,
+				 msglistentry) {
+		kfree(submsginfo);
+	}
+
+	kfree(msginfo);
+}
+
 /*
  * __vmbus_establish_gpadl - Establish a GPADL for a buffer or ringbuffer
  *
@@ -429,7 +444,7 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	struct vmbus_channel_gpadl_header *gpadlmsg;
 	struct vmbus_channel_gpadl_body *gpadl_body;
 	struct vmbus_channel_msginfo *msginfo = NULL;
-	struct vmbus_channel_msginfo *submsginfo, *tmp;
+	struct vmbus_channel_msginfo *submsginfo;
 	struct list_head *curr;
 	u32 next_gpadl_handle;
 	unsigned long flags;
@@ -459,6 +474,7 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 			dev_warn(&channel->device_obj->device,
 				"Failed to set host visibility for new GPADL %d.\n",
 				ret);
+			vmbus_free_channel_msginfo(msginfo);
 			return ret;
 		}
 	}
@@ -535,12 +551,8 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&msginfo->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-	list_for_each_entry_safe(submsginfo, tmp, &msginfo->submsglist,
-				 msglistentry) {
-		kfree(submsginfo);
-	}
 
-	kfree(msginfo);
+	vmbus_free_channel_msginfo(msginfo);
 
 	if (ret) {
 		/*
-- 
2.51.0



