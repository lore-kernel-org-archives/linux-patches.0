Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4411B982E;
	Wed, 19 Feb 2025 09:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956746; cv=none; b=ByAuTTT7e/eUUHm1TK3SVTYPGGi17ymF8GD4YW8X7jbcMHWvh/DeOIT0uvRfI3gEazxUs/Lj778UQpxubbFwvRRPuZVyye4d+v5+79W/qyK1hsQxEi5nhTlQyIgPFeiVvM/TajLq8i4oXRoZcUgdxe9OKbvwFDZhxIBmOrfZNDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956746; c=relaxed/simple;
	bh=7b1DgZF07VLIwdFypOuGIx4xhcmcA0PgwineDp1U3CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A40rGnzNSlKnGAicV3aK9TY7ZHvCMw6yawK7Yizs4VSK0KM3UiWZY8DzNjJkJhFkXC/HQcNqABcrafkg4QkAq3fra+nh2zc+djTG3RshZm2eK0iH3Ml9MepdLsehXTLvw9KFUOp7PcDWCMV00Tt9oDeEO2WpZFiCyOuUhz/9aQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOyFD8m2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOyFD8m2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74608C4CED1;
	Wed, 19 Feb 2025 09:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956745;
	bh=7b1DgZF07VLIwdFypOuGIx4xhcmcA0PgwineDp1U3CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOyFD8m2Znh/TgzkbMoonQaeZRKjjolMK4AMvCyyXygNNax8EpQi7Vim0cyWt8zOr
	 1+eZCOZ1tLtHOvnlmhBxwpD+iemkKLkUFDK2St5f9wz4h9xduWcpEuO+J25E5oxLBF
	 Rbhyfx/BdkgL4QyLmAaMnKHHFxxoc0yyvx9qyA0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 254/578] usb: gadget: f_tcm: Fix Get/SetInterface return value
Date: Wed, 19 Feb 2025 09:24:18 +0100
Message-ID: <20250219082703.020232999@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 3b997089903b909684114aca6f79d683e5c64a0e upstream.

Check to make sure that the GetInterface and SetInterface are for valid
interface. Return proper alternate setting number on GetInterface.

Fixes: 0b8b1a1fede0 ("usb: gadget: f_tcm: Provide support to get alternate setting in tcm function")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/ffd91b4640945ea4d3b4f4091cf1abbdbd9cf4fc.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -2079,9 +2079,14 @@ static void tcm_delayed_set_alt(struct w
 
 static int tcm_get_alt(struct usb_function *f, unsigned intf)
 {
-	if (intf == bot_intf_desc.bInterfaceNumber)
+	struct f_uas *fu = to_f_uas(f);
+
+	if (fu->iface != intf)
+		return -EOPNOTSUPP;
+
+	if (fu->flags & USBG_IS_BOT)
 		return USB_G_ALT_INT_BBB;
-	if (intf == uasp_intf_desc.bInterfaceNumber)
+	else if (fu->flags & USBG_IS_UAS)
 		return USB_G_ALT_INT_UAS;
 
 	return -EOPNOTSUPP;
@@ -2091,6 +2096,9 @@ static int tcm_set_alt(struct usb_functi
 {
 	struct f_uas *fu = to_f_uas(f);
 
+	if (fu->iface != intf)
+		return -EOPNOTSUPP;
+
 	if ((alt == USB_G_ALT_INT_BBB) || (alt == USB_G_ALT_INT_UAS)) {
 		struct guas_setup_wq *work;
 


