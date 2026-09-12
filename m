Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7668416CFA;
	Sat, 12 Sep 2026 09:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204509; cv=none; b=kC6WAWR5yML2lfx/tx8oPAcrxdxMovM+PlvM/MbkZI/yE+K/vmn7gwKKpB9GijVG5GYKdTnSO7NMGHyLRdP37SB8LHuPpU11S5SUoNoHjxeqKWYwI2UJugc/IXcWiYkqhSsiQ6SzoOcf/HLMKZwuTqYesitxDYXjUayR59QpFsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204509; c=relaxed/simple;
	bh=FpXhLxuyeL2c8mm4bbcjryBh2h3elTLV2nLAx55DLgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLovm0E29joDT+gXRGb0Ja1xagBe/Axqvd7JUHQyGoLGKcX3eIZHqizjCz//P1krWbwiSp9f9KD92osX9guFy38Ose+7X86HsWUSX1b4dEgPKBE0O8PTfeHm9OM9KSob15V1+lBhoWtaxwYoC3anyRyFXObfH9fMvXVpAJl6EW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okS2Raua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okS2Raua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BF31F000FF;
	Sat, 12 Sep 2026 09:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204507;
	bh=6ME9njGKwpU+LEoToWg2+F1JLAhI6JxvT0jWavvcRD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okS2RauamxpTR0dZ35AygwCRH6MjrVXTjipCUMMQSstn5m57u/GFc3vwkPuBCnEl/
	 o6KDUK5ROuSYO7EzkrS/LjHTTaros5j6j/EX07SRuFl/tCaXAPnYgS6wTMZ12YiK0S
	 qbUjng0seb+SP4OmuJ7gQHYU6S11tLKV2HCXsXWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	Peter Hilber <peter.hilber@oss.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1627/1815] virtio: rtc: time out alarm requests
Date: Sat, 12 Sep 2026 08:56:17 +0200
Message-ID: <20260912065727.184009454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

[ Upstream commit 68e00d9212929805b40dcb9166755610f4f4acee ]

RTC class operations run with rtc_device.ops_lock held. The virtio RTC
alarm requests currently wait without a timeout for the device to return
their requestq buffers.

On surprise removal, virtio-pci marks the virtqueues broken before
unregistering the virtio device. If an alarm request is waiting when the
device stops responding, viortc_remove() blocks in viortc_class_stop()
while trying to acquire ops_lock. The request cannot complete and device
removal hangs until the waiting task is signalled.

Use the same 60-second timeout as clock read requests for alarm reads,
alarm programming, and alarm interrupt enable requests. The existing
message reference counting keeps a timed-out request alive until a late
response or device teardown.

Fixes: 9d4f22fd563e ("virtio_rtc: Add RTC class driver")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Reviewed-by: Peter Hilber <peter.hilber@oss.qualcomm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260714024352.71307-1-zhaoguohan@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_rtc_driver.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/virtio/virtio_rtc_driver.c b/drivers/virtio/virtio_rtc_driver.c
index 4419735b0f0dc..74616ba5be119 100644
--- a/drivers/virtio/virtio_rtc_driver.c
+++ b/drivers/virtio/virtio_rtc_driver.c
@@ -574,8 +574,8 @@ static int viortc_msg_xfer(struct viortc_vq *vq, struct viortc_msg *msg,
  * read requests
  */
 
-/** timeout for clock readings, where timeouts are considered non-fatal */
-#define VIORTC_MSG_READ_TIMEOUT secs_to_jiffies(60)
+/** timeout for runtime requests, where timeouts are considered non-fatal */
+#define VIORTC_MSG_TIMEOUT secs_to_jiffies(60)
 
 /**
  * viortc_read() - VIRTIO_RTC_REQ_READ wrapper
@@ -600,7 +600,7 @@ int viortc_read(struct viortc_dev *viortc, u16 vio_clk_id, u64 *reading)
 	VIORTC_MSG_WRITE(hdl, clock_id, &vio_clk_id);
 
 	ret = viortc_msg_xfer(&viortc->vqs[VIORTC_REQUESTQ], VIORTC_MSG(hdl),
-			      VIORTC_MSG_READ_TIMEOUT);
+			      VIORTC_MSG_TIMEOUT);
 	if (ret) {
 		dev_dbg(&viortc->vdev->dev, "%s: xfer returned %d\n", __func__,
 			ret);
@@ -642,7 +642,7 @@ int viortc_read_cross(struct viortc_dev *viortc, u16 vio_clk_id, u8 hw_counter,
 	VIORTC_MSG_WRITE(hdl, hw_counter, &hw_counter);
 
 	ret = viortc_msg_xfer(&viortc->vqs[VIORTC_REQUESTQ], VIORTC_MSG(hdl),
-			      VIORTC_MSG_READ_TIMEOUT);
+			      VIORTC_MSG_TIMEOUT);
 	if (ret) {
 		dev_dbg(&viortc->vdev->dev, "%s: xfer returned %d\n", __func__,
 			ret);
@@ -809,7 +809,7 @@ int viortc_read_alarm(struct viortc_dev *viortc, u16 vio_clk_id,
 	VIORTC_MSG_WRITE(hdl, clock_id, &vio_clk_id);
 
 	ret = viortc_msg_xfer(&viortc->vqs[VIORTC_REQUESTQ], VIORTC_MSG(hdl),
-			      0);
+			      VIORTC_MSG_TIMEOUT);
 	if (ret) {
 		dev_dbg(&viortc->vdev->dev, "%s: xfer returned %d\n", __func__,
 			ret);
@@ -858,7 +858,7 @@ int viortc_set_alarm(struct viortc_dev *viortc, u16 vio_clk_id, u64 alarm_time,
 	VIORTC_MSG_WRITE(hdl, flags, &flags);
 
 	ret = viortc_msg_xfer(&viortc->vqs[VIORTC_REQUESTQ], VIORTC_MSG(hdl),
-			      0);
+			      VIORTC_MSG_TIMEOUT);
 	if (ret) {
 		dev_dbg(&viortc->vdev->dev, "%s: xfer returned %d\n", __func__,
 			ret);
@@ -900,7 +900,7 @@ int viortc_set_alarm_enabled(struct viortc_dev *viortc, u16 vio_clk_id,
 	VIORTC_MSG_WRITE(hdl, flags, &flags);
 
 	ret = viortc_msg_xfer(&viortc->vqs[VIORTC_REQUESTQ], VIORTC_MSG(hdl),
-			      0);
+			      VIORTC_MSG_TIMEOUT);
 	if (ret) {
 		dev_dbg(&viortc->vdev->dev, "%s: xfer returned %d\n", __func__,
 			ret);
-- 
2.53.0



