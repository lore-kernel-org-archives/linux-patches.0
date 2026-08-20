Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9699E37CD5A;
	Thu, 20 Aug 2026 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243204; cv=none; b=Udw8lwLu17VFjPdNEk/AEpX/7dayJfL4MiJaVubDHntndzhH1GNMO0H1GkSlhDCZzZRqFAXBYPuD5DLgRWA1M84SH50Tdxhgt7e+vgESPwIAOq2qTWtVmywLfnj4+lXFAPgsnp+M6pfkqfmhw/inm8yFn5GNocjNGJxZafr6J6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243204; c=relaxed/simple;
	bh=1DTjbSwRFgg3LlazUpqMUYM4CKxq8x/g1GitkNIQ0B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p06UusEfAh/JlsXmGUgGDOgTqaubOiqiZw262H2Jo58IAjKOvFWAxLwi6JXIvQrQ8RXFTsMDFshHfj3abYAu3Aqx9sDeUxRdW6GA2ky0aeqyK8zUClk4h6dGIvZEbklKDFgkmzO3WtRpWlPA6lmJm4g1HC8JJJN7GbOmmnm+/3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCk2xqOo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCk2xqOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3AC1F000E9;
	Thu, 20 Aug 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243203;
	bh=6bh9Uhg1A7e6Xdw46Rpokk8I78vcLKMnmM8zwEkcmjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCk2xqOo5DxNkGEzsdgmnCDgipoQVUS0aoslFG+8HDC2C2Ij2Z5p+vZu2DmJ56gzT
	 3Iq2JdFBgmsdCWchMqPy5aICXQ75V5sAp2aRcwnpiI3kH1a19SReTnxGIctyerXueE
	 gn6MB7qr3eVvHeEUqMjHUREIcxjiX808dTOLGTT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 014/272] Input: synaptics-rmi4 - fix F55 transmitter electrode count typo
Date: Thu, 20 Aug 2026 16:53:18 +0200
Message-ID: <20260820145231.664772092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 6058f0fea10f3caf63a435677358d1b8e9325114 upstream.

During F55 sensor detection, the transmitter (TX) electrode count was
incorrectly assigned the value of the receiver (RX) electrode count
due to copy-paste typos.

This incorrect value was then propagated to the driver data and used
by F54 to determine the diagnostics report size. On devices with more
RX than TX electrodes, this inflated the perceived TX count, leading
to incorrect report size calculations and potential out-of-bounds
buffer accesses.

Fix the typos by correctly assigning the TX electrode counts.

Fixes: 6adba43fd222 ("Input: synaptics-rmi4 - add support for F55 sensor tuning")
Fixes: c762cc68b6a1 ("Input: synaptics-rmi4 - propagate correct number of rx and tx electrodes to F54")
Reported-by: sashiko-bot@kernel.org
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Link: https://patch.msgid.link/20260626051802.4033172-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f55.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/rmi4/rmi_f55.c
+++ b/drivers/input/rmi4/rmi_f55.c
@@ -54,10 +54,10 @@ static int rmi_f55_detect(struct rmi_fun
 	f55->num_tx_electrodes = f55->qry[F55_NUM_TX_OFFSET];
 
 	f55->cfg_num_rx_electrodes = f55->num_rx_electrodes;
-	f55->cfg_num_tx_electrodes = f55->num_rx_electrodes;
+	f55->cfg_num_tx_electrodes = f55->num_tx_electrodes;
 
 	drv_data->num_rx_electrodes = f55->cfg_num_rx_electrodes;
-	drv_data->num_tx_electrodes = f55->cfg_num_rx_electrodes;
+	drv_data->num_tx_electrodes = f55->cfg_num_tx_electrodes;
 
 	if (f55->qry[F55_PHYS_CHAR_OFFSET] & F55_CAP_SENSOR_ASSIGN) {
 		int i, total;


