Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38649223327;
	Mon,  2 Jun 2025 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873521; cv=none; b=FV6R9AEr3KWqaBew3kN9HaH+SG/Qv4guIXQAEZSsj4iMK3Zu7FJklqzak/z0QGUodrlnUtXovxW4gSfyMJdikFMxwu6GaOChntJbsqVsWm2Jzxvkv8t5Y/Z6MpnnVCeFMS1TfyzWyQGutTDTVnQD+snIjFcABq8OPxwtkxvOczA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873521; c=relaxed/simple;
	bh=j9ocBbGNKum7SdScqwYEGkdmiU1R+LYroLI1uksqVRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/P8mdZnw5OgAo5RCQEq0/Z1RxQd/02wES1fiG5icB0VNTbDOEGjDG1qOXoaK+TePpP5nTiHMKSugYY/av1uDkfhj2v5a8tQHMeBPnq/McvA6SPD2xGGHoqCexT5OUuDWVJ5qL7fLb4aBCYdJVGjDMl+2kMQTlhm4EqH0HFi8Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McUBTG41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McUBTG41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993E9C4CEEB;
	Mon,  2 Jun 2025 14:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873521;
	bh=j9ocBbGNKum7SdScqwYEGkdmiU1R+LYroLI1uksqVRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McUBTG417yR+KfYGL0SlJBXmBbq6sIGzx++S9abWQ6PmzuNPvEs39tzOKqCvMOkmK
	 MRptX1QCWE06BMIHavdON5YAGZ4DbE1jwXF1Dmul1RiNHHDuzOpDy2oJB47Rvk2oIm
	 CD89vSIUguLsMfhLWfhSF0JUtIePHTOzbMb2K68s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/444] soc: apple: rtkit: Implement OSLog buffers properly
Date: Mon,  2 Jun 2025 15:43:51 +0200
Message-ID: <20250602134347.679500800@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit a06398687065e0c334dc5fc4d2778b5b87292e43 ]

Apparently nobody can figure out where the old logic came from, but it
seems like it has never been actually used on any supported firmware to
this day. OSLog buffers were apparently never requested.

