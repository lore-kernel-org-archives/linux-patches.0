Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43081519BF;
	Wed,  5 Feb 2025 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768106; cv=none; b=uMkCtVPg7BbAhSLfV6A827+S9c5B+Epci2RRY/plAe95BBDLk2fTXY8TI5l1EDcE9Ub2mkbfzYSllQQGuwFdrOd3zhXaC4SKk9Xfb8zyRBxYr3eJ6F7ITQYJuG7rXi0g6D6JPWklu7b8zS+qPk65xwT3zmOPwvtYq1mnh7Ps+Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768106; c=relaxed/simple;
	bh=/FQTdvLsDmzGYafsJWeTgNX6ijSuAzxJG6XqyC4FDZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EA7cbYerMkKHTho+GGZGnh+baZbgJ3BeO5xLCi2rJhdEB5I50jWp5QQT2l08bw2UD1Ydfbc7csKhulOfva10FpORc6BeL0Elpm0i0vCRPNmV16S7Gdwhs/KPquhSqTbrRLUhH2DJYgyZm/QLCclYT2n7Z9tu78zB/Tv1TkIw/8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IabFZYqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IabFZYqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A8EC4CED1;
	Wed,  5 Feb 2025 15:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768106;
	bh=/FQTdvLsDmzGYafsJWeTgNX6ijSuAzxJG6XqyC4FDZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IabFZYqXpOlez1Ym7RI2PDqwF6BtX2oBDwh/khKFKRtLYg/ZG8aml+J/DYrq/L5Uv
	 3u0Tw/SIliJJjOmXouAsYNHgQPomyswrNIJeeM0txlRF2vr+Aoa214JJqs8dYcUNXF
	 /ZxAwVSsAEIJv6iHS7nBgIMX/hwz9anoQBxTOxHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sean Rhodes <sean@starlabs.systems>
Subject: [PATCH 6.12 554/590] drivers/card_reader/rtsx_usb: Restore interrupt based detection
Date: Wed,  5 Feb 2025 14:45:09 +0100
Message-ID: <20250205134516.465882118@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


