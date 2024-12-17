Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AECC1F867E;
	Tue, 17 Dec 2024 17:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455970; cv=none; b=PT56zAZrBxtrqqbzU3VuQR/Xdt38FD3OxegVPjkQlnQzWgTg7bAqCgSvQZng/7Qs4pcmsFLQQhsuGGcwJI5iEEJosPPlijgtX06vPHN5sUkYbYq8m4WrcoTU6/9zpCqiVUQLQMCmZwy6qMVaSmZ5IBki5FbCuplCkNFZA/J4cEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455970; c=relaxed/simple;
	bh=vQaR7CX3jcChKkithcyMaCl6zR3cQGk5MZFoplh/ilo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eryW9f7uvW2whjAVLsqEVDrx36y1bhxxJfuRwLU5oYNK9BYxTmZjsVDIOhqX2cPWM0EqSPixRbx39mC5Qr2F8vfp9obdOVq0yJOoShqnS/P2D+riAnogqmZTIhaTq+er9MboMRXi0Vk+2yajFydFsRKERHQRBHyJ9+N+hF3Knak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTTAhZYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTTAhZYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851F3C4CED3;
	Tue, 17 Dec 2024 17:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455969;
	bh=vQaR7CX3jcChKkithcyMaCl6zR3cQGk5MZFoplh/ilo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTTAhZYCNmit2Eay8TvASSPn6VYSdyB7cZXmsNKpdN2IPJ39cruicX+TtYOhmH50D
	 65MYwrSKMG7bglyMuETXzkAKFJTBj6p/t06x+0A4sLm7zYn9vA22U0y4QBdrauHF+k
	 BGoo+mxxKDZHf+ZOMTz0yfGBb67R3c69kfCa7g1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 017/109] usb: ehci-hcd: fix call balance of clocks handling routines
Date: Tue, 17 Dec 2024 18:07:01 +0100
Message-ID: <20241217170534.078381234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitalii Mordan <mordan@ispras.ru>

commit 97264eaaba0122a5b7e8ddd7bf4ff3ac57c2b170 upstream.

If the clocks priv->iclk and priv->fclk were not enabled in ehci_hcd_sh_probe,
they should not be disabled in any path.

Conversely, if they was enabled in ehci_hcd_sh_probe, they must be disabled
in all error paths to ensure proper cleanup.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Fixes: 63c845522263 ("usb: ehci-hcd: Add support for SuperH EHCI.")
Cc: stable@vger.kernel.org # ff30bd6a6618: sh: clk: Fix clk_enable() to return 0 on NULL clk
Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20241121114700.2100520-1-mordan@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-sh.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-sh.c
+++ b/drivers/usb/host/ehci-sh.c
@@ -119,8 +119,12 @@ static int ehci_hcd_sh_probe(struct plat
 	if (IS_ERR(priv->iclk))
 		priv->iclk = NULL;
 
-	clk_enable(priv->fclk);
-	clk_enable(priv->iclk);
+	ret = clk_enable(priv->fclk);
+	if (ret)
+		goto fail_request_resource;
+	ret = clk_enable(priv->iclk);
+	if (ret)
+		goto fail_iclk;
 
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret != 0) {
@@ -136,6 +140,7 @@ static int ehci_hcd_sh_probe(struct plat
 
 fail_add_hcd:
 	clk_disable(priv->iclk);
+fail_iclk:
 	clk_disable(priv->fclk);
 
 fail_request_resource:


