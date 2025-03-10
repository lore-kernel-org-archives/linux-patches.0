Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2991A22D7A6;
	Mon, 10 Mar 2025 17:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629144; cv=none; b=I9avAZGdmOwy6/mI4igImRm5hPAp2tYEZcsIhj78vGQ3bxh2Q4e4a+Zj3vAwCdoTXurE7ztXhjnQA1T4QRDEFkWuPK0F+QiCi97c3PGvMq2V2QMM0JAz/DsBiGEpOT9vydBMFyENVTfEf1pgzROlamZHC5ni/J+zahmV4dSAHMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629144; c=relaxed/simple;
	bh=iIjWB/LNOHV9IUADQ6gZI9tFfAdg++EMBHqD+8NZ0do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2N6gYTVFE6mTm1SWSMVIN6kQkpmgcI/Qx+sRHmXjQYb9VrJIzTbn4Can28LlnJ+e3iAJxM6t0mOS6aAEKcULUXQpft9yYfymQupZcDIWlx5vhESLFAyS15+9/nKc9bJlxf0d8dCueip5Fy09JJ07faDVlzK1TT/6xeZ8t1ydg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCOeg9FQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCOeg9FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443C3C4CEE5;
	Mon, 10 Mar 2025 17:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629143;
	bh=iIjWB/LNOHV9IUADQ6gZI9tFfAdg++EMBHqD+8NZ0do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCOeg9FQBDcaI5WvNzarRIdXn2U4Y2dfdxlC0rJsVy8Wo2u26h6D+AB3gczBqI3b5
	 eOYaRZvuqjUmjDbaR8SSOb8RPbLFLmkMyb7YNgLLGDKoto+TdiURkowCfJGTvfACpM
	 EwxlfPQP5aQHDFqhPdxhBkaaTy2V/hg9vXu9scHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 193/620] usb: gadget: f_tcm: Fix Get/SetInterface return value
Date: Mon, 10 Mar 2025 18:00:39 +0100
Message-ID: <20250310170553.251672234@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2098,9 +2098,14 @@ static void tcm_delayed_set_alt(struct w
 
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
@@ -2110,6 +2115,9 @@ static int tcm_set_alt(struct usb_functi
 {
 	struct f_uas *fu = to_f_uas(f);
 
+	if (fu->iface != intf)
+		return -EOPNOTSUPP;
+
 	if ((alt == USB_G_ALT_INT_BBB) || (alt == USB_G_ALT_INT_UAS)) {
 		struct guas_setup_wq *work;
 


