Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E142D8DB9;
	Mon, 27 Oct 2025 18:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590509; cv=none; b=jawbqMIRTI8uuqBtj1KQFV2zoFFsbNJQACv3fXGnPPUfVAQHAKIZtbqELnoT+RdOF6BKCr+lX4XgpD6A7AoiPycbtgy0WJ7owS4f6XoEig/tNY2IiNyCKV7Dyx196R8Zg72HBn7JjR0kPDbwsbM7b47H+33YTMvurYXlT2C8KVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590509; c=relaxed/simple;
	bh=v7+pBvYFyWxkOTI/nYuE/+WG4XpWl6EJxwnWugm1kRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9poPiocXbBuSwe3NQ8wXP1ALv1SBQKabwr/Qk5rbfk7VCwgDxCIR0kj+kGCxdgdXeDiBX75wJSv7vGfDcSbQfDfcTpSWBlnQA6nGJ+6leARaEYyNDa6dwaVUSovPJCOAVZV4N7Cr4FiiTpF2mvDBHQSygSdjVfiWqfTNyp3YFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z571NgxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z571NgxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89874C4CEF1;
	Mon, 27 Oct 2025 18:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590508;
	bh=v7+pBvYFyWxkOTI/nYuE/+WG4XpWl6EJxwnWugm1kRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z571NgxKV5H7p/fwbnTWZLxPF1sJtmHcm8LXGju9NBO+f4TtbSX08SjOP79v7Bud6
	 8M/UQedQmOKX5SR0JZ7ByC3SAHE1QpI98WPl7SW/Pm6j1uxkJEHpKpfCfdi6de3+XH
	 WR7V3HW+SlcdJPsnkoKEKsuGbMfPEs8U4CRvHdOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/224] usb: gadget: configfs: Correctly set use_os_string at bind
Date: Mon, 27 Oct 2025 19:33:08 +0100
Message-ID: <20251027183510.131302353@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 476a22728e8d1..d2be874af7d3c 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1327,6 +1327,8 @@ static int configfs_composite_bind(struct usb_gadget *gadget,
 		cdev->use_os_string = true;
 		cdev->b_vendor_code = gi->b_vendor_code;
 		memcpy(cdev->qw_sign, gi->qw_sign, OS_STRING_QW_SIGN_LEN);
+	} else {
+		cdev->use_os_string = false;
 	}
 
 	if (gadget_is_otg(gadget) && !otg_desc[0]) {
-- 
2.51.0



