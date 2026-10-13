Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A743515F1;
	Tue, 13 Oct 2026 12:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894657; cv=none; b=PnkcN/+8CVWW5lTql8mLqtfQPXbK986HhOt2wL+Ym6RYhDsmwKHWnSVCUkOl/Mns2Xmf68R70052we/9FxfjthVppUrRIaozXO7jCt5qN0yQB5+bompZbEcHkzYkgfGklcJ4Paf+KGLFGwV2V4keEgvhFDL7tU6UC8OiIC0nJTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894657; c=relaxed/simple;
	bh=Eds2hsNrdvrPY3ijR3b+SpdidBiyJXD7DvAo57OHjFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qp3pLwXAc1hi5gW2EjYNJgGG+rAQxU/28RH9aGiNo7gR33CKnjjbc8xzuh4VW7wijM7b5oTJ3bzPzIzWH7zURLuR6F7LeTABycG3XpbbRysWmbeghL7SHv76j2zyF1lKhwXTYh3glRe6J54Hyv/iHcqkE+jJRhpo6VkrDWIGxLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zXVOuwh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zXVOuwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53C91F000FF;
	Tue, 13 Oct 2026 12:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894656;
	bh=yNq6KJ9C6FghCAGRjnkBZVgcpgnGIC8oMDXAMW+Ejt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zXVOuwhvR19qRT23pf/iqW/SUhtIZMBjEGHVvCG+rr9bDlc2c5Xmqi21zCsdsuCE
	 FqRAoT6WsEa7UeVbAfteOtAFbAUFXD5jHtRS3bASsRkCbTm8GrGglLBrbuUFrzHg54
	 Gl/L7imyVEHmmJ0Fmi5ciLAqrkLXGqRz7FL/zRu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/497] ASoC: SOF: ipc4/Intel: Add support for library restore firmware functionality
Date: Tue, 13 Oct 2026 13:33:00 +0200
Message-ID: <20261013112908.194221666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit ace9b3daf2b4778358573d3698e34cb1c0fa7e14 ]

The firmware will be able to only save and restore the context related to
library management.
This means that even without a full context save, the libraries do not
need to be re-loaded to the firmware after second or consecutive boots.

This is reported via the FW_READY notification, where BIT(15) indicates:
0 - the library restore is not done
1 - library restore is done

This bit is only valid if full context save is not enabled, full context
save is by definition saves and restores the library related book-keeping
as well.

Add a new flag to tell the platform code if the libraries have been
restored, no need to reload them after boot.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20250619105623.4546-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sof/ipc4/header.h  |  2 ++
 sound/soc/sof/intel/hda-loader.c |  7 +++++--
 sound/soc/sof/ipc4-loader.c      |  6 ++++++
 sound/soc/sof/ipc4-priv.h        |  2 ++
 sound/soc/sof/ipc4.c             | 14 ++++++++++++--
 5 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/sound/sof/ipc4/header.h b/include/sound/sof/ipc4/header.h
index 0c0cf47946b1d..5302721c154d0 100644
--- a/include/sound/sof/ipc4/header.h
+++ b/include/sound/sof/ipc4/header.h
@@ -485,6 +485,8 @@ struct sof_ipc4_dx_state_info {
 #define SOF_IPC4_LOG_CORE_GET(x)		(((x) & SOF_IPC4_LOG_CORE_MASK) >> \
 						 SOF_IPC4_LOG_CORE_SHIFT)
 
+#define SOF_IPC4_FW_READY_LIB_RESTORED		BIT(15)
+
 /* Value of notification type field - must fit into 8 bits */
 enum sof_ipc4_notification_type {
 	/* Phrase detected (notification from WoV module) */
diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index 9d8ebb7c6a106..a1cd80eba6ebc 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -548,8 +548,11 @@ int hda_dsp_ipc4_load_library(struct snd_sof_dev *sdev,
 	struct snd_dma_buffer dmab;
 	int ret, ret1;
 
-	/* if IMR booting is enabled and fw context is saved for D3 state, skip the loading */
-	if (reload && hda->booted_from_imr && ipc4_data->fw_context_save)
+	/*
+	 * if IMR booting is enabled and libraries have been restored during fw
+	 * boot, skip the loading
+	 */
+	if (reload && hda->booted_from_imr && ipc4_data->libraries_restored)
 		return 0;
 
 	/* the fw_lib has been verified during loading, we can trust the validity here */
diff --git a/sound/soc/sof/ipc4-loader.c b/sound/soc/sof/ipc4-loader.c
index bcdb33d036820..bba5c1a8e27ed 100644
--- a/sound/soc/sof/ipc4-loader.c
+++ b/sound/soc/sof/ipc4-loader.c
@@ -401,6 +401,12 @@ int sof_ipc4_query_fw_configuration(struct snd_sof_dev *sdev)
 			break;
 		case SOF_IPC4_FW_CONTEXT_SAVE:
 			ipc4_data->fw_context_save = *tuple->value;
+			/*
+			 * Set the default libraries_restored value - if full
+			 * context save is supported then it means that
+			 * libraries are restored
+			 */
+			ipc4_data->libraries_restored = ipc4_data->fw_context_save;
 			break;
 		default:
 			break;
diff --git a/sound/soc/sof/ipc4-priv.h b/sound/soc/sof/ipc4-priv.h
index 0889de04b0170..bd3cb79084154 100644
--- a/sound/soc/sof/ipc4-priv.h
+++ b/sound/soc/sof/ipc4-priv.h
@@ -72,6 +72,7 @@ struct sof_ipc4_fw_library {
  * @max_libs_count: Maximum number of libraries support by the FW including the
  *		    base firmware
  * @fw_context_save: Firmware supports full context save and restore
+ * @libraries_restored: The libraries have been retained during firmware boot
  *
  * @load_library: Callback function for platform dependent library loading
  * @pipeline_state_mutex: Mutex to protect pipeline triggers, ref counts, states and deletion
@@ -87,6 +88,7 @@ struct sof_ipc4_fw_data {
 	int max_num_pipelines;
 	u32 max_libs_count;
 	bool fw_context_save;
+	bool libraries_restored;
 
 	int (*load_library)(struct snd_sof_dev *sdev,
 			    struct sof_ipc4_fw_library *fw_lib, bool reload);
diff --git a/sound/soc/sof/ipc4.c b/sound/soc/sof/ipc4.c
index e4eb8e004885e..9427d80ceafaa 100644
--- a/sound/soc/sof/ipc4.c
+++ b/sound/soc/sof/ipc4.c
@@ -616,9 +616,19 @@ EXPORT_SYMBOL(sof_ipc4_find_debug_slot_offset_by_type);
 
 static int ipc4_fw_ready(struct snd_sof_dev *sdev, struct sof_ipc4_msg *ipc4_msg)
 {
-	/* no need to re-check version/ABI for subsequent boots */
-	if (!sdev->first_boot)
+	if (!sdev->first_boot) {
+		struct sof_ipc4_fw_data *ipc4_data = sdev->private;
+
+		/*
+		 * After the initial boot only check if the libraries have been
+		 * restored when full context save is not enabled
+		 */
+		if (!ipc4_data->fw_context_save)
+			ipc4_data->libraries_restored = !!(ipc4_msg->primary &
+							   SOF_IPC4_FW_READY_LIB_RESTORED);
+
 		return 0;
+	}
 
 	sof_ipc4_create_exception_debugfs_node(sdev);
 
-- 
2.53.0



