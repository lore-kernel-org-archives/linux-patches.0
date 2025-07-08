Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDB62E091E;
	Tue,  8 Jul 2025 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993866; cv=none; b=Sw/79GaZEno8jySGQC8oCCjqDhUPh2stXyG1Iq8x7vMmc/2ZqYSbjQnyLydGv/KvXBRUzHk/u2Y3iBNeWiXSe+cnqdmCEJY8kSRwMPCkGEvgjcyqn13Qn/Oull6nJKAH2h2R9upDJTOdc5jVJcac6rqeTjzHS2vdHallXnOu+fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993866; c=relaxed/simple;
	bh=JzGPqdVDv8czk7eBdcsHPaG+NuUfV3HOnQ426gkN2Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz5WcImxLAl+dF5xRmHlsODeRoS4/jodt10ICQ9kfmMbiAUxhDjcWC8sjkK7ViQu3ptQWOLNxngPv33z5shTmQaKdLZHoa7xS3dIHR4Vop6yNY7aT6zcwLDJiQx1KBG9QNsZ/RqjOtE0S2Z7Sy+NSWCmVefchkQOpIUb//CSseo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpcTe6t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpcTe6t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A816C4CEED;
	Tue,  8 Jul 2025 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993866;
	bh=JzGPqdVDv8czk7eBdcsHPaG+NuUfV3HOnQ426gkN2Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpcTe6t5UiF/JH84OgiTaOXpEFqMt4Ek60aLdZfxP36H2MYRp3d+pp2leDP+UMtU5
	 9dX4i7cQG6SbpfqvvZJEOYN90/btM9e+X071mfX1men71s6Xl8CIEUi8rtar/pRetX
	 Th0tn95LdW0HTwXLqs3txJyjsCK/E1YYEJlNw7Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Long Li <longli@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/160] Drivers: hv: vmbus: Add utility function for querying ring size
Date: Tue,  8 Jul 2025 18:21:23 +0200
Message-ID: <20250708162232.815945346@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 029f8269ad15d..cd9f01b7d37dd 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -119,7 +119,9 @@ const struct vmbus_device vmbus_devs[] = {
 	},
 
 	/* File copy */
-	{ .dev_type = HV_FCOPY,
+	/* fcopy always uses 16KB ring buffer size and is working well for last many years */
+	{ .pref_ring_size = 0x4000,
+	  .dev_type = HV_FCOPY,
 	  HV_FCOPY_GUID,
 	  .perf_device = false,
 	  .allowed_in_isolated = false,
@@ -139,12 +141,19 @@ const struct vmbus_device vmbus_devs[] = {
 	  .allowed_in_isolated = false,
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
 	  .allowed_in_isolated = false,
 	},
 };
+EXPORT_SYMBOL_GPL(vmbus_devs);
 
 static const struct {
 	guid_t guid;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 6a0ae815a198e..b87adb3a98211 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -405,6 +405,11 @@ static inline bool hv_is_perf_channel(struct vmbus_channel *channel)
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
index aff435a42ead9..62d5bb1f726f6 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -815,6 +815,8 @@ struct vmbus_requestor {
 #define VMBUS_RQST_RESET (U64_MAX - 3)
 
 struct vmbus_device {
+	/* preferred ring buffer size in KB, 0 means no preferred size for this device */
+	size_t pref_ring_size;
 	u16  dev_type;
 	guid_t guid;
 	bool perf_device;
-- 
2.39.5



