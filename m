Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE9813A258;
	Thu,  3 Jul 2025 14:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553994; cv=none; b=ElBE1HqMDvgcGT61+sgGx29f/56YcjHL1uVskR7IcreWQNoa/kNJDHi81w04TVHVD7TRp1MvGnuMBSubj5oT/LSqfyFan12xW0/4iCi0ihI/XT2vsIw1BfbqLE5pLw3BLHCknE7OekmaVYD64s6ghzlEhofQPgdtBftbBTxKq20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553994; c=relaxed/simple;
	bh=ahL82fnekKioLZw/k24U3oVDOrTwMcpg+9ujcU2kCKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SR0/u6eTsN2c40+AOhoSbYbVTS2GBPo00bImCIZ5P0nR3xv20RQ8ZVEHKV6ZBVY8MfKWkkpqbgtabSE9eod3yjPEnXPcKkM6Mpm8hKYsP3E/8AUWgckq9oVuMLj55/huSynVsXVu7tOYx65dkRrOiqNEXaQ+95MiA9s8z7df4cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWAY43cg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWAY43cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0CEC4CEF0;
	Thu,  3 Jul 2025 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553994;
	bh=ahL82fnekKioLZw/k24U3oVDOrTwMcpg+9ujcU2kCKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWAY43cgyY2dJcopi/ZnB2lfgnLrEIV1NJmMdlPdzauZA7vZADjJwPYVhCCl902PH
	 MZbgILdiWFShHhIHsaUxDw+YTAjK49rbBao4aigTbjYVE7c43H69GVkyKUI2S6z0tL
	 3AeJ9LTVmLc52ACiR9b6kNb6JSurBnKDp0NgZJzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/218] usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode
Date: Thu,  3 Jul 2025 16:39:55 +0200
Message-ID: <20250703143957.818865475@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jos Wang <joswang@lenovo.com>

[ Upstream commit b4b38ffb38c91afd4dc387608db26f6fc34ed40b ]

Although some Type-C DRD devices that do not support the DP Sink
function (such as Huawei Mate 40Pro), the Source Port initiates
Enter Mode CMD, but the device responds to Enter Mode ACK, the
Source port then initiates DP Status Update CMD, and the device
responds to DP Status Update NAK.

As PD2.0 spec ("6.4.4.3.4 Enter Mode Command")，A DR_Swap Message
Shall Not be sent during Modal Operation between the Port Partners.
At this time, the source port initiates DR_Swap message through the
"echo device > /sys/class/typec/port0/data_role" command to switch
the data role from host to device. The device will initiate a Hard
Reset for recovery, resulting in the failure of data role swap.

Therefore, when DP Status Update NAK is received, Exit Mode CMD is
initiated to exit the currently entered DP altmode.

Signed-off-by: Jos Wang <joswang@lenovo.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250209071926.69625-1-joswang1221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/altmodes/displayport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index 92cc1b1361208..4976a7238b287 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -393,6 +393,10 @@ static int dp_altmode_vdm(struct typec_altmode *alt,
 		break;
 	case CMDT_RSP_NAK:
 		switch (cmd) {
+		case DP_CMD_STATUS_UPDATE:
+			if (typec_altmode_exit(alt))
+				dev_err(&dp->alt->dev, "Exit Mode Failed!\n");
+			break;
 		case DP_CMD_CONFIGURE:
 			dp->data.conf = 0;
 			ret = dp_altmode_configured(dp);
-- 
2.39.5



