Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E25230BED;
	Mon, 10 Mar 2025 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626923; cv=none; b=vCqphSwDjIbvsbUWgZKJKofTjunXW3fTePoe3ACxyLzJ4+zTpGtIKAACvJcFEKnWfKPVP+Fh/TqBqvs3PggvkMpluWq2k4o8vsWLuNl0jMwmprpnb1kgwK0qyvfG1TuwwxX/0L/KbHXYyw4TjQWbdIhXoxBUWtiAsjzA3jNns00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626923; c=relaxed/simple;
	bh=+22gzMyfYAcCtJHr68qKBT+rovAePDB5OByKq+zmzgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrmfLXjVX5ne+KNFalYf7uDfN54ChTFUpfaMXIZHja8L0mO5/rqFN9ZBynAi5czGmeJ6lh7p5iuP5Qt50lHTAp87cOJc/T8WRWVaYzM5RwKiLIz3xbohglPjsAvKIN95QvD9UAVGFRrTkjehUdsBbGexGEm2d8emW/lLWhQfzc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmE07qEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmE07qEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E582BC4CEE5;
	Mon, 10 Mar 2025 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626923;
	bh=+22gzMyfYAcCtJHr68qKBT+rovAePDB5OByKq+zmzgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmE07qEQSuW79fEtO0Xn/jUc1xHIFM2dTfYGjBC46rDrZQ/QaqhbdAOupX9nHxLf4
	 dmzWpjm/tChwuzuhBCI1vvJlHqsv3lJmeSQVA5LpGSY1VwKsUxDNAEaAB6wKj4bNBV
	 1gZUn6381Sli7I5ek3uywCf+3QbKNlYlUvFLw3xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.13 159/207] usb: renesas_usbhs: Flush the notify_hotplug_work
Date: Mon, 10 Mar 2025 18:05:52 +0100
Message-ID: <20250310170454.113614397@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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
@@ -781,6 +781,8 @@ static void usbhs_remove(struct platform
 
 	dev_dbg(&pdev->dev, "usb remove\n");
 
+	flush_delayed_work(&priv->notify_hotplug_work);
+
 	/* power off */
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);


