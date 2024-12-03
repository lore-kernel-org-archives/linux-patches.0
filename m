Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AD91F8904;
	Tue,  3 Dec 2024 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239728; cv=none; b=D+4foNQsaEKyHE1AeaCan08YWXAbAPlcxJJhVB6Ft0uppzrNnZPLCJELlrcPzDExpSTNTIxMYAhYpH66eX9fhtTA0a4B7j5wnzuGzDVOyzuO9CT2ckSqzwQSbM4OQJj/AIILNE3NWE0mbfCn8snLxFqNNKIDj6qb3AM7nzwQVfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239728; c=relaxed/simple;
	bh=iQkgJ4rhBkBvmuOuAW7cPL/Sz4NzFc+OyScisMdIZp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMZDqHx36cfXvn1KIyKODDUOTKD7H7cH4s72HEO69+U+VdKHc/iG4GYA/AUKTEP7mrlpK6qHqn6NXpluvDvIXvaUx2SDTX8/B4UvuOttz0l3GpLUUWVMOt6IFDbJ/q1EzUWs4csAdEpHE395gQqALMmOEMe3ijF76LFuemGfMro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cuyAQhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cuyAQhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDA9C4CED9;
	Tue,  3 Dec 2024 15:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239727;
	bh=iQkgJ4rhBkBvmuOuAW7cPL/Sz4NzFc+OyScisMdIZp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cuyAQhh7gaYo6eTB99cQ4lpdvwyqXVbTjYYIY+Mh1j5+siKx9FnkNsJZR7Q0WZe8
	 cqhkFeUGQiGvBdoS21Rr2a5h1Bdj7H3OQqka4OcmuHQrzvlRE6iFxtRFXjbhioeCSV
	 +2V51aWhGTeXoUpKQoFS4twIEzUEEWiTd/4s1i2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH 6.11 682/817] wifi: ath12k: fix warning when unbinding
Date: Tue,  3 Dec 2024 15:44:14 +0100
Message-ID: <20241203144022.587475691@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


