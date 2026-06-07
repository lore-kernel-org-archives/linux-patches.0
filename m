Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D82308F38;
	Sun,  7 Jun 2026 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829212; cv=none; b=q2yaS8Cpfs+FzP5icXzLw7bx0UGrVBgdaTSquUgXtPv6zk26iFx1Bnyb3rb52z+wHg0wa9vr4dOvs/6Wuk1y9Pwmj4Ha9sJsTkSNYcye3Zavru6eKTUYjOMt/nQBA2a+kZdy6YRjWYAX7Z+t9okkamkQW+AXbsKuFPpg5hsez0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829212; c=relaxed/simple;
	bh=6XkvGIlmfgbVCBZf5ICHrw6RXgzMWDxdP7nH0X/pV64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQXQkDeeSJzMvytAFn6IT3164mBr5FAD22jYChPZLTs9z0FfS40cH3Ljw1OkzK7+4/9RMWt3rJVwyiQli8qUaqKUvA5lyHYO8eTtagvefiL8rUs8VfytT2tFjIho+zUUgImsbyBi9japgBjqBMyaiLExC1GuvbzG54GkNAaFHz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQMM5Aak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQMM5Aak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BE01F00893;
	Sun,  7 Jun 2026 10:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829211;
	bh=hDxrcmwxqrS1vBNC/lY2F4tPN366poFrHV09BeTCACs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQMM5Aak4pobilialBiPe8IDM79VCRzTQnBCzVMdIm6/PyQtG2exxc7Kl/mrUK3bM
	 3S8Dk9Yz2H/y7NOrKZtY5RhaczGsSxrh6HYQR5u66Yab+Eyk+9iuw+5HK4X1zeATta
	 Six875azBlJkLtppa9o92XHCvdrfqF6pwa0NZi5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 7.0 254/332] usb: musb: omap2430: Fix use-after-free in omap2430_probe()
Date: Sun,  7 Jun 2026 12:00:23 +0200
Message-ID: <20260607095737.376034073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit e194ce048f5a6c549b3a23a8c568c6470f40f772 upstream.

In omap2430_probe(), of_node_put(np) is called prematurely before the
last access to np, leading to a use-after-free if the node's reference
count drops to zero. Move the of_node_put() calls after the last use of
np in both the success and error paths.

Fixes: ffbe2feac59b ("usb: musb: omap2430: Fix probe regression for missing resources")
Cc: stable <stable@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260409101104.480623-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -337,7 +337,6 @@ static int omap2430_probe(struct platfor
 	} else {
 		device_set_of_node_from_dev(&musb->dev, &pdev->dev);
 	}
-	of_node_put(np);
 
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
@@ -455,6 +454,7 @@ static int omap2430_probe(struct platfor
 		dev_err(&pdev->dev, "failed to register musb device\n");
 		goto err_disable_rpm;
 	}
+	of_node_put(np);
 
 	return 0;
 
@@ -464,6 +464,7 @@ err_put_control_otghs:
 	if (!IS_ERR(glue->control_otghs))
 		put_device(glue->control_otghs);
 err_put_musb:
+	of_node_put(np);
 	platform_device_put(musb);
 
 	return ret;


