Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE60531ED80;
	Sun,  7 Jun 2026 11:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830238; cv=none; b=U9Vc8pGjBVmyboBzygw/YXk+xAc0GbMEhLcWXgntIqZblKTUKQ8/tFlX8XdPUARuF5IXt4sZRmz6nJRecwakGQLhblc7hqnBBp91NvekmhTw4XQDCU4LzWJavDISMQafdegOjPP8dCzUcfsJxJ8qaO1A5IA6AVKMZCp1ef4/TBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830238; c=relaxed/simple;
	bh=pZgvohKSvAi9lgELWVf3I8ZbKoBqOmrQC8l36r3jW7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4STs9N03Li0klE+QsH5CyqsBDY5O0/w9EJ8oEkbh2aX9sK1dP9mx/12k0QCX6OUeD+qr985FFE8pkYIjop46LzyEye28aiHVguk4NCqpP32WxbfFZbJf7zAZatFm3I8a9ATbUGhR0V/vOpUt8U0j+wjTQlfKIL3jqM067FYfEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVGaQctl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVGaQctl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF621F00893;
	Sun,  7 Jun 2026 11:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830237;
	bh=mE1BrKILJY4O+Bqtywf5KUfdVfvPXsYlhwTNk70yTMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVGaQctldUmY7+iqLxp4wSmUmVyDCzP587E1hZDctPpzg3FegmBbUxaOoJJ9WDt2R
	 X8jE0f87wbJBclslQjDmcy/FpMg3hTucTNKNSwnJXPh3zGBdVe36S9mltwrXf4JYCV
	 4sxW7HyVLIK0iaC0wN+lbnTKUiQ8K8hjfR5Po5gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/307] usb: musb: omap2430: Fix use-after-free in omap2430_probe()
Date: Sun,  7 Jun 2026 12:01:32 +0200
Message-ID: <20260607095738.574948809@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e194ce048f5a6c549b3a23a8c568c6470f40f772 ]

In omap2430_probe(), of_node_put(np) is called prematurely before the
last access to np, leading to a use-after-free if the node's reference
count drops to zero. Move the of_node_put() calls after the last use of
np in both the success and error paths.

Fixes: ffbe2feac59b ("usb: musb: omap2430: Fix probe regression for missing resources")
Cc: stable <stable@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260409101104.480623-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -340,7 +340,6 @@ static int omap2430_probe(struct platfor
 	} else {
 		device_set_of_node_from_dev(&musb->dev, &pdev->dev);
 	}
-	of_node_put(np);
 
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
@@ -458,6 +457,7 @@ static int omap2430_probe(struct platfor
 		dev_err(&pdev->dev, "failed to register musb device\n");
 		goto err3;
 	}
+	of_node_put(np);
 
 	return 0;
 
@@ -467,6 +467,7 @@ err_put_control_otghs:
 	if (!IS_ERR(glue->control_otghs))
 		put_device(glue->control_otghs);
 err2:
+	of_node_put(np);
 	platform_device_put(musb);
 
 err0:


