Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BD730C618;
	Thu, 30 Jul 2026 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423720; cv=none; b=Qoyq13WTJ7j4GnkP8OEcrRmCi0OVmdHiy3H2T1sgO3Dvtlwe0wpBbgCP/BGiiGASK4Fw0lEiOkizkd69O8c0UlFYGek7Miyw/ucIKTkLPp8JfvV22OxSZlITVqZz0WRv/0l1U8srIwI8AN6PJ5jjeHSDKr/qSWrhmOHBXyBM4dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423720; c=relaxed/simple;
	bh=3GCKlFTiiac1WrMy44nAa/u/4sb1dz0xL60iRVAZeF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjInebATmgcz6o+PiQTPkggOh9647996y37iDs1uCjnzwQvlaRYMHOA1NiljBaW8ggSgCLgWeZBFD0lDssAru/vEytFvRrqpAe9KQKyYgz4sfZt+focNe8pft2Mb2Xnug5oetRDlmrrHqzxrGr8JMYd/UtbAQXAW/qD8kOxvs78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYGXUpk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYGXUpk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6069E1F000E9;
	Thu, 30 Jul 2026 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423718;
	bh=ciAOwVVi11JaSGBrbLhAp9yOCpq2rkGtwZjOVYIm2vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYGXUpk9hySTg6hOF4f9DV4zLfZa1HmNq4NrMq/V73yp48uMgV8EbB+PQ9EuiXtP5
	 OLO9kzvrIvf3CpPEjiPrUkcUfqnloJSA+sFXh1xMuutEJjnQjoHiPRdHDrMjGx4ZLS
	 hNa8qAQ4CE4kqTZT00LNqTnegOlBPQ3VHYTgGRbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 6.18 142/675] usb: musb: omap2430: Do not put borrowed of_node in probe
Date: Thu, 30 Jul 2026 16:07:52 +0200
Message-ID: <20260730141448.155517226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


