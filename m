Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E77B15FA7B;
	Wed,  5 Feb 2025 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768561; cv=none; b=BxoTwVU4jiMg33w61sJrDWtqxAP5aMBQZqQl+8ZVjNnn8iqW8kdB1+B9AUXHYYq3p8fCv7mNqAEAFdP5L1Bb5K+2ehy3zcRT78uBKTj2W2VEHQKPn61he/u6VWr74qXt8MLW5jpJeVcoKZ/eEAKvV9BJd90RxvlIxdcI7voLtj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768561; c=relaxed/simple;
	bh=fFkTZHKNjaoCez33iLoUEWpTAYtLex49y3TxXcekhWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZPyYkMfRWAF8RG6rGGFEbyAc71HMG1hNufDCCFvERgUQlpKqZc/wt7qGPYbCpWxOooP9laFMJDDlouJ0BIgq38kSa/ymX1lhEYbfMpSOIaGc6bCGeBp2rlN8MsKeMK0iVXPYZYrvfjVDSOll/rcBsheYUr5YRi+R56BrO+fy/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4rinDue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4rinDue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82BFC4CED1;
	Wed,  5 Feb 2025 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768561;
	bh=fFkTZHKNjaoCez33iLoUEWpTAYtLex49y3TxXcekhWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4rinDueRidONitSEPoLG64RLxfu7SGhNFj5ICULKRAM2fzFZH/hne8zeNolPAT8w
	 +XwZpKrFRnOy1I+TAZg2et0cjXnyptXz4q+eoU+5LNa4HJFhZfB/qlhetSX/X1pKQS
	 4eigFSK/wl278ZAruuk7v7UxegI7cKzS9JHuYMhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.13 592/623] usb: gadget: f_tcm: Fix Get/SetInterface return value
Date: Wed,  5 Feb 2025 14:45:34 +0100
Message-ID: <20250205134518.873917063@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2051,9 +2051,14 @@ static void tcm_delayed_set_alt(struct w
 
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
@@ -2063,6 +2068,9 @@ static int tcm_set_alt(struct usb_functi
 {
 	struct f_uas *fu = to_f_uas(f);
 
+	if (fu->iface != intf)
+		return -EOPNOTSUPP;
+
 	if ((alt == USB_G_ALT_INT_BBB) || (alt == USB_G_ALT_INT_UAS)) {
 		struct guas_setup_wq *work;
 


