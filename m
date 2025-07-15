Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D62E7646;
	Tue, 15 Jul 2025 13:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586292; cv=none; b=U70LhIPvIAJycvYOr0CRrZ2fd1Eztd2aD/NxQajT+nLyj/QIlJZiO02QFCtotaU39k2jEDxXR3A6cDT9uj0khBgM2V7oWCcF9P/79/0tDWiMkaRLb0jnQ1qXocYHn59tRMZ9sB5MAoETMmEaF6annrsVLKW3SUEOU6fno941HiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586292; c=relaxed/simple;
	bh=ODVdmA2hY0ky5GROX++6qb0rYl2fE97Pu+dsJ04CMlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dV6/jDLnDlh0KIVkXh953lBL9tilkZAFDioZ+f+/wM767qMOJPw6ZmwuEB4+6iTzmT+tUeRtfd4qzCHTmNTmyRcEvH2nnR/FiWWzDKHklyyJGsLcBdkTr5kzSH7+8tzvLokPAsYVXYh6C5EFQA7D9iOL0BG3fQMHTfHwk1TlSuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHori50y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHori50y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D34AC4CEE3;
	Tue, 15 Jul 2025 13:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586292;
	bh=ODVdmA2hY0ky5GROX++6qb0rYl2fE97Pu+dsJ04CMlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHori50yJhngtOwE/DOhEE+9jdn4sjMiUkDdP+PEq33ZK/9xSRdBB9EUvC99PGNHV
	 iyKZ2CmMCvM2PZ2vnjzvEtaSNVsUYW06drUwjjCznQOmxk40HozpH9OfjVa42WJ8D1
	 ko60xhQF4omEzuCuDnzJIDadqRkdfw8sG7Cer230=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/148] usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode
Date: Tue, 15 Jul 2025 15:12:13 +0200
Message-ID: <20250715130800.756259356@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a2a1baabca933..35d7a4d40d9a4 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -288,6 +288,10 @@ static int dp_altmode_vdm(struct typec_altmode *alt,
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



