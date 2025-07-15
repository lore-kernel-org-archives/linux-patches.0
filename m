Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CD12E7643;
	Tue, 15 Jul 2025 13:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587511; cv=none; b=uLlJ+GZaCJ2drIpFVmI7LxQtGnYvwbC84ZVxdl7q3ddEzMjcYddsCO0cpkqI6tl6CLbI1faE8RlfFnrq/i3TgpMRz3P/642E2mnBTuYDbArnX7WorMx/AT+xmMGp5lCfzfhN8iDm/N4eoPK0YOKIh9OcPo4cHQ4AhaOHa/euxsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587511; c=relaxed/simple;
	bh=1quuOiItP4Wh7O0Pz81lnyn1F+peHOxIe1cJN6b8AHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHCIQHhZ5mXtUifYSjdUr+NfE7W7RqFPsix8qpqKk5pnd70Qt0cibF10n5wwy66a/LxbuUEG5pBqrz4AST4WYGZN1SThO1f/GOTdIxXUS4EEYg3+VD1Wqu/H7cKJCtdtk/IhIS+r+TKyzYxWuDediW2oSNcHRxPjAzpBAtDHU40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSKyYuJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSKyYuJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A496C4CEE3;
	Tue, 15 Jul 2025 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587511;
	bh=1quuOiItP4Wh7O0Pz81lnyn1F+peHOxIe1cJN6b8AHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSKyYuJUt4PRKsOgZjfq4v1Oe7Sc5Up2hiisb7GQliFJUpgASe3tRiawyF20FU2sK
	 4N9XOYBWqie4My8cskiuCBVQZlLYrqg/CPAquXyhtKCslWRKJZyCnGEv/mkRjGc7DU
	 s6XL+ecisyHP/Bg3SpZf/RZdsN1ok7vzTp6MtKLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Long Li <longli@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/208] Drivers: hv: vmbus: Add utility function for querying ring size
Date: Tue, 15 Jul 2025 15:12:29 +0200
Message-ID: <20250715130812.565350868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurabh Sengar <ssengar@linux.microsoft.com>

[ Upstream commit e8c4bd6c6e6b7e7b416c42806981c2a81370001e ]

Add a function to query for the preferred ring buffer size of VMBus
device. This will allow the drivers (eg. UIO) to allocate the most
optimized ring buffer size for devices.

Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Link: https://lore.kernel.org/r/1711788723-8593-2-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 15 ++++++++++++---
 drivers/hv/hyperv_vmbus.h |  5 +++++
 include/linux/hyperv.h    |  2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 4ee8b9b22bb9d..8300ffb1ea9ae 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -106,7 +106,9 @@ const struct vmbus_device vmbus_devs[] = {
 	},
 
 	/* File copy */
-	{ .dev_type = HV_FCOPY,
+	/* fcopy always uses 16KB ring buffer size and is working well for last many years */
+	{ .pref_ring_size = 0x4000,
+	  .dev_type = HV_FCOPY,
 	  HV_FCOPY_GUID,
 	  .perf_device = false,
 	},
@@ -123,11 +125,18 @@ const struct vmbus_device vmbus_devs[] = {
 	  .perf_device = false,
 	},
 
-	/* Unknown GUID */
-	{ .dev_type = HV_UNKNOWN,
+	/*
+	 * Unknown GUID
+	 * 64 KB ring buffer + 4 KB header should be sufficient size for any Hyper-V device apart
+	 * from HV_NIC and HV_SCSI. This case avoid the fallback for unknown devices to allocate
+	 * much bigger (2 MB) of ring size.
+	 */
+	{ .pref_ring_size = 0x11000,
+	  .dev_type = HV_UNKNOWN,
 	  .perf_device = false,
 	},
 };
+EXPORT_SYMBOL_GPL(vmbus_devs);
 
 static const struct {
 	guid_t guid;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 323c56152fa1b..1137c25d9a7ae 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -406,6 +406,11 @@ static inline bool hv_is_perf_channel(struct vmbus_channel *channel)
 	return vmbus_devs[channel->device_id].perf_device;
 }
 
+static inline size_t hv_dev_ring_size(struct vmbus_channel *channel)
+{
+	return vmbus_devs[channel->device_id].pref_ring_size;
+}
+
 static inline bool hv_is_allocated_cpu(unsigned int cpu)
 {
 	struct vmbus_channel *channel, *sc;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 5e019d26b5b72..987cc04f13182 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -802,6 +802,8 @@ struct vmbus_requestor {
 #define VMBUS_RQST_ID_NO_RESPONSE (U64_MAX - 2)
 
 struct vmbus_device {
+	/* preferred ring buffer size in KB, 0 means no preferred size for this device */
+	size_t pref_ring_size;
 	u16  dev_type;
 	guid_t guid;
 	bool perf_device;
-- 
2.39.5



