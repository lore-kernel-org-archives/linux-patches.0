Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077C930BF7F;
	Mon, 13 Oct 2025 15:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369646; cv=none; b=ePO7uCaEeosAeky9t94rTN7EMkjVVgOfVv9wukOa0NaSLnh9FIv6aoxjFQYbM7ZMrK++vXvzBxHdxyjFje0jd7CBvRaWGTOeOC95eOQ9BMcohWYPI1YTw8IZueBY5iM3RSSjqZiTamMuDA5Q/YQrgBXPpztjTMYQIavqi8GW8Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369646; c=relaxed/simple;
	bh=hE6m/eTtqWLifKbWwGBYiyy5X6ilR5nZNnNicge7VDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkcgDTnk5f7jIBYvsyqX7YViusBLEZv0MLRJBS/ItlbaopQ97QlM0Nd6401FGfUyo1NG5vofdwp/Bp02YoyDK9SvcPXgDvrFXswWbmQaKIzKYB9fgadobyYsF/A8k1p38iaYW1LFSxpaN9msgdgoWVAAWyhtjzJrjfb/28dsRkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HS2lYFOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HS2lYFOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85015C4CEE7;
	Mon, 13 Oct 2025 15:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369645;
	bh=hE6m/eTtqWLifKbWwGBYiyy5X6ilR5nZNnNicge7VDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HS2lYFOK96eP0LbLIpiemvcRGPRD111a8tdHH/tLNOBV/uJuE/AkvfQqqvkO09y31
	 wlDiIJd6tuecF/FBTPJFgTT0oMRQQfCfcOiU9TdJ9oj2jD1VFX+l2lBda/hYrEFP/o
	 XBWiOeSpWLL/XKc6r0lG0jJ9e8sSqGTeNYe5UVgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 320/563] usb: gadget: configfs: Correctly set use_os_string at bind
Date: Mon, 13 Oct 2025 16:43:01 +0200
Message-ID: <20251013144422.858330780@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: William Wu <william.wu@rock-chips.com>

[ Upstream commit e271cc0d25015f4be6c88bd7731444644eb352c2 ]

Once the use_os_string flag is set to true for some functions
(e.g. adb/mtp) which need to response the OS string, and then
if we re-bind the ConfigFS gadget to use the other functions
(e.g. hid) which should not to response the OS string, however,
because the use_os_string flag is still true, so the usb gadget
response the OS string descriptor incorrectly, this can cause
the USB device to be unrecognizable on the Windows system.

An example of this as follows:

echo 1 > os_desc/use
ln -s functions/ffs.adb configs/b.1/function0
start adbd
echo "<udc device>" > UDC   #succeed

stop adbd
rm configs/b.1/function0
echo 0 > os_desc/use
ln -s functions/hid.gs0 configs/b.1/function0
echo "<udc device>" > UDC  #fail to connect on Windows

This patch sets the use_os_string flag to false at bind if
the functions not support OS Descriptors.

Signed-off-by: William Wu <william.wu@rock-chips.com>
Fixes: 87213d388e92 ("usb: gadget: configfs: OS String support")
Link: https://lore.kernel.org/r/1755833769-25434-1-git-send-email-william.wu@rock-chips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index f94ea196ce547..6bcac85c55501 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1750,6 +1750,8 @@ static int configfs_composite_bind(struct usb_gadget *gadget,
 		cdev->use_os_string = true;
 		cdev->b_vendor_code = gi->b_vendor_code;
 		memcpy(cdev->qw_sign, gi->qw_sign, OS_STRING_QW_SIGN_LEN);
+	} else {
+		cdev->use_os_string = false;
 	}
 
 	if (gadget_is_otg(gadget) && !otg_desc[0]) {
-- 
2.51.0



