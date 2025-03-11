Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD0725DD02;
	Tue, 11 Mar 2025 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705611; cv=none; b=M3bCekL1LKxIXMOAigolndpCluokca/6RoAx3yFNuY+2mjcQCfhZD/b0tqRLvnSxMhQOQiFVIyQrRDZ/yA7pdj7mPb3rYYmQ0p+Me5rmPxJcbwlrpwtbtbqvqUKAPDQY+b8use1H8scZ3gFPaXamj4u1LSynDh79NcpfDKbaqFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705611; c=relaxed/simple;
	bh=LmAu+5QNkv5Q9drm+US42GPj1DpNFU0VExyYw8MpqlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5jt+5SWDTNyYNHQHU/2vnr25jRTBNjEETroxuYZZYSDoaTBpTgO2whw70PaB4915OKUq/AAp88+BYFEB5qsU9zI6u5g05wui8i/Lfls2IoGPqk8oVeWBakbWW8KeIVXa+2PReyzfqVdFPrSsGRInjWky0MAZvdjRRKX8eg5UeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0FPJ1y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0FPJ1y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14850C4CEE9;
	Tue, 11 Mar 2025 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705611;
	bh=LmAu+5QNkv5Q9drm+US42GPj1DpNFU0VExyYw8MpqlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0FPJ1y0SLhcSEFL4Gk+rlvMrxHg+ObCCgwaaOAbcNMYbZo82x43WklxBqUeQPhfi
	 IG2hQvWZrxLjMKwJWrwROyRMPmFfRjawYsz1zZjxpSrGjLNi2L5KGXhLQIhXFe2bw9
	 rc6nlMJyfEjIrDD0plJiIUl5j393CnDgHMM2wKio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sean Rhodes <sean@starlabs.systems>
Subject: [PATCH 5.4 077/328] drivers/card_reader/rtsx_usb: Restore interrupt based detection
Date: Tue, 11 Mar 2025 15:57:27 +0100
Message-ID: <20250311145717.949396272@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Rhodes <sean@starlabs.systems>

commit 235b630eda072d7e7b102ab346d6b8a2c028a772 upstream.

This commit reintroduces interrupt-based card detection previously
used in the rts5139 driver. This functionality was removed in commit
00d8521dcd23 ("staging: remove rts5139 driver code").

Reintroducing this mechanism fixes presence detection for certain card
readers, which with the current driver, will taken approximately 20
seconds to enter S3 as `mmc_rescan` has to be frozen.

Fixes: 00d8521dcd23 ("staging: remove rts5139 driver code")
Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Link: https://lore.kernel.org/r/20241119085815.11769-1-sean@starlabs.systems
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_usb.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -286,6 +286,7 @@ static int rtsx_usb_get_status_with_bulk
 int rtsx_usb_get_card_status(struct rtsx_ucr *ucr, u16 *status)
 {
 	int ret;
+	u8 interrupt_val = 0;
 	u16 *buf;
 
 	if (!status)
@@ -308,6 +309,20 @@ int rtsx_usb_get_card_status(struct rtsx
 		ret = rtsx_usb_get_status_with_bulk(ucr, status);
 	}
 
+	rtsx_usb_read_register(ucr, CARD_INT_PEND, &interrupt_val);
+	/* Cross check presence with interrupts */
+	if (*status & XD_CD)
+		if (!(interrupt_val & XD_INT))
+			*status &= ~XD_CD;
+
+	if (*status & SD_CD)
+		if (!(interrupt_val & SD_INT))
+			*status &= ~SD_CD;
+
+	if (*status & MS_CD)
+		if (!(interrupt_val & MS_INT))
+			*status &= ~MS_CD;
+
 	/* usb_control_msg may return positive when success */
 	if (ret < 0)
 		return ret;


