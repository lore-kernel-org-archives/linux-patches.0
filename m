Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9F81C0DE7;
	Mon,  1 Apr 2024 16:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989040; cv=none; b=eCFWaHNEoE0ds46OvRw7ZA1v8H9RQ8O+O5BL9Z8pQ9dGya4BgZqV7pDh9COraDb0117wMlA0mKVY8pvuw8Gbuny7CRbIpYG+b0E2e0rW7cpkd8zc7ZcRMH53NEtwo1+Re29zWAWrbNSWjdgxJGAjQrl7sOCEwGkpdtGDRgmBbJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989040; c=relaxed/simple;
	bh=TU4SvnrM6qQUJbWweRYDdX9y7R5GbISQ+DYLEPYOzfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZ5pAS0sqFbWU0HCbDE26yQ8mqEruz39lgPWFPW/Sd5NvRpmx1YTy/Xy7g9SsMmD0YxsmRRaFeZ8g+vmgO337VwPZj+9danvsbHIqOU5VQYV6rOf9F5vIgBi/bYUtAnsy/vrn2CBEd+ugr1q2FfFPOHXldF/k+MHBQzaMq8eqds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u07FIcc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u07FIcc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF66C433C7;
	Mon,  1 Apr 2024 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989040;
	bh=TU4SvnrM6qQUJbWweRYDdX9y7R5GbISQ+DYLEPYOzfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u07FIcc6B8MInpgOUv/XVNHfPLIb/ZKOZ2NGYK60rarmEkUFlHpNOaNuCkYg5c52n
	 /zEOdXoVf2kqYQySXs6I2fY4OxcrwQJRS3jfuCHPaSQiB/lbhfuWiacKXp3bOZJBva
	 MV1ikfYlPrGzKXylY5OY6IVs1SfcEgMeUm4+NrI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claus Hansen Ries <chr@terma.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 364/432] net: ll_temac: platform_get_resource replaced by wrong function
Date: Mon,  1 Apr 2024 17:45:51 +0200
Message-ID: <20240401152604.128095891@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claus Hansen Ries <chr@terma.com>

commit 3a38a829c8bc27d78552c28e582eb1d885d07d11 upstream.

The function platform_get_resource was replaced with
devm_platform_ioremap_resource_byname and is called using 0 as name.

This eventually ends up in platform_get_resource_byname in the call
stack, where it causes a null pointer in strcmp.

	if (type == resource_type(r) && !strcmp(r->name, name))

It should have been replaced with devm_platform_ioremap_resource.

Fixes: bd69058f50d5 ("net: ll_temac: Use devm_platform_ioremap_resource_byname()")
Signed-off-by: Claus Hansen Ries <chr@terma.com>
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/cca18f9c630a41c18487729770b492bb@terma.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1443,7 +1443,7 @@ static int temac_probe(struct platform_d
 	}
 
 	/* map device registers */
-	lp->regs = devm_platform_ioremap_resource_byname(pdev, 0);
+	lp->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map TEMAC registers\n");
 		return -ENOMEM;


