Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2002B9B9;
	Tue,  3 Dec 2024 16:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242499; cv=none; b=fUgwj9tUTC8QH4t50yQeQC7gLOrRJORNYp/1NRzfc6ZQpuCKQMtJJdmOdkVjAulvu+S5Qz4MJLhVDJkAla+qUHhAsu7Fm194T7VV7MMGU4SHvKXdGl4CvzdQUMANFUuC3lgQ461pgMgid3Uy/I0rtiHEgjpMbpXv5Bc7JPzr390=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242499; c=relaxed/simple;
	bh=ppisftDxufdOsj0wpVFG6ALzpNtu3RshZJ91wdSF1Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mp+W8knJ5GJRnGErH/KbdYI80dMszxKHVe+/qlHZabwb7SliTMVduaTvSxxMhsMb3X/zR6xvotxKs2vC+jop9J195xOlLTzi7pi3HyFnDF/kzvglFbATtNjK/SgWEEyAQ7rd8tdFTGTO6QPSAgtIAGWV1saVVWO/sqVGECv2hNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6AsSrAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6AsSrAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D914C4CECF;
	Tue,  3 Dec 2024 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242499;
	bh=ppisftDxufdOsj0wpVFG6ALzpNtu3RshZJ91wdSF1Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6AsSrAeTVTQmI4+Zo4mPNYnvSfKaIl2Mlx1MU/FAmlOabD2WYmMPCma33JVAQKqF
	 lrzk9gBbPjqJkoX7UAdst2rTkIJWAt+RgkN8aCgT+vMpEJ5EH3UlP0AWs46cU18Puu
	 qRM8qi87SSlepa0/RhrlbMnDcTTiNHBrpdRtH7VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH 6.12 681/826] wifi: ath12k: fix warning when unbinding
Date: Tue,  3 Dec 2024 15:46:48 +0100
Message-ID: <20241203144810.322583686@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1282,8 +1282,10 @@ void ath12k_dp_free(struct ath12k_base *
 
 	ath12k_dp_rx_reo_cmd_list_cleanup(ab);
 
-	for (i = 0; i < ab->hw_params->max_tx_ring; i++)
+	for (i = 0; i < ab->hw_params->max_tx_ring; i++) {
 		kfree(dp->tx_ring[i].tx_status);
+		dp->tx_ring[i].tx_status = NULL;
+	}
 
 	ath12k_dp_rx_free(ab);
 	/* Deinit any SOC level resource */


