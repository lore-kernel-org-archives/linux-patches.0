Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2152BEC34;
	Tue, 26 Aug 2025 11:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208181; cv=none; b=CuxynZwpQ2Lr4HG9EzmEGP6EpM3OzN6gm/BQFIsDASrtB0Ej2N/U0BQzxo1tEgNXXwdaWeYBH1VNyoKsyA322owT2MBqO65SiwOhTTSpLMOz+DT3ZJ8Yy0nVhPeOnysOmoDxJuUYt2sypmFhNBwurvUU3qWs5U2A2ol0xTGdKZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208181; c=relaxed/simple;
	bh=cbvH9394EeSeNJ8GAlyPrHHsB8M86vjvveRmIU6TidI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQ/z+QToSoy41sKDkgbNIFrfvFe3TxczUEo7kv9sWaYSV+nHSVwLE+Ya8Z9tbxfg3d9R8Bu56T0GOWN/T0kPFFQ+dErjrKN1irnkQ77Kz5aoZ5Q/G+nGuv7S8RXrrREdeQCnYbst+Q/WRCmmcFnpKsOm/4T6aXWcZdUJ0Ylj85U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W3ogkN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W3ogkN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22994C4CEF1;
	Tue, 26 Aug 2025 11:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208181;
	bh=cbvH9394EeSeNJ8GAlyPrHHsB8M86vjvveRmIU6TidI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W3ogkN8GPCxtBKBSAxr1fm8m5JH77OvM+dT3zXSreipE2HdamizPrvZBSVCfYIDg
	 OE84ahdJJVzYiLzmv6WOdtqq8lw4dfEBqzdjWc67cAzwftyD3JJcoH3JnB7rHiSDXp
	 4MzqrP/JFuZdaPizwreq7UYMdVSUvGIyRzMxbAA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <jun.li@nxp.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 013/322] usb: dwc3: imx8mp: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:07:08 +0200
Message-ID: <20250826110915.563942257@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 086a0e516f7b3844e6328a5c69e2708b66b0ce18 upstream.

Make sure to drop the reference to the dwc3 device taken by
of_find_device_by_node() on probe errors and on driver unbind.

Fixes: 6dd2565989b4 ("usb: dwc3: add imx8mp dwc3 glue layer driver")
Cc: stable@vger.kernel.org	# 5.12
Cc: Li Jun <jun.li@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724091910.21092-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-imx8mp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-imx8mp.c
+++ b/drivers/usb/dwc3/dwc3-imx8mp.c
@@ -244,7 +244,7 @@ static int dwc3_imx8mp_probe(struct plat
 					IRQF_ONESHOT, dev_name(dev), dwc3_imx);
 	if (err) {
 		dev_err(dev, "failed to request IRQ #%d --> %d\n", irq, err);
-		goto depopulate;
+		goto put_dwc3;
 	}
 
 	device_set_wakeup_capable(dev, true);
@@ -252,6 +252,8 @@ static int dwc3_imx8mp_probe(struct plat
 
 	return 0;
 
+put_dwc3:
+	put_device(&dwc3_imx->dwc3->dev);
 depopulate:
 	of_platform_depopulate(dev);
 remove_swnode:
@@ -265,8 +267,11 @@ disable_rpm:
 
 static void dwc3_imx8mp_remove(struct platform_device *pdev)
 {
+	struct dwc3_imx8mp *dwc3_imx = platform_get_drvdata(pdev);
 	struct device *dev = &pdev->dev;
 
+	put_device(&dwc3_imx->dwc3->dev);
+
 	pm_runtime_get_sync(dev);
 	of_platform_depopulate(dev);
 	device_remove_software_node(dev);


