Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E6853445C;
	Mon, 31 Aug 2026 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183911; cv=none; b=GuGeOqQI3JfzBKzGsZlUae2IOqsIMW/xleSr3DrDbDZyCZTrluYoOR1qRp5rxoeDQdqYyHjBNGszLOOpW5vaVGG632OEuvxMwjkBAsYI28MgDIVXNVQd5QpiotWHPA1T+DET877dg4UdTkjDQfevJZIqmhJBsO0azjj3v1mbfKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183911; c=relaxed/simple;
	bh=fDtpt751XpINn+fjFAcKWg5DZREHIWZMxGWxe3sq6Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPzb+L3/DwXrY0Xbqq7S1sYjp/UcIRR2+zKx73hu49ugXOgLIdSghP7mdRZpfkiVmXyOBclwGPJn+pGN5KVdB/1VBF+ZeRpknhwVxhVH/k47835tqiiPhh4Ip87Z58jhOflxNXm+cDR7XH9cldo6EPdD4VB1GORSZadeZ467LWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yl7Qdyfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yl7Qdyfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69591F000E9;
	Mon, 31 Aug 2026 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183909;
	bh=CbEE8tW4XJy40jTgCPbHUu2ZNI5+p9UfXs7ADHHdtHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yl7QdyfpfM4OjIScdin6q4ODXYcwk3Ejwwp2clXh/YKiGuIoYE6H/fGSErFFX3WM6
	 v5AhYblMb3Kp6nwE8o9GJflxJVgC1KLiTAbDUUT9fa8Js1Lun2H3iaoa+tRW7RkLrq
	 MWArPsTEAv3cIm20a1+wpQ1WABOMWNI+/vljIiNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 7.1 68/76] usb: core: Strengthen error handling in hub_hub_status()
Date: Mon, 31 Aug 2026 15:34:40 +0200
Message-ID: <20260831133402.928621586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit a29496745aa335d97f617385809583241e118610 upstream.

Add additional error handling after the call to get_hub_status() in
hub_hub_status().

get_hub_status() uses usb_control_msg() which does not verify that the
message is the correct length, substituting it for
usb_control_msg_recv() would also solve this issue but increase memory
allocations.

Instead, error handling is copied from the method used in
hub_ext_port_status(), which shares the same flow of logic as
hub_hub_status().

Assisted-by: gkh_clanker_t1000
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260722-usb_core_patches_2-v3-1-87622252bfdd@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -994,10 +994,12 @@ static int hub_hub_status(struct usb_hub
 
 	mutex_lock(&hub->status_mutex);
 	ret = get_hub_status(hub->hdev, &hub->status->hub);
-	if (ret < 0) {
+	if (ret < (int)sizeof(hub->status->hub)) {
 		if (ret != -ENODEV)
 			dev_err(hub->intfdev,
 				"%s failed (err = %d)\n", __func__, ret);
+		if (ret >= 0)
+			ret = -EIO;
 	} else {
 		*status = le16_to_cpu(hub->status->hub.wHubStatus);
 		*change = le16_to_cpu(hub->status->hub.wHubChange);


