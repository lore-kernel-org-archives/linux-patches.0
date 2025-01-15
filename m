Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD671E98F4;
	Wed, 15 Jan 2025 10:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937938; cv=none; b=lO/8R+NeJbw3YTYhG3ZCEXus0nDbIFLUKAM09SZef/7rMJTSgfwNdgoXAepG7JNxErwIYDxzAWmIUyAxtJJOnuKsausuZAXlKTOuyQTsy4+0W+2rMHjDgxTxgcCTI0249rYyhsVraiT+iwyyLmbYwvSQsIGNsGjCUdsUPofwNfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937938; c=relaxed/simple;
	bh=YGsExRkN8GN110HkNpAmN8CgtkKfUZvIPkiNaXNTC+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnfXOu1iHGicqL6EIN6TPFiiTku9H+crv+aVW84R7F+vDrb2Og/Do5yrQQV3EyEldPiNnSjbL7nPIUB7LfrUeEe/TrI+t1jOsPQhxf5/wNZsrSPQQb+j7CFJK2mIWXZmJo621MfbIJlFYKy30RqqaIHcr4xa1PCY9zoqRxKr5oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCUL/fpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCUL/fpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF483C4CEE2;
	Wed, 15 Jan 2025 10:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937938;
	bh=YGsExRkN8GN110HkNpAmN8CgtkKfUZvIPkiNaXNTC+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCUL/fpT+ONt8Olwh7kYAVi8UGdUd1si3+Y1AFwsiTyefEicc6SAdeG239qbU+ZtM
	 fvchedMlra+GWke2dRcWNnM+0IkezROepyH/L90WyjWetep/DmqqndR10Fht3ksiOf
	 MBh3js0d9ZwToNuOg5AJ4TwpILemqEZdvy1UhV2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/189] net: libwx: fix firmware mailbox abnormal return
Date: Wed, 15 Jan 2025 11:35:24 +0100
Message-ID: <20250115103607.480646322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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
index 1bf9c38e4125..deaf670c160e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -334,27 +334,25 @@ int wx_host_interface_command(struct wx *wx, u32 *buffer,
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



