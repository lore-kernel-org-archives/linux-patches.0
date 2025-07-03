Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B062EE97A;
	Thu,  3 Jul 2025 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554835; cv=none; b=mpWjNYFe6XfSdU6hKOQ42ckxjDAbtWb/x64403BnEzE5jE258468rETqdY7EH7Czhx8uMpcraR8YtcrSEoChW45lpK3rIQ87XrA1i9gUlmJn2W/EcXkqhI4/8VId6UMtbHnPawsEav2MdzIxmVYXGaDyrJ5s4L6k2sTf4CSZN6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554835; c=relaxed/simple;
	bh=oknGgImAYoUPEMZkKwV985zpXkgrw/LAdP+eOS43GJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+Nz6cje1a1Ay19c4f4I/tTNNxjqodWfFRBdGsPFMZPb70bjhUW+wUmso4wevl1qMnGuFcd9Zw3UIg94RU9IZUaO4uc1LfpNRFnWzlQlEAl3Y989ma0N3x1I88+sOEguXAYVKqj3sNjKhkVrjxYANlSBmmbet4X5oVAQD6eSUDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMd/yivZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMd/yivZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6895CC4CEE3;
	Thu,  3 Jul 2025 15:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554834;
	bh=oknGgImAYoUPEMZkKwV985zpXkgrw/LAdP+eOS43GJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMd/yivZY5CppjcMR5Gu7C2+nOhYn0ABUvem7DTl6H5Sn9A0vlcLEQZ3DbGG02kxD
	 U+JRe6AWxTymiFon/CI6gtrpioPvOyN53Xq3s7Q7883tF+MwbRQ6QhveizHAnMEPNM
	 VFwxkGt3Qt+uiPpn2G6fXt0+fexCql+UBqTGv0AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 063/263] usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode
Date: Thu,  3 Jul 2025 16:39:43 +0200
Message-ID: <20250703144006.832645269@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ac84a6d64c2fb..b09b58d7311de 100644
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



