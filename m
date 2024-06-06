Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335A7199227;
	Thu,  6 Jun 2024 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683182; cv=none; b=rG/Im36B7KfJvG7B9FM2wRVILtX7tUW2LCrsxA4dFTfWhq0RGnFUjZSCbM430hvhd/DkJLyuGIxeBhAC16LNoF9qFMQPS/7k/ELbtERnqwy46j55BMbC7VN/ZhTTs5FTde4pUrWR4lt8cm0OW0UedOcf3E75f8r5vHq3EX8WwKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683182; c=relaxed/simple;
	bh=XHFp7PpfIFs41Lro0sYsSFWP4xTNETEo4+ZcZjFSjo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InCVS+y1s7qwy7ToUbJj21a+iXHFz1XmZDiPoQxP0ye/x12GcjNjnhfac3YfAL0cTbg651Mh93a5SDvZjWbEQZCmnK32NIUFPzZ1axVEi9MGLeTyy7XmPH8C6vlbiA2kKagtpZrK6Q/TBvrM9CWahV2xxNRBWWAFufLJd5dl3e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzEZX77+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzEZX77+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F41AC32781;
	Thu,  6 Jun 2024 14:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683182;
	bh=XHFp7PpfIFs41Lro0sYsSFWP4xTNETEo4+ZcZjFSjo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzEZX77+8TCN4/ONwZorELcHF4S3Xoii41ts8o5iXDij/Wa3X/9KUiYrfk4S6JfBN
	 y9U31cXvpfB9qxMlPYIYbnOf4r83+b2yOIdME1qrg8elw31h9y346HF/UXlmrWkWcP
	 4MJEmRvlT5ICLUy9GL3ct+9N5lwZ0dE2IcBzHSnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Prestwood <prestwoj@gmail.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/744] wifi: ath10k: poll service ready message before failing
Date: Thu,  6 Jun 2024 15:56:38 +0200
Message-ID: <20240606131736.461698808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit e57b7d62a1b2f496caf0beba81cec3c90fad80d5 ]

Currently host relies on CE interrupts to get notified that
the service ready message is ready. This results in timeout
issue if the interrupt is not fired, due to some unknown
reasons. See below logs:

[76321.937866] ath10k_pci 0000:02:00.0: wmi service ready event not received
...
[76322.016738] ath10k_pci 0000:02:00.0: Could not init core: -110

And finally it causes WLAN interface bring up failure.

Change to give it one more chance here by polling CE rings,
before failing directly.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00157-QCARMSWPZ-1

Fixes: 5e3dd157d7e7 ("ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices")
Reported-by: James Prestwood <prestwoj@gmail.com>
Tested-By: James Prestwood <prestwoj@gmail.com> # on QCA6174 hw3.2
Link: https://lore.kernel.org/linux-wireless/304ce305-fbe6-420e-ac2a-d61ae5e6ca1a@gmail.com/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240227030409.89702-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 05fa7d4c0e1ab..ee08a4c668f7a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1762,12 +1762,32 @@ void ath10k_wmi_put_wmi_channel(struct ath10k *ar, struct wmi_channel *ch,
 
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
-	unsigned long time_left;
+	unsigned long time_left, i;
 
 	time_left = wait_for_completion_timeout(&ar->wmi.service_ready,
 						WMI_SERVICE_READY_TIMEOUT_HZ);
-	if (!time_left)
-		return -ETIMEDOUT;
+	if (!time_left) {
+		/* Sometimes the PCI HIF doesn't receive interrupt
+		 * for the service ready message even if the buffer
+		 * was completed. PCIe sniffer shows that it's
+		 * because the corresponding CE ring doesn't fires
+		 * it. Workaround here by polling CE rings once.
+		 */
+		ath10k_warn(ar, "failed to receive service ready completion, polling..\n");
+
+		for (i = 0; i < CE_COUNT; i++)
+			ath10k_hif_send_complete_check(ar, i, 1);
+
+		time_left = wait_for_completion_timeout(&ar->wmi.service_ready,
+							WMI_SERVICE_READY_TIMEOUT_HZ);
+		if (!time_left) {
+			ath10k_warn(ar, "polling timed out\n");
+			return -ETIMEDOUT;
+		}
+
+		ath10k_warn(ar, "service ready completion received, continuing normally\n");
+	}
+
 	return 0;
 }
 
-- 
2.43.0



