Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECE71DB13A;
	Wed, 15 Jan 2025 10:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938543; cv=none; b=LJ8p9kWW2VNScbG/pyZa60NdZTYDcrF+y5Qkaomw4roAZhlCXLdYwlhobyPO4eXiZotq50sX1xiGeRBlL06X9vWfuTaivTO8XVnqZmftX8tDEFHO/2voQo5I3+AAbz/o6L+2TpFV3SIA59j5wH/ZWmkYX1dAJbaujmxB2SwQl2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938543; c=relaxed/simple;
	bh=ENY2C5j1VD1oJM5ny3+fT1PEorqr9aZgUQXDgoOEA80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu3qlJbqCfz+sRWjy+P7xIWerYFuYifIs15m26FW29/TF+rn1fLJRc3taUKg9LxRIdH6lXjMXqUebGB5gwyZwMiTc/eLITLhN+pL4dan38xg3+4TO30FVE0LaR0ZIi4crTm/mYJUbm+/vp55X52IW8h4PVebo2mCSboMY+0qS3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mk0lZLta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mk0lZLta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DADC4CEDF;
	Wed, 15 Jan 2025 10:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938543;
	bh=ENY2C5j1VD1oJM5ny3+fT1PEorqr9aZgUQXDgoOEA80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk0lZLtawE6GKMZB4dP/hFbZRrXttvNUN2sM+lhww+yBUkN3QFmFz8HNAqx6gsSrr
	 ant8bQFAl0g2SAeaOvTlz08AOEGC3daw/ITHEJISotk8JGTbHyaEq7HlObpcnLbCQi
	 87NZCi1EFCvSjeahY/sPwthJerZ/ISw8NfgbyQC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/129] net: libwx: fix firmware mailbox abnormal return
Date: Wed, 15 Jan 2025 11:36:38 +0100
Message-ID: <20250115103555.291943420@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 8ce4f287524c74a118b0af1eebd4b24a8efca57a ]

The existing SW-FW interaction flow on the driver is wrong. Follow this
wrong flow, driver would never return error if there is a unknown command.
Since firmware writes back 'firmware ready' and 'unknown command' in the
mailbox message if there is an unknown command sent by driver. So reading
'firmware ready' does not timeout. Then driver would mistakenly believe
that the interaction has completed successfully.

It tends to happen with the use of custom firmware. Move the check for
'unknown command' out of the poll timeout for 'firmware ready'. And adjust
the debug log so that mailbox messages are always printed when commands
timeout.

Fixes: 1efa9bfe58c5 ("net: libwx: Implement interaction with firmware")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20250103081013.1995939-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c | 24 ++++++++++------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 52130df26aee..d6bc2309d2a3 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -242,27 +242,25 @@ int wx_host_interface_command(struct wx *wx, u32 *buffer,
 	status = read_poll_timeout(rd32, hicr, hicr & WX_MNG_MBOX_CTL_FWRDY, 1000,
 				   timeout * 1000, false, wx, WX_MNG_MBOX_CTL);
 
+	buf[0] = rd32(wx, WX_MNG_MBOX);
+	if ((buf[0] & 0xff0000) >> 16 == 0x80) {
+		wx_err(wx, "Unknown FW command: 0x%x\n", buffer[0] & 0xff);
+		status = -EINVAL;
+		goto rel_out;
+	}
+
 	/* Check command completion */
 	if (status) {
-		wx_dbg(wx, "Command has failed with no status valid.\n");
-
-		buf[0] = rd32(wx, WX_MNG_MBOX);
-		if ((buffer[0] & 0xff) != (~buf[0] >> 24)) {
-			status = -EINVAL;
-			goto rel_out;
-		}
-		if ((buf[0] & 0xff0000) >> 16 == 0x80) {
-			wx_dbg(wx, "It's unknown cmd.\n");
-			status = -EINVAL;
-			goto rel_out;
-		}
-
+		wx_err(wx, "Command has failed with no status valid.\n");
 		wx_dbg(wx, "write value:\n");
 		for (i = 0; i < dword_len; i++)
 			wx_dbg(wx, "%x ", buffer[i]);
 		wx_dbg(wx, "read value:\n");
 		for (i = 0; i < dword_len; i++)
 			wx_dbg(wx, "%x ", buf[i]);
+		wx_dbg(wx, "\ncheck: %x %x\n", buffer[0] & 0xff, ~buf[0] >> 24);
+
+		goto rel_out;
 	}
 
 	if (!return_data)
-- 
2.39.5



