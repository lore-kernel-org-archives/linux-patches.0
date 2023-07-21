Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA7520F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E88C433C8;
	Fri, 21 Jul 2023 19:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966875;
	bh=p5JVv4G5OpH9aD3Bf6E8Od1aR5fvlw///ewrXHrkjnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0IMnOxnKQsiDDVy0IDRGNuEmLmbBbSlHmdnJz1l7R4liiJiPRB5fJYgBfLpTKMx9
	 QXYoKn/ybY/bB2k0KQIZJU0J9eIAzWrb0zQz83jga2sWKxczFCGd8ayvDuU8vHsHnY
	 S7MzHoCellTXFE/26GBqNctgbiEMg5UB33M8OKeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.15 498/532] firmware: stratix10-svc: Fix a potential resource leak in svc_create_memory_pool()
Date: Fri, 21 Jul 2023 18:06:42 +0200
Message-ID: <20230721160641.592414275@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 1995f15590ca222f91193ed11461862b450abfd6 upstream.

svc_create_memory_pool() is only called from stratix10_svc_drv_probe().
Most of resources in the probe are managed, but not this memremap() call.

There is also no memunmap() call in the file.

So switch to devm_memremap() to avoid a resource leak.

Cc: stable@vger.kernel.org
Fixes: 7ca5ce896524 ("firmware: add Intel Stratix10 service layer driver")
Link: https://lore.kernel.org/all/783e9dfbba34e28505c9efa8bba41f97fd0fa1dc.1686109400.git.christophe.jaillet@wanadoo.fr/
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Message-ID: <20230613211521.16366-1-dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -622,7 +622,7 @@ svc_create_memory_pool(struct platform_d
 	end = rounddown(sh_memory->addr + sh_memory->size, PAGE_SIZE);
 	paddr = begin;
 	size = end - begin;
-	va = memremap(paddr, size, MEMREMAP_WC);
+	va = devm_memremap(dev, paddr, size, MEMREMAP_WC);
 	if (!va) {
 		dev_err(dev, "fail to remap shared memory\n");
 		return ERR_PTR(-EINVAL);


