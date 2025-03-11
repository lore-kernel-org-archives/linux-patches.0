Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FB5249F9;
	Tue, 11 Mar 2025 15:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706313; cv=none; b=nQnRG6nr/IKURZz6yqmrjbi939KpVaxqY5fcfDizYC/6gLSOKJ/0ZEPG5Od8haEdxiWmrqmdK4DF8WMP1jStH9Gu5bNOU1iLr/DVBMynlRYBNDIVKQ8AszEsh9QbprPB0xeLX2IizD2I1vjmG1g0JcExpRURlj6O6rEnrWXRFlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706313; c=relaxed/simple;
	bh=QuSPnLALlhmG+WFtHtFeuzGCf2GJyjSJoMEvBoripLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyX1Fo0Crsuc4bPZkDafvsKyaUq9wqopCbkajhw+ognmlay+WdBEwPZ6e2M+8+WQC4zpBVVbhpPFdjMqG8WwXgBF5xrmIjFyY0uQfPr2jw4L227umcZGBMciutCJI490FftSsu4qtRdy5wtKxZScOHltA2oOn2d97zW9Op3AJFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiplxJL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiplxJL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6C9C4CEE9;
	Tue, 11 Mar 2025 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706312;
	bh=QuSPnLALlhmG+WFtHtFeuzGCf2GJyjSJoMEvBoripLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiplxJL7clTZQlIKZPQSpI6DrQ9uamGUF5ApCtQ1AyxSg1i0PutfrK4lkViXird4N
	 BXI3D69NYOLarTarA+o/aBLtLw7kcqyfX66ZpcVMbFJgJ0Y5IaskFblUg+siIVZMuc
	 PIkA4B9BBlljDTboXc3KgO+2PrS95aH7cyUxw8pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.4 315/328] usb: renesas_usbhs: Flush the notify_hotplug_work
Date: Tue, 11 Mar 2025 16:01:25 +0100
Message-ID: <20250311145727.423624829@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -779,6 +779,8 @@ static int usbhs_remove(struct platform_
 
 	dev_dbg(&pdev->dev, "usb remove\n");
 
+	flush_delayed_work(&priv->notify_hotplug_work);
+
 	/* power off */
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);


