Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85611E1E11;
	Wed, 19 Mar 2025 14:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395049; cv=none; b=mgEA02qZyYQS1vjKNOIR+KZisJRMsxqmLUCMc5LVQfnr6GU3hVQ1qIPBX2IPRv8QguXq0NUZbIVtSl12Zatq7D1ETD7Fk59QtD27X11GzC9jsCV7GmNqLEJmdS36v7C0/m0SqGIbynYfxshP2+oVuFU/vXJFCZ3NE/PvFw63pi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395049; c=relaxed/simple;
	bh=Qv10CMkIVpy+z3zYLtFbO98JxwgOEgWT/Vah5eSQL9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOkSOmewRYD6Q/XybZFvn3ef5WfDHa4v6U4sP8JI4CXspSbY2nNj1YhS4MgYe6OhfADl0cHRo+igG9y+nSAh0P980iV+39mcAMODYwR7B1eeBOd9qRXyHgvLha6PW3TaYr79d72CtYaX4wdD3kftt+E/B4vTm4xV86VFp176CpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAop0Oly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAop0Oly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C766C4CEE4;
	Wed, 19 Mar 2025 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395049;
	bh=Qv10CMkIVpy+z3zYLtFbO98JxwgOEgWT/Vah5eSQL9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAop0OlyoUbUF0LqCXZBqUPjC1gvBCaZHCZDxHis2NtP4AP4Ymwqgh6huWN+sw8Bl
	 Nzd8BAQGUMwfiPQwlP6VFoEqaVR/RLAiGO/KaqIUk2iEN3LIAnarkns6pzenu/hZ2b
	 uclDDoEEqRxTpIz5/Rk3Nn5VI/8/w2sPalGk0zWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/231] HID: intel-ish-hid: Send clock sync message immediately after reset
Date: Wed, 19 Mar 2025 07:29:29 -0700
Message-ID: <20250319143028.712209283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 7e0d1cff12b895f44f4ddc8cf50311bc1f775201 ]

The ISH driver performs a clock sync with the firmware once at system
startup and then every 20 seconds. If a firmware reset occurs right
after a clock sync, the driver would wait 20 seconds before performing
another clock sync with the firmware. This is particularly problematic
with the introduction of the "load firmware from host" feature, where
the driver performs a clock sync with the bootloader and then has to
wait 20 seconds before syncing with the main firmware.

This patch clears prev_sync immediately upon receiving an IPC reset,
so that the main firmware and driver will perform a clock sync
immediately after completing the IPC handshake.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/ipc.c         | 9 ++++++---
 drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h | 2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ipc/ipc.c b/drivers/hid/intel-ish-hid/ipc/ipc.c
index cb956a8c386cb..4c861119e97aa 100644
--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -517,6 +517,10 @@ static int ish_fw_reset_handler(struct ishtp_device *dev)
 	/* ISH FW is dead */
 	if (!ish_is_input_ready(dev))
 		return	-EPIPE;
+
+	/* Send clock sync at once after reset */
+	ishtp_dev->prev_sync = 0;
+
 	/*
 	 * Set HOST2ISH.ILUP. Apparently we need this BEFORE sending
 	 * RESET_NOTIFY_ACK - FW will be checking for it
@@ -577,13 +581,12 @@ static void fw_reset_work_fn(struct work_struct *work)
  */
 static void _ish_sync_fw_clock(struct ishtp_device *dev)
 {
-	static unsigned long	prev_sync;
 	struct ipc_time_update_msg time = {};
 
-	if (prev_sync && time_before(jiffies, prev_sync + 20 * HZ))
+	if (dev->prev_sync && time_before(jiffies, dev->prev_sync + 20 * HZ))
 		return;
 
-	prev_sync = jiffies;
+	dev->prev_sync = jiffies;
 	/* The fields of time would be updated while sending message */
 	ipc_send_mng_msg(dev, MNG_SYNC_FW_CLOCK, &time, sizeof(time));
 }
diff --git a/drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h b/drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h
index cdacce0a4c9d7..b35afefd036d4 100644
--- a/drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h
+++ b/drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h
@@ -242,6 +242,8 @@ struct ishtp_device {
 	unsigned int	ipc_tx_cnt;
 	unsigned long long	ipc_tx_bytes_cnt;
 
+	/* Time of the last clock sync */
+	unsigned long prev_sync;
 	const struct ishtp_hw_ops *ops;
 	size_t	mtu;
 	uint32_t	ishtp_msg_hdr;
-- 
2.39.5



