Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDD61BE87F;
	Tue,  2 Jul 2024 17:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940550; cv=none; b=RoJKvWNVh743m7iXEEwc2u1EKQ0uUf8Vzrqw5yZ/2yAixThUwaKsfu/IyfMncgH3qyVpOWmzFwtSicKqM50bJ+8JW1Jl3Z47So9d5nUJyQIwIhkxOk9giahMA86BoJa6fouZSg1GTiNgqVw7gVx8YPQdJ57zPbUXa3qc4exvNkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940550; c=relaxed/simple;
	bh=kutwZuHB8in9QtDMolmeCKkeTllxNa9Z76v7XFaR7c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/u0Ypk2nE+GZC7LjxD5v4Xs8eY3rkxwG4FFP0ZFs5VYwkCtzQ5xsWcDtTPGc3jUBNDqn8E6+h//XK2V91iYWJ2jgyqFHxZOxrziIAqYDjS3j/b9+zxO8z9XoAujuf40TvDJYtcLwUBkZvEckBCDuOY52cyEWR0O5vwhboNGFOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYGWdj8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYGWdj8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E27C4AF0C;
	Tue,  2 Jul 2024 17:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940550;
	bh=kutwZuHB8in9QtDMolmeCKkeTllxNa9Z76v7XFaR7c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYGWdj8X7yUquqLgM+izZCjCjTYanUhalkcgheVKBs4SWWwVu7H8ptmun8SkzMaUr
	 BjInzBvYMjjGwMOice77jmkaFY41CK0CEF4CZ7MoVYeS6C4qNV6SsBTuir6qW5/AER
	 TiA0vMC6Kune34n6woK1ggd+O+lAEHj2ftd6F7sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.9 146/222] usb: musb: da8xx: fix a resource leak in probe()
Date: Tue,  2 Jul 2024 19:03:04 +0200
Message-ID: <20240702170249.558252531@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit de644a4a86be04ed8a43ef8267d0f7d021941c5e upstream.

Call usb_phy_generic_unregister() if of_platform_populate() fails.

Fixes: d6299b6efbf6 ("usb: musb: Add support of CPPI 4.1 DMA controller to DA8xx")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/69af1b1d-d3f4-492b-bcea-359ca5949f30@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/da8xx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -556,7 +556,7 @@ static int da8xx_probe(struct platform_d
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		return ret;
+		goto err_unregister_phy;
 
 	pinfo = da8xx_dev_info;
 	pinfo.parent = &pdev->dev;
@@ -571,9 +571,13 @@ static int da8xx_probe(struct platform_d
 	ret = PTR_ERR_OR_ZERO(glue->musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
-		usb_phy_generic_unregister(glue->usb_phy);
+		goto err_unregister_phy;
 	}
 
+	return 0;
+
+err_unregister_phy:
+	usb_phy_generic_unregister(glue->usb_phy);
 	return ret;
 }
 


