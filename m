Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE06A1684B0;
	Wed,  5 Feb 2025 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766601; cv=none; b=iQEHoHX3p3SSPcMfvuAartQeH70oMOsYR95Ifb4y0JNp1Kr9gaoQ3G7Q2siy3zOj2yX/vQZ6TKuiiwrTE8WNumzCnH38hpMY0hFhO+RlhokNIS/tU9WyqgbDOf2ZhGIh7YNgyR+kcjLzmhbTmqHxB8yBsDn+RTQ/u6+G5hvtxbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766601; c=relaxed/simple;
	bh=160zjrfayXmEqCnY3VF5WyJOSxMJynbCRsliyksLMl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3E3nLhePjrbB1rRPkS+SfTJ057GgBqPR78IzxFdl0tWvF5rf4D30qfXg1PMGR3t+3uFsocH8VbHbnUj82gNMFcdTd6AfeNWyOpM2yWj2bsfkgE9zm8cHScjpEidfvFxYd/g0zA5nNC41PT1iz597sCPZJiNzJt0BITHAzbAgBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovxm2hH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovxm2hH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5334AC4CEE2;
	Wed,  5 Feb 2025 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766601;
	bh=160zjrfayXmEqCnY3VF5WyJOSxMJynbCRsliyksLMl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovxm2hH1ogueXwHY7Bz5ifjJEWx2MsT1sRQl2OfMxpkG8kncS3pbrKLzuTNzWfvD7
	 EpaKi2b0131DUDyQqjuamppXRe+yy6BiKDHENt9JXtilOXO1E9QV5g4KjrP0nuwyfc
	 DH29M9XPyzjKunCEtDfGI+18oQDVaEpCodNUcUIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sean Rhodes <sean@starlabs.systems>
Subject: [PATCH 6.6 377/393] drivers/card_reader/rtsx_usb: Restore interrupt based detection
Date: Wed,  5 Feb 2025 14:44:56 +0100
Message-ID: <20250205134434.717887616@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


