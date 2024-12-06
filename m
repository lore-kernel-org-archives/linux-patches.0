Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD49962171;
	Fri,  6 Dec 2024 15:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498144; cv=none; b=HFhhuBcBv7r9TjYeG+E/QV26XIamVUM9FPfyIXwo4fmjETwY67fK7AahWxmShfFh6hA+i/g8Zgix6PDeyHfiOD8jjnk32pCL7mtMcqv4SWZ83YQWG0EGvrtnH51fwNholFsKpEwVDYg0bKx0jar8p06wSy4bT4von8KBK1KjtFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498144; c=relaxed/simple;
	bh=AOrA3k7vPkEAQYnPwvXp1S8xxJSThOVt+K8iebJ6JlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvNHcqAW/yFNEkvh2GCFacYHs4mfFpBrxCcgdGJpYojdE/Io5ATmy6J81G3hT/poVLgDwbFZgZMTk9pTwwxyZmFd6dpDoAU8zhY+iq+qC9TrODJ4q8MkYOOK6fOOyvZ+lRkWwYPLCV6upUR7tmGV8gp5Kzf74D5A7YZWbcNGFq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6pkndCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6pkndCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D293C4CEDC;
	Fri,  6 Dec 2024 15:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498143;
	bh=AOrA3k7vPkEAQYnPwvXp1S8xxJSThOVt+K8iebJ6JlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6pkndClxYehC7KPdOpr97qw7HRvZLdpVemTPfUhdaryRO/HkVR1dOcLiXEZbM0Qy
	 EbR9W2X8Io68/lmqsvOvqglQMefyiiX+wRakyITZ22PPuj/CmGQXmwpJMUwjLuqYx5
	 VzD6l1tdywEqPK8VPOiUf2IJffdrT/51eMofneYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH 6.6 498/676] wifi: ath12k: fix warning when unbinding
Date: Fri,  6 Dec 2024 15:35:17 +0100
Message-ID: <20241206143712.810247504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit ca68ce0d9f4bcd032fd1334441175ae399642a06 upstream.

If there is an error during some initialization related to firmware,
the buffers dp->tx_ring[i].tx_status are released.
However this is released again when the device is unbinded (ath12k_pci),
and we get:
WARNING: CPU: 0 PID: 2098 at mm/slub.c:4689 free_large_kmalloc+0x4d/0x80
Call Trace:
free_large_kmalloc
ath12k_dp_free
ath12k_core_deinit
ath12k_pci_remove
...

The issue is always reproducible from a VM because the MSI addressing
initialization is failing.

In order to fix the issue, just set the buffers to NULL after releasing in
order to avoid the double free.

cc: stable@vger.kernel.org
Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Link: https://patch.msgid.link/20241017181004.199589-3-jtornosm@redhat.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/dp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1249,8 +1249,10 @@ void ath12k_dp_free(struct ath12k_base *
 
 	ath12k_dp_rx_reo_cmd_list_cleanup(ab);
 
-	for (i = 0; i < ab->hw_params->max_tx_ring; i++)
+	for (i = 0; i < ab->hw_params->max_tx_ring; i++) {
 		kfree(dp->tx_ring[i].tx_status);
+		dp->tx_ring[i].tx_status = NULL;
+	}
 
 	ath12k_dp_rx_free(ab);
 	/* Deinit any SOC level resource */


