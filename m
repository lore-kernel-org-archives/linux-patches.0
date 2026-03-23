Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E2721D00A;
	Mon, 23 Mar 2026 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273921; cv=none; b=a8KL1O7IuT28MYGaPRWE7zVu3xIQwWjkF4QT+eSgSZ/MWq6MrBdCKnfwEFerlHIuaBNs2bl8VuSTCaip+/ipA1wZEW17hXaZJhLI93MYSm84ACrD/bLsrjrSxx+/yj58wqUMrDYlC/TChamqmqSoSikEuOq61r5heZGQNaVrmjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273921; c=relaxed/simple;
	bh=HPOSpdORySr3F7p0CnDKJeP1Cii3KsBy1fXPA0ZxaJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/EYnHqeDWGEN37j4sLei6s/q3qAHg57BlUudtA0o/5ZUw49g81lNiAEc0kqZCdtalu3/fPUjnErnpZsgnm1JLsSbdy72Z9FCbPhFwd2HAookRx5X6Efp2BDG1QCu3MqYoNFnGyiyfsk51XPGwH88QmLsRJl8nHDyBXkuWCOVGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLW82nXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLW82nXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C88C4CEF7;
	Mon, 23 Mar 2026 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273921;
	bh=HPOSpdORySr3F7p0CnDKJeP1Cii3KsBy1fXPA0ZxaJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLW82nXpYflnxwAJSZKxHfUIArub/PJVlIWLc+begsiQsvfENYm//WE4eucQ4lJkw
	 7QZBY8RKupRokjtmax9Ud6MaNo4H1JF0BhsaBOaZRHR75p3HwNBokAnJx5yTwt6DaX
	 TFc+lB2HnwsNFpDDmkikN5CHIKDa4zLm9mS+aA/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.19 051/220] mtd: rawnand: cadence: Fix error check for dma_alloc_coherent() in cadence_nand_init()
Date: Mon, 23 Mar 2026 14:43:48 +0100
Message-ID: <20260323134506.199443031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit 0410e1a4c545c769c59c6eda897ad5d574d0c865 upstream.

Fix wrong variable used for error checking after dma_alloc_coherent()
call. The function checks cdns_ctrl->dma_cdma_desc instead of
cdns_ctrl->cdma_desc, which could lead to incorrect error handling.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -3133,7 +3133,7 @@ static int cadence_nand_init(struct cdns
 						  sizeof(*cdns_ctrl->cdma_desc),
 						  &cdns_ctrl->dma_cdma_desc,
 						  GFP_KERNEL);
-	if (!cdns_ctrl->dma_cdma_desc)
+	if (!cdns_ctrl->cdma_desc)
 		return -ENOMEM;
 
 	cdns_ctrl->buf_size = SZ_16K;


