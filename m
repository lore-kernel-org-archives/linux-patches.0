Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111DA3C0B;
	Tue, 11 Mar 2025 15:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707555; cv=none; b=tmTlE+XwRW8CPME8/YBgOuCF4GsrnkK3QaaR8y5S4GgLPiesL/bpnasW/ukWRdRBLQzJ6PKXmu+ktYSW1TYiPZOkL1xNf8mLwsbxY6nfXihkYkRSl9DBECa29FKb4k8YpFF287WHdOEbnyet+z94zQdarEDKCB3aeLDQ8XPAYZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707555; c=relaxed/simple;
	bh=gw53YeQrHmZQjf3qx1MWY7N/3VKe90GfuZ3/FYUmEPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUaefxg8G1ZcuzSVGdb5WCfw2b0mvyH0hgEi0y7L8lWSC2+I0WXj2ncHp3K+8DW8U3itLKz1exo+dtEQFOHI18id2Ph8wegwRBRP3O489qvNAIsjTcTXa4lqYojpX8gZHIct/Af27rh7V6lrxbAeseVQVqRfOK7uROHB3UaoyTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0r203Qhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0r203Qhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EE4C4CEE9;
	Tue, 11 Mar 2025 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707554;
	bh=gw53YeQrHmZQjf3qx1MWY7N/3VKe90GfuZ3/FYUmEPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0r203Qhkv3mkUIkpIhrs4dq5As6xWa95pLcmffyONAXMp6UAxNr/aH8S9UcnVt9Ph
	 JWQsM1U3qJKangiT7x7voecTRFUE0xZGex+3ZdkaVFbCB7f6T1441/xoGHxGWqvypO
	 3GDUWjUA816MHls8km3k4/xDnxP1Ohha4N4GJvvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.10 429/462] usb: renesas_usbhs: Flush the notify_hotplug_work
Date: Tue, 11 Mar 2025 16:01:35 +0100
Message-ID: <20250311145815.283339706@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 552ca6b87e3778f3dd5b87842f95138162e16c82 upstream.

When performing continuous unbind/bind operations on the USB drivers
available on the Renesas RZ/G2L SoC, a kernel crash with the message
"Unable to handle kernel NULL pointer dereference at virtual address"
may occur. This issue points to the usbhsc_notify_hotplug() function.

Flush the delayed work to avoid its execution when driver resources are
unavailable.

Fixes: bc57381e6347 ("usb: renesas_usbhs: use delayed_work instead of work_struct")
Cc: stable <stable@kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250225110248.870417-4-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -774,6 +774,8 @@ static int usbhs_remove(struct platform_
 
 	dev_dbg(&pdev->dev, "usb remove\n");
 
+	flush_delayed_work(&priv->notify_hotplug_work);
+
 	/* power off */
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);


