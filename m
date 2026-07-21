Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD60746A5F7;
	Tue, 21 Jul 2026 19:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663595; cv=none; b=OyKlWKDgd29PHJnAQS+iGgQgFwY6wInnZ8j1Q3sKc11GonMmZ3z7M8+IazuaqczzcOREvpbZBTFZtEUvY71jgErl4A+QQkDndl7Xt4MW3s7scgrcx95Ts5U8OX+GR5J7gFH5Q7d53KJI333/j57/TZObnc3ZypXk9bcOmsNKGz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663595; c=relaxed/simple;
	bh=Ggj+v0KMRA2TjV8NuuzQ1UPHOJKM8f/9g9WeOsAlrs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFCW5IU33/S6rK9p98Uj1y+ryLJsgV4NfdwuFRIQ37UyhEL+RfxSnmCn7O83WeGUfiVCszuMLpzOMHRLcEwXP0JaEpcWrNCrGGzK4XJtZgdDZZcknS1PEPrRdc3bGID29+IXfMXM2r77ExJKgGJ+vM4hPLHs9ShTvzHzTnvpEnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wqc49+5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wqc49+5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5ED1F000E9;
	Tue, 21 Jul 2026 19:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663594;
	bh=nlw3dt74C0m0jc3r/YKNW2LAXUoZ7sWpZuexIsPrJaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wqc49+5q1NfLueUnuTTTTDKUjy7jJ0t7080UjhGAPSOPRGEdNEEKDbhoTKRJmfJt9
	 HxkFfimw6UZJDRcmZEwfDz03pN8udlajBU+e+UMKfOiGZHrs5KeKEOO6y9FDn3qqNn
	 LAOu/Ml1aGO89s6Myxnif6r1ZgZliumGYEI6O5Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 0875/1276] mfd: sm501: Fix reference leak on failed device registration
Date: Tue, 21 Jul 2026 17:21:58 +0200
Message-ID: <20260721152505.634053005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

commit 8c2f0b42fc252e1bf1c7746447091a468e784ca1 upstream.

When platform_device_register() fails in sm501_register_device(), the
embedded struct device in pdev has already been initialized by
device_initialize(), but the failure path only reports the error and
returns without dropping the device reference for the current platform
device:

  sm501_register_device()
    -> platform_device_register(pdev)
       -> device_initialize(&pdev->dev)
       -> setup_pdev_dma_masks(pdev)
       -> platform_device_add(pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: b6d6454fdb66f ("[PATCH] mfd: SM501 core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260415162627.3558789-1-lgs201920130244@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/sm501.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -747,9 +747,11 @@ static int sm501_register_device(struct
 	if (ret >= 0) {
 		dev_dbg(sm->dev, "registered %s\n", pdev->name);
 		list_add_tail(&smdev->list, &sm->devices);
-	} else
+	} else {
 		dev_err(sm->dev, "error registering %s (%d)\n",
 			pdev->name, ret);
+		platform_device_put(pdev);
+	}
 
 	return ret;
 }


