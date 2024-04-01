Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E976840876;
	Mon,  1 Apr 2024 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991304; cv=none; b=bbQv7uEuAFwiVZgHonMwrI+kXErhDn0zmP/r+y5fIFS1v+1l7fzEcWb0GdZx9VvzZMvgOhuhTPBK6yo9iW3dI3G7FUWCgy/6n6uA6IyciiGe2+8iAl/FPsL32xhxMjzZ9UFFGbu7DRMTFqBo4UrnxrnWbTv2XXClMDDs9w0vw4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991304; c=relaxed/simple;
	bh=wE995doWIxzIowIf05Z7VrI/hrgMU8qsfEkijAckbeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK8+LodeWy3HH7/KJXNF5u/WU5lgO7tMgkHygbuZD81aOt0VlPFaZ5JXvvYmoqHJGfwey2Ga68rmy1B5fhuyBscIz6DaieVN7v7Eahe9I04VjJTITbFYYNeG7OUm0OrQfvgDVVs6Z5ZhnoMZQnDxTNVDV/ximBXqjAudRT/zgFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJxmPCNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJxmPCNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72475C433F1;
	Mon,  1 Apr 2024 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991303;
	bh=wE995doWIxzIowIf05Z7VrI/hrgMU8qsfEkijAckbeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJxmPCNTvg/Un3Us/fgInUjo3JVGiP9iAEjbv/OpLHAdBTBoVUhofeXBxAcxlCJja
	 s+O2121RiXWvT4YAEBulRmRwFY2zmXfYoLv2GZ/artLw+NRx0mvPVRhJv5Qjs9AV68
	 gdt1N9i1vBKKVzxWqcSq2OWciFKCM009iSf6c9uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claus Hansen Ries <chr@terma.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 225/272] net: ll_temac: platform_get_resource replaced by wrong function
Date: Mon,  1 Apr 2024 17:46:55 +0200
Message-ID: <20240401152537.979691389@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1445,7 +1445,7 @@ static int temac_probe(struct platform_d
 	}
 
 	/* map device registers */
-	lp->regs = devm_platform_ioremap_resource_byname(pdev, 0);
+	lp->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map TEMAC registers\n");
 		return -ENOMEM;


