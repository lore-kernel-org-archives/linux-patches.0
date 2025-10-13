Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63D21E9B0D;
	Mon, 13 Oct 2025 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369870; cv=none; b=Lfep7YDqZLxSviz94p6uQhks6u86u+l9yWTWqFxJ2C1vtIz9KtJWdLys3rzEFKtjDr0tZpPPS25mCC6+V/QqaBONoqlDXcU6AwbV72CFAfDVwB2DkGtyjZdb/1Tp+C+dz3uutbVWbxceZ6ae5MVn6N7AgJztHbRZCVAbOgBs6/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369870; c=relaxed/simple;
	bh=T0JTP+QZqX46fIOXvu/hEjced+jgD5h8DeLkC4Z7PHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7wF+PmZQQL+GJ/4wrdsoJqUCDnY7sUepuq+OU3HeVdPLO7Lwm2EMhYowfX5VPulVuDIKI3N/M2PcbYoz0UjrGSWZg2OhKh2CWfM1B26xesfSX1/NhZpLBNxCddRIAL6O6oOdpofJvpwdjPqSZ+0VF7q3xxBj9jH7SJ4yD4k1jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypnQYn0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypnQYn0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537E8C4CEE7;
	Mon, 13 Oct 2025 15:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369870;
	bh=T0JTP+QZqX46fIOXvu/hEjced+jgD5h8DeLkC4Z7PHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypnQYn0IMsZ4bndZYMo0cW8vwXo0GQBH3QuKe9DgrOHaiwLaq0Ko6Pc9lyDoICMTx
	 iNpa/Oe1jM806ypx3/FoTSMs+9PobSUqKPjimcQbrH+1g9qC/cnQ6zsrT+7SNZpX4Q
	 8dbwoUGhz235T8s8DBcSX18zUK/6WiGA5Kt11Z3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 397/563] wifi: ath10k: avoid unnecessary wait for service ready message
Date: Mon, 13 Oct 2025 16:44:18 +0200
Message-ID: <20251013144425.665450366@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 51a73f1b2e56b0324b4a3bb8cebc4221b5be4c7a ]

Commit e57b7d62a1b2 ("wifi: ath10k: poll service ready message before
failing") works around the failure in waiting for the service ready
message by active polling. Note the polling is triggered after initial
wait timeout, which means that the wait-till-timeout can not be avoided
even the message is ready.

A possible fix is to do polling once before wait as well, however this
can not handle the race that the message arrives right after polling.
So the solution is to do periodic polling until timeout.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00309-QCARMSWPZ-1

Fixes: e57b7d62a1b2 ("wifi: ath10k: poll service ready message before failing")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/all/97a15967-5518-4731-a8ff-d43ff7f437b0@molgen.mpg.de
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250811-ath10k-avoid-unnecessary-wait-v1-1-db2deb87c39b@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 39 +++++++++++++--------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index cb8ae751eb312..e595b0979a56d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1764,33 +1764,32 @@ void ath10k_wmi_put_wmi_channel(struct ath10k *ar, struct wmi_channel *ch,
 
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
+	unsigned long timeout = jiffies + WMI_SERVICE_READY_TIMEOUT_HZ;
 	unsigned long time_left, i;
 
-	time_left = wait_for_completion_timeout(&ar->wmi.service_ready,
-						WMI_SERVICE_READY_TIMEOUT_HZ);
-	if (!time_left) {
-		/* Sometimes the PCI HIF doesn't receive interrupt
-		 * for the service ready message even if the buffer
-		 * was completed. PCIe sniffer shows that it's
-		 * because the corresponding CE ring doesn't fires
-		 * it. Workaround here by polling CE rings once.
-		 */
-		ath10k_warn(ar, "failed to receive service ready completion, polling..\n");
-
+	/* Sometimes the PCI HIF doesn't receive interrupt
+	 * for the service ready message even if the buffer
+	 * was completed. PCIe sniffer shows that it's
+	 * because the corresponding CE ring doesn't fires
+	 * it. Workaround here by polling CE rings. Since
+	 * the message could arrive at any time, continue
+	 * polling until timeout.
+	 */
+	do {
 		for (i = 0; i < CE_COUNT; i++)
 			ath10k_hif_send_complete_check(ar, i, 1);
 
+		/* The 100 ms granularity is a tradeoff considering scheduler
+		 * overhead and response latency
+		 */
 		time_left = wait_for_completion_timeout(&ar->wmi.service_ready,
-							WMI_SERVICE_READY_TIMEOUT_HZ);
-		if (!time_left) {
-			ath10k_warn(ar, "polling timed out\n");
-			return -ETIMEDOUT;
-		}
-
-		ath10k_warn(ar, "service ready completion received, continuing normally\n");
-	}
+							msecs_to_jiffies(100));
+		if (time_left)
+			return 0;
+	} while (time_before(jiffies, timeout));
 
-	return 0;
+	ath10k_warn(ar, "failed to receive service ready completion\n");
+	return -ETIMEDOUT;
 }
 
 int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar)
-- 
2.51.0