But starting with 13.3, we actually need this implemented properly for
MTP (and later AOP) to work, so let's actually do that.

Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Link: https://lore.kernel.org/r/20250226-apple-soc-misc-v2-2-c3ec37f9021b@svenpeter.dev
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/apple/rtkit-internal.h |  1 +
 drivers/soc/apple/rtkit.c          | 56 ++++++++++++++++++------------
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/soc/apple/rtkit-internal.h b/drivers/soc/apple/rtkit-internal.h
index 24bd619ec5e48..1da1dfd9cb199 100644
--- a/drivers/soc/apple/rtkit-internal.h
+++ b/drivers/soc/apple/rtkit-internal.h
@@ -48,6 +48,7 @@ struct apple_rtkit {
 
 	struct apple_rtkit_shmem ioreport_buffer;
 	struct apple_rtkit_shmem crashlog_buffer;
+	struct apple_rtkit_shmem oslog_buffer;
 
 	struct apple_rtkit_shmem syslog_buffer;
 	char *syslog_msg_buffer;
diff --git a/drivers/soc/apple/rtkit.c b/drivers/soc/apple/rtkit.c
index b9c5281c445ee..2c37216f423d2 100644
--- a/drivers/soc/apple/rtkit.c
+++ b/drivers/soc/apple/rtkit.c
@@ -66,8 +66,9 @@ enum {
 #define APPLE_RTKIT_SYSLOG_MSG_SIZE  GENMASK_ULL(31, 24)
 
 #define APPLE_RTKIT_OSLOG_TYPE GENMASK_ULL(63, 56)
-#define APPLE_RTKIT_OSLOG_INIT	1
-#define APPLE_RTKIT_OSLOG_ACK	3
+#define APPLE_RTKIT_OSLOG_BUFFER_REQUEST 1
+#define APPLE_RTKIT_OSLOG_SIZE GENMASK_ULL(55, 36)
+#define APPLE_RTKIT_OSLOG_IOVA GENMASK_ULL(35, 0)
 
 #define APPLE_RTKIT_MIN_SUPPORTED_VERSION 11
 #define APPLE_RTKIT_MAX_SUPPORTED_VERSION 12
@@ -256,15 +257,21 @@ static int apple_rtkit_common_rx_get_buffer(struct apple_rtkit *rtk,
 					    struct apple_rtkit_shmem *buffer,
 					    u8 ep, u64 msg)
 {
-	size_t n_4kpages = FIELD_GET(APPLE_RTKIT_BUFFER_REQUEST_SIZE, msg);
 	u64 reply;
 	int err;
 
+	/* The different size vs. IOVA shifts look odd but are indeed correct this way */
+	if (ep == APPLE_RTKIT_EP_OSLOG) {
+		buffer->size = FIELD_GET(APPLE_RTKIT_OSLOG_SIZE, msg);
+		buffer->iova = FIELD_GET(APPLE_RTKIT_OSLOG_IOVA, msg) << 12;
+	} else {
+		buffer->size = FIELD_GET(APPLE_RTKIT_BUFFER_REQUEST_SIZE, msg) << 12;
+		buffer->iova = FIELD_GET(APPLE_RTKIT_BUFFER_REQUEST_IOVA, msg);
+	}
+
 	buffer->buffer = NULL;
 	buffer->iomem = NULL;
 	buffer->is_mapped = false;
-	buffer->iova = FIELD_GET(APPLE_RTKIT_BUFFER_REQUEST_IOVA, msg);
-	buffer->size = n_4kpages << 12;
 
 	dev_dbg(rtk->dev, "RTKit: buffer request for 0x%zx bytes at %pad\n",
 		buffer->size, &buffer->iova);
@@ -289,11 +296,21 @@ static int apple_rtkit_common_rx_get_buffer(struct apple_rtkit *rtk,
 	}
 
 	if (!buffer->is_mapped) {
-		reply = FIELD_PREP(APPLE_RTKIT_SYSLOG_TYPE,
-				   APPLE_RTKIT_BUFFER_REQUEST);
-		reply |= FIELD_PREP(APPLE_RTKIT_BUFFER_REQUEST_SIZE, n_4kpages);
-		reply |= FIELD_PREP(APPLE_RTKIT_BUFFER_REQUEST_IOVA,
-				    buffer->iova);
+		/* oslog uses different fields and needs a shifted IOVA instead of size */
+		if (ep == APPLE_RTKIT_EP_OSLOG) {
+			reply = FIELD_PREP(APPLE_RTKIT_OSLOG_TYPE,
+					   APPLE_RTKIT_OSLOG_BUFFER_REQUEST);
+			reply |= FIELD_PREP(APPLE_RTKIT_OSLOG_SIZE, buffer->size);
+			reply |= FIELD_PREP(APPLE_RTKIT_OSLOG_IOVA,
+					    buffer->iova >> 12);
+		} else {
+			reply = FIELD_PREP(APPLE_RTKIT_SYSLOG_TYPE,
+					   APPLE_RTKIT_BUFFER_REQUEST);
+			reply |= FIELD_PREP(APPLE_RTKIT_BUFFER_REQUEST_SIZE,
+					    buffer->size >> 12);
+			reply |= FIELD_PREP(APPLE_RTKIT_BUFFER_REQUEST_IOVA,
+					    buffer->iova);
+		}
 		apple_rtkit_send_message(rtk, ep, reply, NULL, false);
 	}
 
@@ -487,25 +504,18 @@ static void apple_rtkit_syslog_rx(struct apple_rtkit *rtk, u64 msg)
 	}
 }
 
-static void apple_rtkit_oslog_rx_init(struct apple_rtkit *rtk, u64 msg)
-{
-	u64 ack;
-
-	dev_dbg(rtk->dev, "RTKit: oslog init: msg: 0x%llx\n", msg);
-	ack = FIELD_PREP(APPLE_RTKIT_OSLOG_TYPE, APPLE_RTKIT_OSLOG_ACK);
-	apple_rtkit_send_message(rtk, APPLE_RTKIT_EP_OSLOG, ack, NULL, false);
-}
-
 static void apple_rtkit_oslog_rx(struct apple_rtkit *rtk, u64 msg)
 {
 	u8 type = FIELD_GET(APPLE_RTKIT_OSLOG_TYPE, msg);
 
 	switch (type) {
-	case APPLE_RTKIT_OSLOG_INIT:
-		apple_rtkit_oslog_rx_init(rtk, msg);
+	case APPLE_RTKIT_OSLOG_BUFFER_REQUEST:
+		apple_rtkit_common_rx_get_buffer(rtk, &rtk->oslog_buffer,
+						 APPLE_RTKIT_EP_OSLOG, msg);
 		break;
 	default:
-		dev_warn(rtk->dev, "RTKit: Unknown oslog message: %llx\n", msg);
+		dev_warn(rtk->dev, "RTKit: Unknown oslog message: %llx\n",
+			 msg);
 	}
 }
 
@@ -787,6 +797,7 @@ int apple_rtkit_reinit(struct apple_rtkit *rtk)
 
 	apple_rtkit_free_buffer(rtk, &rtk->ioreport_buffer);
 	apple_rtkit_free_buffer(rtk, &rtk->crashlog_buffer);
+	apple_rtkit_free_buffer(rtk, &rtk->oslog_buffer);
 	apple_rtkit_free_buffer(rtk, &rtk->syslog_buffer);
 
 	kfree(rtk->syslog_msg_buffer);
@@ -967,6 +978,7 @@ void apple_rtkit_free(struct apple_rtkit *rtk)
 
 	apple_rtkit_free_buffer(rtk, &rtk->ioreport_buffer);
 	apple_rtkit_free_buffer(rtk, &rtk->crashlog_buffer);
+	apple_rtkit_free_buffer(rtk, &rtk->oslog_buffer);
 	apple_rtkit_free_buffer(rtk, &rtk->syslog_buffer);
 
 	kfree(rtk->syslog_msg_buffer);
-- 
2.39.5



