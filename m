Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E42F24A07C;
	Tue, 20 May 2025 14:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750384; cv=none; b=scTCW0DVTVrSdqD7PN+gwTmLRXxdYdfm1VRXxFgqaNMtlsS5jew3EJbqzHUzfWan2vkfu+9udqlqLvSO4pAYZXLz6pG8F3zm3REmRnOxS69QMMfVGrZVodfD2bcQo73j8ppBxdyMHfYTHWRL7JLXuE/K2Pn13NIKNU3zXmGsCWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750384; c=relaxed/simple;
	bh=ApnTjO8cPHxcKB6RNqY4QmX4GuTsxs34KzvK6JIsWeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyHJzUlyD2EDAL7RT8S2DHTz03gGuvbZ4n3FLIQkR6nGnbRxDwvzwrDTIo+c+fzdaz8quuKexQ56gfGe61eb4v2fPEq8HTQZCeTQVZnag2MsOXbZxUBvyk94cr8Oj1vCVbp2NeUHabwQO9TpVjXSd9/08/B7h4ODz8HAxmlycDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhY/rDSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhY/rDSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F020AC4CEE9;
	Tue, 20 May 2025 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750384;
	bh=ApnTjO8cPHxcKB6RNqY4QmX4GuTsxs34KzvK6JIsWeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhY/rDSRtIdosuWTWUaB9BlOzT72hRgbsCJvKRKP54jL1w4Uvt55QeHcrZC38AzfD
	 Px/0CIb0y19aWaRVbClf0G3ahU8YDT0YvbdUXOiJDXu4Im4aKqr6YMXHEyiv3vA3eP
	 DHsR4Dr6fd9zSmuXTU9wOVwxbdxTsVIGOe9vcCJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.12 133/143] accel/ivpu: Reset fw log on cold boot
Date: Tue, 20 May 2025 15:51:28 +0200
Message-ID: <20250520125815.246202052@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>

commit 4b4d9e394b6f45ac26ac6144b31604c76b7e3705 upstream.

Add ivpu_fw_log_reset() that resets the read_index of all FW logs
on cold boot so logs are properly read.

Signed-off-by: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-4-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw_log.c |   14 ++++++++++++++
 drivers/accel/ivpu/ivpu_fw_log.h |    1 +
 drivers/accel/ivpu/ivpu_pm.c     |    1 +
 3 files changed, 16 insertions(+)

--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -140,3 +140,17 @@ void ivpu_fw_log_clear(struct ivpu_devic
 	while (fw_log_ptr(vdev, vdev->fw->mem_log_verb, &next, &log_header) == 0)
 		log_header->read_index = log_header->write_index;
 }
+
+void ivpu_fw_log_reset(struct ivpu_device *vdev)
+{
+	struct vpu_tracing_buffer_header *log_header;
+	u32 next;
+
+	next = 0;
+	while (fw_log_ptr(vdev, vdev->fw->mem_log_crit, &next, &log_header) == 0)
+		log_header->read_index = 0;
+
+	next = 0;
+	while (fw_log_ptr(vdev, vdev->fw->mem_log_verb, &next, &log_header) == 0)
+		log_header->read_index = 0;
+}
--- a/drivers/accel/ivpu/ivpu_fw_log.h
+++ b/drivers/accel/ivpu/ivpu_fw_log.h
@@ -25,6 +25,7 @@ extern unsigned int ivpu_fw_log_level;
 
 void ivpu_fw_log_print(struct ivpu_device *vdev, bool only_new_msgs, struct drm_printer *p);
 void ivpu_fw_log_clear(struct ivpu_device *vdev);
+void ivpu_fw_log_reset(struct ivpu_device *vdev);
 
 
 #endif /* __IVPU_FW_LOG_H__ */
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -38,6 +38,7 @@ static void ivpu_pm_prepare_cold_boot(st
 
 	ivpu_cmdq_reset_all_contexts(vdev);
 	ivpu_ipc_reset(vdev);
+	ivpu_fw_log_reset(vdev);
 	ivpu_fw_load(vdev);
 	fw->entry_point = fw->cold_boot_entry_point;
 }


