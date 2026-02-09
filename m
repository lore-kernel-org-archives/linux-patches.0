Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F73027CCF2;
	Mon,  9 Feb 2026 14:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648395; cv=none; b=UJoeU6K7bhB1lUtQpS2iErh5ha4cbseCtEPaa1Sry0EaX2Fb8eqrRzhId5y7bW7BFNhXd/s5ZN6fLP3qqQ69ux8qwNSJizTyFXC2JbDpD5562aPidJfrc5L3XJMFQTGzSDR7JDnWMayZwkG9y9Yv8vEY1ZPDrK3YXFbaTFFvkG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648395; c=relaxed/simple;
	bh=12KsIPKWdV6QLhyJOYyPvXihxALZuWn/7FK0q7yLqrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOYPvnobAqIsNXDh2z5tSXxouxbIfKj6aXaObVMePnoc512sA9Dggx9d6QrBUlOkS3VAdYxafOAAXxTg4lgnRxmNegEDO6/Epirta0jVXnkCAGGIsyVRJFw9xsRNx7rd1b6O66r6iDaj/y9F6ZjVT2HOwChhlwBJTFmnnEsKbsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkxMekSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkxMekSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8636C116C6;
	Mon,  9 Feb 2026 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648395;
	bh=12KsIPKWdV6QLhyJOYyPvXihxALZuWn/7FK0q7yLqrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkxMekSHOh+cOjqSI/f9XK0NI0RIxBk6vwKU98pCgfcdPovNokVUybLzKMuVt19t+
	 bdSnpnsEkvwbXOE93txU3UIxIP4Q0D2GRANn7VqtrghIy47b9VNig9bL6ZgBZ+HIky
	 C+VwQwE3W8Tnai2/BT4AL1TdlYhHKOE3wG52So/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xu Yang <xu.yang_2@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 08/86] pmdomain: imx8m-blk-ctrl: fix out-of-range access of bc->domains
Date: Mon,  9 Feb 2026 15:23:31 +0100
Message-ID: <20260209142305.077476660@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 6bd8b4a92a901fae1a422e6f914801063c345e8d upstream.

Fix out-of-range access of bc->domains in imx8m_blk_ctrl_remove().

Fixes: 2684ac05a8c4 ("soc: imx: add i.MX8M blk-ctrl driver")
Cc: stable@kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8m-blk-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/imx8m-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
@@ -337,7 +337,7 @@ static int imx8m_blk_ctrl_remove(struct
 
 	of_genpd_del_provider(pdev->dev.of_node);
 
-	for (i = 0; bc->onecell_data.num_domains; i++) {
+	for (i = 0; i < bc->onecell_data.num_domains; i++) {
 		struct imx8m_blk_ctrl_domain *domain = &bc->domains[i];
 
 		pm_genpd_remove(&domain->genpd);


