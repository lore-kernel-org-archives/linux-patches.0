Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE650322DCB;
	Mon, 27 Oct 2025 18:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591102; cv=none; b=DDHJdVTrK6bol6sgsTqxErd56HHTAuay7j8P8uBtAjiLNI3Z3SbhxPTb5kzt6CsNVexF12L7Y9yVhjfoHy4t+cqYhC9l7+PiDKvItfx+YsiG/2HMx3g78Ve3TiGfjgJR1TGDvGY1aSMVystwyQLxJqi8uckb03+wIV7nud5cLpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591102; c=relaxed/simple;
	bh=5wBbmID2lIdmJQlPh73BS6zhvk0k7r0rDbDG/KK2ucU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVUkp6JMO4uQ9wgNjZVZZjIV5D0zzeboiuw15+P5GvOtzHApVTAzeZ14Leyf/Ph+QKUr+87P1zYRPbdmz6zqEA7GPTzCjt+mQ0Yo3pgOVoj2J7reZn9PTqexKEUWFBRULMkjNbKAFwXjka9POD4BjmgBMeVHJLKXT45umjQE1U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBB0CV4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBB0CV4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D86C4CEF1;
	Mon, 27 Oct 2025 18:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591101;
	bh=5wBbmID2lIdmJQlPh73BS6zhvk0k7r0rDbDG/KK2ucU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBB0CV4NE5q714NOlIQSTaq5ujxhBCicZ6v9DzwAw5oEt8zzuuY9I3MBiBIbh7Yeg
	 eknTJ3OwLGekotNJFSi4Yhe0PZOgnzXgoZJmmaNZWuFJCeSiYqooR/XxadAds8Z3H1
	 rbqieBShXUSKfELB3Whe/I4zSCKkuE3OTGy7fLm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/332] wifi: ath10k: avoid unnecessary wait for service ready message
Date: Mon, 27 Oct 2025 19:32:00 +0100
Message-ID: <20251027183526.385879492@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c9a74f3e2e601..858db97ecfed9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1762,33 +1762,32 @@ void ath10k_wmi_put_wmi_channel(struct ath10k *ar, struct wmi_channel *ch,
 
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



