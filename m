Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2387A13D258;
	Thu, 11 Apr 2024 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831889; cv=none; b=dcxyn/XKDw03HroYUu5rpAKCKTY1RYP/DtvgZHtUDsht7YqlKQBQ6gkhb5hiWcLH22/4Tuv7jc+Pjkh59iz0OPkZ7Pav/rA0StIHUpjir77QAi/kecEk6nxEshCcAxlgkErf5TwyRGJ7Q3UY/9v9v1VFDQzd4Lyio3mOPj9RXXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831889; c=relaxed/simple;
	bh=nzBttE9cylekrx9FiCXI6mEgrmsQE1UZe4nYKUwHlog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NN7gFZyxzvRRRNgvPRO96wpjVW8JmLjhwqJouDbxNeYkX5nRcWFtf882Bv6CJaewb1RuxDvcXYRxoASl+uRWWGcmgd0cDwsWrasW8xCoWgXqwjNAlkOOVPautbzf8lSve184fry2/phuAcwjmvaOAs7VH9a3WFsnEJqAT3p34ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhD7fN/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhD7fN/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEF1C433F1;
	Thu, 11 Apr 2024 10:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831889;
	bh=nzBttE9cylekrx9FiCXI6mEgrmsQE1UZe4nYKUwHlog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhD7fN/5TqK4pGHL6R3gFvLkowz30MTPM7xfmaP7Wm/9ss4XOAta7Brv4FW4vVtw9
	 4dO6NHl3SRQZ4AbfJhwB7fPYDZbkKPiK7sFm6vGvzzLJ2ShYPBEhf9IQ8VxfEw2nkM
	 mojeMMWoTKc4BzhvF5Bw/3t3oQCc9j1FaQUVusFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claus Hansen Ries <chr@terma.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 161/294] net: ll_temac: platform_get_resource replaced by wrong function
Date: Thu, 11 Apr 2024 11:55:24 +0200
Message-ID: <20240411095440.491261058@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1427,7 +1427,7 @@ static int temac_probe(struct platform_d
 	}
 
 	/* map device registers */
-	lp->regs = devm_platform_ioremap_resource_byname(pdev, 0);
+	lp->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map TEMAC registers\n");
 		return -ENOMEM;


