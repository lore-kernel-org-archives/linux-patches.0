Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A9B1CA8F;
	Mon,  1 Apr 2024 16:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987553; cv=none; b=IyHj9bLmCREyQwBb7awL6N++SGU3ZRkIY0fkYYs0Lk8zs0hH4sVHcoX/XK+/DLbCj/o+6nRJTp9NjkNS5m7mxiTV+4SsAv0nKdmsXD3FPZoyQ/1plSDJGITylChH75TsdmqleWgjWSHiX5paIum2NySA53lf1eGTss0EIlui/N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987553; c=relaxed/simple;
	bh=OArqbsU4aFejfLNkVFE2Q42tAUL2/1IYxdPVNhEXUvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTW2YbKI1Xs7kUypYVyKuEgkab52/5c3RKN66S1DeE294/HUxvdYmYUrKwL4/XJk5DAJAO21bcU6oFiDL6CjrkFcLIwHmnmHRWu4L6OE6Cj1mdu6SXtKszfjpVbS23cy2iaC6O2EzKDqyxyiDjRBge19KPGLM3gNg67gKKhLHPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFHbL3+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFHbL3+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C73FC433C7;
	Mon,  1 Apr 2024 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987553;
	bh=OArqbsU4aFejfLNkVFE2Q42tAUL2/1IYxdPVNhEXUvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFHbL3+zGuNQxFacv8wY0zbmfeMH/3Et2wocsQzWacklLHMMQ8wlhsw6OQ6usvboW
	 kjIkRLCl55qlhyPJaPdB1MRJ4UI/WXU0FWFJ3psIP8lJOvxVs9+x4FsaiA10aVy/J0
	 pSk5Nb5qv9KjM4KkbqJXBibqRCHRZnx2b1wjxT8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claus Hansen Ries <chr@terma.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 320/399] net: ll_temac: platform_get_resource replaced by wrong function
Date: Mon,  1 Apr 2024 17:44:46 +0200
Message-ID: <20240401152558.734587880@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


