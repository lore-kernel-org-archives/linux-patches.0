Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3153404BF6;
	Tue, 21 Jul 2026 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673768; cv=none; b=BFYcvs/GonjoogTJEsdpXIPyQLo4tK2wLVlO6NtXYb0gYX9FBuAqqsUppDPNDB6oJiMUEZjUAMeO+rLcXyMcoGOH8wL9NVmQIvxXAg2tffm5yh7qz79sHGYBrW4SVOFLspR9wh2ouy5o+ka772+cDUQU2+r2xtmuQEhYdO53XDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673768; c=relaxed/simple;
	bh=ceFsmJYH9VOL2f4kuFFn1lrjqhOH8Iw5WZRpa0HtNDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwU7jVMY9jOnDF5+t4/QK7NZoKLv2jQAoUg6fNeZOHW+fX+Z7xGgmeYBi+YQQBMApnI8mMDpJQNQTQyxYHpEpmJORaUxEHAgQCtCxTwEUSER+ez4R7uAAqIGa/vaQ2wvxSwXDe4wjzGf3fgpInYr8RkcwmS6zIHcpb5qSR4ClJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4+s9BlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4+s9BlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F09E1F000E9;
	Tue, 21 Jul 2026 22:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673766;
	bh=qBaNTaPCD6TJl2k/BQqnbkaCG25ckkuqdlz/2r2V0rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4+s9BlTev2ycvscSoYwA+qJcogoP00lMed0I05u+EaZ+SVjU8T8yhKftvpKUmsGP
	 ozpgN5q8itVBKyFgv7bKhvIV36D35wfk/5dOp45AQeJAWyfh0r99C6n/ayWlO+89hx
	 HTCulHAYn+IfBwppIerkpOTgpSdng24V5rAcISKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/699] usb: host: max3421: Reject hub port requests for non-existent ports
Date: Tue, 21 Jul 2026 17:20:46 +0200
Message-ID: <20260721152402.174993876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit 11b5c101e2fd206104b05bc92554d356989423a8 ]

The `max3421_hub_control()` function handles USB hub class requests
to the virtual root hub. The `GetPortStatus` case correctly rejects
requests with `index != 1`, since the virtual root hub has only a
single port. However, the `ClearPortFeature` and `SetPortFeature`
cases lack the same check.

Fix this by extending the `index != 1` rejection to both cases,
matching the existing behavior of `GetPortStatus`.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Link: https://patch.msgid.link/20260518224901.1887013-3-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 7425b12595c7d2..e4d2197eb5bb71 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1694,6 +1694,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 	case ClearHubFeature:
 		break;
 	case ClearPortFeature:
+		if (index != 1)
+			goto error;
 		switch (value) {
 		case USB_PORT_FEAT_SUSPEND:
 			break;
@@ -1737,6 +1739,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 		break;
 
 	case SetPortFeature:
+		if (index != 1)
+			goto error;
 		switch (value) {
 		case USB_PORT_FEAT_LINK_STATE:
 		case USB_PORT_FEAT_U1_TIMEOUT:
-- 
2.53.0



