Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8C8398F81;
	Wed,  3 Dec 2025 16:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781120; cv=none; b=T9DchCdJsDWNLDjPzzJD2+R+UFRalEnewG2tGHjRAmfrptDM5TzoS9RlK9088vg/0AdDGXSEaQr1k3q+7XhXS2iIR0md5QBpGeUTxCUhVB+l9Qv845TlkaGiLJ3RB+E8GOdpMQg9B9tpLhS4kYY5nbzqfZui3XHT954EJB/xX+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781120; c=relaxed/simple;
	bh=GJAV0RJ6Gtgm3xkj1wzYMNmupha/smNjqkxd8eOZvw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doD0yqgZQ1Z28ScXq8zXROsNdh5J335lM5pElDNKBWkX6K1gMna5JZa/tLwVUSYCtBFmFBKsGZd+ZEwksxVb2xFhBDa6ZL2vYb1VamOfqKmvHc45ek5qXaxd0fySLRgmn/ovrtXwBlwNbT3+SwCwpyk6rnzaqicctPU4Qd23kI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wI3hvVGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wI3hvVGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A48C4CEF5;
	Wed,  3 Dec 2025 16:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781119;
	bh=GJAV0RJ6Gtgm3xkj1wzYMNmupha/smNjqkxd8eOZvw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wI3hvVGBShlDtULwJXoFNWKDKg4oPYoFjGXYp6GOlpq7go0nAjSegFrsFUdl6BYA1
	 by3ll2Cm1I3d5sa7LS/gwa0fQmVRQipJd+fz5XuI5Rmu/9IwDxIBkVnboHoAk2cPWj
	 YchqLXOu569JpQe9D73/lbuJ/wpYYErO3dRa5Gtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/93] usb: gadget: renesas_usbf: Handle devm_pm_runtime_enable() errors
Date: Wed,  3 Dec 2025 16:29:15 +0100
Message-ID: <20251203152337.333699007@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 74851fbb6d647304f8a7dc491434d3a335ef4b8d ]

devm_pm_runtime_enable() can fail due to memory allocation.
The current code ignores its return value, potentially causing
pm_runtime_resume_and_get() to operate on uninitialized runtime
PM state.

Check the return value of devm_pm_runtime_enable() and return on failure.

Fixes: 3e6e14ffdea4 ("usb: gadget: udc: add Renesas RZ/N1 USBF controller support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251124022215.1619-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/renesas_usbf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/renesas_usbf.c b/drivers/usb/gadget/udc/renesas_usbf.c
index 657f265ac7cc5..8463f681ae673 100644
--- a/drivers/usb/gadget/udc/renesas_usbf.c
+++ b/drivers/usb/gadget/udc/renesas_usbf.c
@@ -3262,7 +3262,9 @@ static int usbf_probe(struct platform_device *pdev)
 	if (IS_ERR(udc->regs))
 		return PTR_ERR(udc->regs);
 
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
-- 
2.51.0



