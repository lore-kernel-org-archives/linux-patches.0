Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7387D3FE;
	Mon,  8 Apr 2024 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584847; cv=none; b=IB3R6TZ3BoYZwv0xxZDt+1QSgLW7+yoMlWerk243j4Ps7CyY0VzTBR8HEJUZQ0nkLVqCcOHNh8TEwAV1cmabFhGh/enIPT4J5+vrfiel+7D6+MAB0GbzoNcv+9xm7fsSiJM71LNfqs2TYqYowBw+RwigOvFeDWaYB/3P6fwFR9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584847; c=relaxed/simple;
	bh=bpC27zbjXz53r2neStML1+D5+FsKmhZEhRj1RqSvglA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QT2Q0RWPjQMl89+AzCfM/fBDzVIyIYw3ubykSvVOrIH4qETheD9aoW+3FwwU7lpDlBkjJ+6y8guTIxa/NMq0oEevuzKpOdwO7R7zDArHQWj4ZbJPUZrqwTegqYJ5eLjRF+Sr8mCj6CnhKze849y+d4eMWUuDDyaoqLK72otfUC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mfr7qAUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mfr7qAUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31094C433C7;
	Mon,  8 Apr 2024 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584847;
	bh=bpC27zbjXz53r2neStML1+D5+FsKmhZEhRj1RqSvglA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mfr7qAUbyH25V9Iri8chv81DKnWpjmbCiuXnQmB4T+P54iJhTCLWu0a7OWpZPq6YB
	 lilTeXGda+AcdL6ZOTuG+Ehyg+GabUKX2+8s+8pgYCyzLXAZgWqei2lCPfuHNEYxPi
	 41uZfdcCzZNKKu994gvv0rAsWf612j4VLkmYIYx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claus Hansen Ries <chr@terma.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 576/690] net: ll_temac: platform_get_resource replaced by wrong function
Date: Mon,  8 Apr 2024 14:57:22 +0200
Message-ID: <20240408125420.471799851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1433,7 +1433,7 @@ static int temac_probe(struct platform_d
 	}
 
 	/* map device registers */
-	lp->regs = devm_platform_ioremap_resource_byname(pdev, 0);
+	lp->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map TEMAC registers\n");
 		return -ENOMEM;


