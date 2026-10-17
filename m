Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDB23B9D96;
	Sat, 17 Oct 2026 17:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257212; cv=none; b=UqKW9p098OhE2c0GpRNHiA7y4XSFQNEPf1nJd0ErxHtaAPgdQNmuT7T00n72hKnVj6s57dFcgBgTJ6B39gd0FX25S+P1RIjtIT68iexDHoPCz7RqHW2/WRCr3gTSyF7hdvn8UdJJw8LWsCUggYPAJuHpPYCNXVHDuSAnoL1tNuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257212; c=relaxed/simple;
	bh=sgJ/vGuZN0ZUsqSXpGVmagdTAwklKYW9tyNbGiEdnXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkHCB2eZCW7qbyO0uB3L4h04wGyFjEdv0j63iEjmwyROBuS+4CV616VEMFF89Tu2GhAGNxIDYSOAAiR8H9Zj1/Rl0Ey8ShbQDx7z8nqVKCTEOtdI8tTJlsie55ZlfBFaKlpEQy+zCzEiqyHXh/v+lAazvb23tZLCXmtzvjMG+nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUtKEc8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUtKEc8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF5A1F000C4;
	Sat, 17 Oct 2026 17:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257211;
	bh=Gcnvz9kAUAjMJ34VfJ1zCf0tcZqGhZr5L5JyEBq9XBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUtKEc8joqDzDVWy5lyO/S9MWsrNTvlolS8BKZDIenJqHMqRallMG94PgyVje0tEo
	 c/Cmkiph5Is5LrFtbRA/vwEr8RID6BP5VNzMh1LHmNYIFj4Kw8WSoC/lM0a2BY0w86
	 nY4esIRx5CV0Ge5nCGSOVtTWc7pO/1Jk7nlgUJCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0488/1674] ibmveth: h_free logical LAN on open-fail after register
Date: Sat, 17 Oct 2026 17:46:00 +0200
Message-ID: <20261017160443.640477886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingming Cao <mmc@linux.ibm.com>

commit af0524bf4ce1a4cbd2946aa81751582951cfcab5 upstream.

ibmveth_open() registers the logical LAN, then allocates the RX
buffer pools. A pool failure jumps to out_free_buffer_pools without
h_free_logical_lan(), so PHYP still owns the buffer-list page when
it is unmapped. request_irq() failure already issued the hypercall
before taking the same label.

Move that h_free to the shared post-register unwind so both paths
deregister before the buffer list is unmapped.

Fixes: d43732ce021f ("ibmveth: properly unwind on init errors")
Cc: stable@vger.kernel.org
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
Link: https://patch.msgid.link/7a56fbfb9e0674f011f4e310fbd7dfd8e67c30aa.1790357373.git.mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -630,10 +630,6 @@ static int ibmveth_open(struct net_devic
 	if (rc != 0) {
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
-		do {
-			lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
-		} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
-
 		goto out_free_buffer_pools;
 	}
 
@@ -649,6 +645,9 @@ static int ibmveth_open(struct net_devic
 	return 0;
 
 out_free_buffer_pools:
+	do {
+		lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
+	} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
 	while (--i >= 0) {
 		if (adapter->rx_buff_pool[i].active)
 			ibmveth_free_buffer_pool(adapter,


