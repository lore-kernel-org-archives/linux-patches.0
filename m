Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7532EA14A;
	Tue, 17 Jun 2025 16:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176644; cv=none; b=Zryo7ZjxCQa4JWEZjz2eSmfiNckZLGIt7Ee6MShe5mKYkaAtcD7GTsOtG+nlsrfxeKdOqF9FIZwgzZ4XvSaCPMTdOh8xGAKCq43X/eXugBGbiwYdVhSNCUTK5LWduW157XIE9YQzdJt3eR3PXpXYfDXffrlgMn2eGnoH6I7eT8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176644; c=relaxed/simple;
	bh=yjATzQho/edp3ESZXr3I51c98EwEYVR7IGnO65i8ARo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyXGNtobkV1nZidOvhjtkpqYitim0wKBHFSmJUQcIOINAc6b8yf9NPwmRAk4XJnhi7cRI0qn4hI6JQr0lLwRWRESooGmJvQ9kXdwbOAMvFF3tRrrP1DBPMPA24bqEgJ1f5TGh5hvyL39zjJxDXnSUvAURkeA+kKlB8IrQZAACKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jn9U6E3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jn9U6E3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBD2C4CEE3;
	Tue, 17 Jun 2025 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176644;
	bh=yjATzQho/edp3ESZXr3I51c98EwEYVR7IGnO65i8ARo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jn9U6E3QqKrwTqvtT5i2JczmaLoE1f+LdcWOLcI0r6g0V+6wLpi9SMpp2CwSzp39D
	 wOWqWKQCN5siaSjddZ0w1vxEAhWj9n8hUd/0ZTsiQ4obzCTaDy8+oAm8WniJzvI71O
	 AmyJpagL9L3x7OZQ2hPGYh/l2HZQDWRsv1KJy8UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 300/356] wifi: ath11k: dont use static variables in ath11k_debugfs_fw_stats_process()
Date: Tue, 17 Jun 2025 17:26:55 +0200
Message-ID: <20250617152350.247405241@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 2bcf73b2612dda7432f2c2eaad6679bd291791f2 ]

Currently ath11k_debugfs_fw_stats_process() is using static variables to count
firmware stat events. Taking num_vdev as an example, if for whatever reason (
say ar->num_started_vdevs is 0 or firmware bug etc.) the following condition

	(++num_vdev) == total_vdevs_started

is not met, is_end is not set thus num_vdev won't be cleared. Next time when
firmware stats is requested again, even if everything is working fine, we will
fail due to the condition above will never be satisfied.

The same applies to num_bcn as well.

Change to use non-static counters so that we have a chance to clear them each
time firmware stats is requested. Currently only ath11k_fw_stats_request() and
ath11k_debugfs_fw_stats_request() are requesting firmware stats, so clear
counters there.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.37

Fixes: da3a9d3c1576 ("ath11k: refactor debugfs code into debugfs.c")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250220082448.31039-3-quic_bqiang@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.h    |  2 ++
 drivers/net/wireless/ath/ath11k/debugfs.c | 16 +++++++---------
 drivers/net/wireless/ath/ath11k/mac.c     |  2 ++
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 41ccf59a4fd93..555deafd8399a 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -550,6 +550,8 @@ struct ath11k_fw_stats {
 	struct list_head pdevs;
 	struct list_head vdevs;
 	struct list_head bcn;
+	u32 num_vdev_recvd;
+	u32 num_bcn_recvd;
 };
 
 struct ath11k_dbg_htt_stats {
diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index a5791155fe065..5a375d6680594 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -98,6 +98,8 @@ static void ath11k_debugfs_fw_stats_reset(struct ath11k *ar)
 	spin_lock_bh(&ar->data_lock);
 	ath11k_fw_stats_pdevs_free(&ar->fw_stats.pdevs);
 	ath11k_fw_stats_vdevs_free(&ar->fw_stats.vdevs);
+	ar->fw_stats.num_vdev_recvd = 0;
+	ar->fw_stats.num_bcn_recvd = 0;
 	spin_unlock_bh(&ar->data_lock);
 }
 
@@ -106,7 +108,6 @@ void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *
 	struct ath11k_base *ab = ar->ab;
 	struct ath11k_pdev *pdev;
 	bool is_end;
-	static unsigned int num_vdev, num_bcn;
 	size_t total_vdevs_started = 0;
 	int i;
 
@@ -131,15 +132,14 @@ void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *
 				total_vdevs_started += ar->num_started_vdevs;
 		}
 
-		is_end = ((++num_vdev) == total_vdevs_started);
+		is_end = ((++ar->fw_stats.num_vdev_recvd) == total_vdevs_started);
 
 		list_splice_tail_init(&stats->vdevs,
 				      &ar->fw_stats.vdevs);
 
-		if (is_end) {
+		if (is_end)
 			complete(&ar->fw_stats_done);
-			num_vdev = 0;
-		}
+
 		return;
 	}
 
@@ -151,15 +151,13 @@ void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *
 		/* Mark end until we reached the count of all started VDEVs
 		 * within the PDEV
 		 */
-		is_end = ((++num_bcn) == ar->num_started_vdevs);
+		is_end = ((++ar->fw_stats.num_bcn_recvd) == ar->num_started_vdevs);
 
 		list_splice_tail_init(&stats->bcn,
 				      &ar->fw_stats.bcn);
 
-		if (is_end) {
+		if (is_end)
 			complete(&ar->fw_stats_done);
-			num_bcn = 0;
-		}
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index c3bfbc40273d0..9df3f6449f768 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -9011,6 +9011,8 @@ static int ath11k_fw_stats_request(struct ath11k *ar,
 
 	spin_lock_bh(&ar->data_lock);
 	ath11k_fw_stats_pdevs_free(&ar->fw_stats.pdevs);
+	ar->fw_stats.num_vdev_recvd = 0;
+	ar->fw_stats.num_bcn_recvd = 0;
 	spin_unlock_bh(&ar->data_lock);
 
 	reinit_completion(&ar->fw_stats_complete);
-- 
2.39.5



