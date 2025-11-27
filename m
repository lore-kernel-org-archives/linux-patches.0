Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A023321D0;
	Thu, 27 Nov 2025 15:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255642; cv=none; b=TFkMRoSMuYhaIYcQITZXi9snTXrbQU0sMkCqz9quuMWXoUILWHPltl/iGjPOWvt307vSTkqXjlWH1OK0UhM/rcoMpQt6YGvk7zXWsTG0HjThJ2nxNreYd8x55s5A6PBxU8in9u6RP7Wnj5ukjWyn3ebFbWsuZyuVzRKRa56nHKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255642; c=relaxed/simple;
	bh=wfMjTRoSaKSHLM5HbQGgEOn5yGi5CGrzq6FpZIRB87w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzubEcOGMBoJLtp5OsE0riJOM+1sMw9fp1maR0vaq9ynCbC7LC4e3CLtuBtnPmeF77o4uVrwHkK+L9qwqGr7oHGUoLHeQzYVBYGbSGSt7fuitJQh2ylF0JS4pkG8idS/rcp2K5tuIY0J90TZAnm3kMXMxtsbQa2G3D6c1JHU+nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=On385OGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="On385OGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35856C4CEF8;
	Thu, 27 Nov 2025 15:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255641;
	bh=wfMjTRoSaKSHLM5HbQGgEOn5yGi5CGrzq6FpZIRB87w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=On385OGMmAW94KLl+YUmIAtulo3dIcFyeZUv4CDQCR5l4rtzBrX7OCgq4hrp4Wyi2
	 zCJmB/97jt/x9NB6juYGE2IotEBTaGIQWSCkYG2DE1Z/XGlga6Cj+y3lAN8Pqqgw9e
	 XXDDfPOB21dwcTNhgij2dntCbsLzVNMi9TymYjG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.17 030/175] wifi: rtw89: hw_scan: Dont let the operating channel be last
Date: Thu, 27 Nov 2025 15:44:43 +0100
Message-ID: <20251127144044.066135873@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit e837b9091b277ae6f309d7e9fc93cb0308cf461f upstream.

Scanning can be offloaded to the firmware. To that end, the driver
prepares a list of channels to scan, including periodic visits back to
the operating channel, and sends the list to the firmware.

When the channel list is too long to fit in a single H2C message, the
driver splits the list, sends the first part, and tells the firmware to
scan. When the scan is complete, the driver sends the next part of the
list and tells the firmware to scan.

When the last channel that fit in the H2C message is the operating
channel something seems to go wrong in the firmware. It will
acknowledge receiving the list of channels but apparently it will not
do anything more. The AP can't be pinged anymore. The driver still
receives beacons, though.

One way to avoid this is to split the list of channels before the
operating channel.

Affected devices:

* RTL8851BU with firmware 0.29.41.3
* RTL8832BU with firmware 0.29.29.8
* RTL8852BE with firmware 0.29.29.8

The commit 57a5fbe39a18 ("wifi: rtw89: refactor flow that hw scan handles channel list")
is found by git blame, but it is actually to refine the scan flow, but not
a culprit, so skip Fixes tag.

Reported-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/0abbda91-c5c2-4007-84c8-215679e652e1@gmail.com/
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/c1e61744-8db4-4646-867f-241b47d30386@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -7705,6 +7705,13 @@ int rtw89_hw_scan_add_chan_list_be(struc
 	INIT_LIST_HEAD(&list);
 
 	list_for_each_entry_safe(ch_info, tmp, &scan_info->chan_list, list) {
+		/* The operating channel (tx_null == true) should
+		 * not be last in the list, to avoid breaking
+		 * RTL8851BU and RTL8832BU.
+		 */
+		if (list_len + 1 == RTW89_SCAN_LIST_LIMIT_AX && ch_info->tx_null)
+			break;
+
 		list_move_tail(&ch_info->list, &list);
 
 		list_len++;


