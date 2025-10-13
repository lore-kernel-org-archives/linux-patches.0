Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AFF2D46B3;
	Mon, 13 Oct 2025 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367687; cv=none; b=K3YqHVAiWzAGp5b3wuqhor1NBX9PerUdEuRK6SeGglA59JnmGNW4LgHeExBDi/BR1wJC1HAkI3LAMtTTydnbtjoe5y7Kbqibs1Lmr3bmPU4Kp7g7S+cvc8ko54aEIHMNGByCO28t7NhmHaBD7MjaAI/J5f2qfBxKAIFkKDAbA0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367687; c=relaxed/simple;
	bh=jiVQTjJdFnYlNxd1u1gndieMwApl3phasNs1RopqPxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MK1rdPmJ2shbuvv5oGt7TQOoiP2QB1iJfJR8aiiYn7IZ0WSeifkKiOUgFE36bsfb9oYpqaz230vKtRZZWX1ZXT+47OerATa0Q23tECFoIqzszmvGK0B4YaNne4VUGOapvOca1Y81GhCyxroZYVOX5UqqRa730GsgfTxlFuGlmnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTzk6x4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTzk6x4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AAEC4CEE7;
	Mon, 13 Oct 2025 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367687;
	bh=jiVQTjJdFnYlNxd1u1gndieMwApl3phasNs1RopqPxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTzk6x4erAVpgLwYMwbJFoTdR8TBKO8UFASHt5qFTPu951purkSWd/IKfCdD2l5xZ
	 OTgc2RJIYrw2w6nTRmJumhLNtOHAe8J/Up8+sQ2pk8qFye0/Uq1yNheT9v495mEmLa
	 efReTRAwc3ZcXXsTeuemMWjEn9Yozk5+N9Y5y6lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/196] usb: gadget: configfs: Correctly set use_os_string at bind
Date: Mon, 13 Oct 2025 16:44:48 +0200
Message-ID: <20251013144318.826475878@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4c89f7629d530..9e8af571448bf 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1747,6 +1747,8 @@ static int configfs_composite_bind(struct usb_gadget *gadget,
 		cdev->use_os_string = true;
 		cdev->b_vendor_code = gi->b_vendor_code;
 		memcpy(cdev->qw_sign, gi->qw_sign, OS_STRING_QW_SIGN_LEN);
+	} else {
+		cdev->use_os_string = false;
 	}
 
 	if (gadget_is_otg(gadget) && !otg_desc[0]) {
-- 
2.51.0



