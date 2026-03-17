Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088C128B7DB;
	Tue, 17 Mar 2026 17:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767882; cv=none; b=MDKqp7GHfc0Yu+gtM5bicWYrkhcf2jk9Cj6la2dQ80xVpAekh6/faqbb09WJHN2xXtMvU6il5L28WF3u+2fpHwil5s6ea/dZTrRP4d2w+bKlOf7emGEfettH9zmrpI/zvLhVLQTIuY0fzKM+e/R7ogO28YSvTZK1m6A/ASK3H5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767882; c=relaxed/simple;
	bh=xvSlDXXhcPu+qMbPOj2y3FYFzuTe+Yt+k9delgUcEEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf3oyPbFxJ/elnybWgTAPlEeuo+64NH4AakedKWfISECYO1W/Gpo9IEXE1i8divAHHHuJtzwGCdFd4TWGi3vdcuLxcmcofHBJLcfALlb15tqHbVnZEb127ZYSGUqMx3SBrLKwWglv0ru7rsn1ly5BTV8PA6pZp1v8JicApSPBzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=if3WZjlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="if3WZjlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D28C19424;
	Tue, 17 Mar 2026 17:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767881;
	bh=xvSlDXXhcPu+qMbPOj2y3FYFzuTe+Yt+k9delgUcEEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=if3WZjlJOHOU1cgFmKhvBTkfunkXZh00kvyUPuAS9cGunXtiyRu2dK5a2KzVXEezw
	 DzhbO3vVH2uHTomJYT5q2ioY+RE1KdQCkMUHjVljHxTZqUR1I7/j1wDvA/6/N0nbd4
	 E5CV4Pah8xdF+6eDKpkgqYkhoyBZ+8Edc2106hCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.18 147/333] usb: gadget: f_tcm: Fix NULL pointer dereferences in nexus handling
Date: Tue, 17 Mar 2026 17:32:56 +0100
Message-ID: <20260317163004.809552210@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit b9fde507355342a2d64225d582dc8b98ff5ecb19 upstream.

The `tpg->tpg_nexus` pointer in the USB Target driver is dynamically
managed and tied to userspace configuration via ConfigFS. It can be
NULL if the USB host sends requests before the nexus is fully
established or immediately after it is dropped.

Currently, functions like `bot_submit_command()` and the data
transfer paths retrieve `tv_nexus = tpg->tpg_nexus` and immediately
dereference `tv_nexus->tvn_se_sess` without any validation. If a
malicious or misconfigured USB host sends a BOT (Bulk-Only Transport)
command during this race window, it triggers a NULL pointer
dereference, leading to a kernel panic (local DoS).

This exposes an inconsistent API usage within the module, as peer
functions like `usbg_submit_command()` and `bot_send_bad_response()`
correctly implement a NULL check for `tv_nexus` before proceeding.

Fix this by bringing consistency to the nexus handling. Add the
missing `if (!tv_nexus)` checks to the vulnerable BOT command and
request processing paths, aborting the command gracefully with an
error instead of crashing the system.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable <stable@kernel.org>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260219023834.17976-1-jiashengjiangcool@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1222,6 +1222,13 @@ static void usbg_submit_cmd(struct usbg_
 	se_cmd = &cmd->se_cmd;
 	tpg = cmd->fu->tpg;
 	tv_nexus = tpg->tpg_nexus;
+	if (!tv_nexus) {
+		struct usb_gadget *gadget = fuas_to_gadget(cmd->fu);
+
+		dev_err(&gadget->dev, "Missing nexus, ignoring command\n");
+		return;
+	}
+
 	dir = get_cmd_dir(cmd->cmd_buf);
 	if (dir < 0)
 		goto out;
@@ -1482,6 +1489,13 @@ static void bot_cmd_work(struct work_str
 	se_cmd = &cmd->se_cmd;
 	tpg = cmd->fu->tpg;
 	tv_nexus = tpg->tpg_nexus;
+	if (!tv_nexus) {
+		struct usb_gadget *gadget = fuas_to_gadget(cmd->fu);
+
+		dev_err(&gadget->dev, "Missing nexus, ignoring command\n");
+		return;
+	}
+
 	dir = get_cmd_dir(cmd->cmd_buf);
 	if (dir < 0)
 		goto out;


