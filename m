Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7333B05B8;
	Thu, 30 Jul 2026 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426914; cv=none; b=fDkZcNYDkdfGsjv65SR7lEkXGos1mRlxmuEJic/eCiNOvfva6/bJ6y7fc3RgQJfzM+sTPI2Zduo8e3+1LEclRdFfXtLmbJYxRL7FLFoG0rmsP3foHWjpyk212fD3rM9VDJjohbeeamIEwRpd5C503IWDuN5W6Ue0Z2qnkjxfG5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426914; c=relaxed/simple;
	bh=tHKG7Pf3ex4AFcOG2qZeSbe8ICFt57b0e/7VDXfT7HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eF0EC5yCoyBvH5NlywnUJvzx16/m8wvGLQYZICgZDLCJevfGG6sOZsfX/lpDlxUeQh7Nd9PovpoLXTifzEnWTg10d/uwuMyMCCWXOMTHSHa6TRZeISEkr8uVzcZNmZQxw6B5WYceQjxEw/Lqp/uwyGXCGxZm5iYeJ1QKElcd3vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekjYgr5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekjYgr5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A3B1F000E9;
	Thu, 30 Jul 2026 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426913;
	bh=IVAxwFBHbVkKXO/AvAWKf9k1VYKczRGZNS0HV9IB29g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekjYgr5KPpdDd1j+fWsS4mhhLuqILyj0tfdHiLBS0UCCsfTeFMrtgnMOjsYTRtZQZ
	 At0S8DlI/w8zhJHtwQbF5lDoANgZfHvrUvpiD5HtfLeCYlbKiWycawd7LiN+DuRuXW
	 g+Od+9lERLu1cw595kkPgBtfbZDpqUE3KJE2kZ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 586/602] usb: musb: omap2430: Do not put borrowed of_node in probe
Date: Thu, 30 Jul 2026 16:16:18 +0200
Message-ID: <20260730141448.369039824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c947360ae63eee1c9eacc030dd6f5a53f717addf upstream.

omap2430_probe() stores pdev->dev.of_node in a local np variable. This is
a borrowed pointer and the probe function does not take a reference to
it.

The success and error paths nevertheless call of_node_put(np). This drops
a reference that is owned by the platform device, and can leave
pdev->dev.of_node with an unbalanced reference count.

Do not put the borrowed platform device node from omap2430_probe().
References taken for the child MUSB device are handled by the device core,
and the ctrl-module phandle reference is still released separately.

Fixes: ffbe2feac59b ("usb: musb: omap2430: Fix probe regression for missing resources")
Cc: stable <stable@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260713114711.955253-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -455,7 +455,6 @@ static int omap2430_probe(struct platfor
 		dev_err(&pdev->dev, "failed to register musb device\n");
 		goto err_disable_rpm;
 	}
-	of_node_put(np);
 
 	return 0;
 
@@ -465,7 +464,6 @@ err_put_control_otghs:
 	if (!IS_ERR(glue->control_otghs))
 		put_device(glue->control_otghs);
 err_put_musb:
-	of_node_put(np);
 	platform_device_put(musb);
 
 	return ret;


