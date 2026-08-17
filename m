Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F8F1EFF93;
	Mon, 17 Aug 2026 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979465; cv=none; b=XbpLDBfELigXUl6YYrSyaXiS49WxMoe4cD4OMWuvTliln+UuNSF+2N1lnh46OEEI6Da0uCE7mPKckQtoXjjBYeBbZphaFey41rGw79HG83LHtzkha+1F2Dd4OTt+qU8vwm5n+ppjxUGg08dKaYPDKfGHN1BhUlpPcJwPLbXXLos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979465; c=relaxed/simple;
	bh=IUQ/fbSzEvXTD6eSqkJ6gZ4pj4c85jeSjiJslqWrmB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU3kiA2Vj6AmgxV6yeTCGogtkBfLF+pqipbPgtEPpJ++vIvbAbTgVsVm6CVx6a8gOcVtu5ug1Nfq1rAVurs35cd3qE7e5A8/biqFskEwaa0kmARe3cJaBDJWJ4YTddptUxSmUKPQ/6ECHa4gOAFxQTRNO8TNd58431dwUqumPlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlg2dTxc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlg2dTxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5001A1F000E9;
	Mon, 17 Aug 2026 15:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979463;
	bh=vlVAO2DT5KrJxjhhj4Qy/pfIhy8kfBqlfmYbN8GwXLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlg2dTxc6GLJF7jhCmeRZfN+6JmXbMhzQSckKqqA7XLZVv5e7pq1enu8h61radYfi
	 fpUHd7qy66AUaabbnTh2S3kCxbtnGnpKfOhoul3QrSa04sBdkjaa1qRq9mlJL4r5Yx
	 AkexrszWdnd346hbWFa9C1o8eGbRxJ2JQ29s5jBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 196/609] media: marvell-cam: fix missing pci_disable_device() on remove
Date: Mon, 17 Aug 2026 15:28:12 +0200
Message-ID: <20260817132550.656462445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 033ff0420e4c9c240ae5523fff39770298efa964 upstream.

During manual code audit, we found that cafe_pci_probe() enables the
PCI device with pci_enable_device(), and its probe error path properly
calls pci_disable_device() on failure.

However, cafe_pci_remove() tears down the controller and frees the
driver data without disabling the PCI device, leaving the remove path
inconsistent with probe cleanup.

Add the missing pci_disable_device() call to cafe_pci_remove().

Fixes: abfa3df36c01 ("[media] marvell-cam: Separate out the Marvell camera core")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell/cafe-driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/marvell/cafe-driver.c
+++ b/drivers/media/platform/marvell/cafe-driver.c
@@ -601,6 +601,7 @@ static void cafe_pci_remove(struct pci_d
 		return;
 	}
 	cafe_shutdown(cam);
+	pci_disable_device(pdev);
 	kfree(cam);
 }
 


