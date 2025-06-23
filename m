Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E8C219E0;
	Mon, 23 Jun 2025 21:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713590; cv=none; b=YOxgK13ZcRRqJYIUUlg4bSXzAzWlRNNcVv9V1mAAkxl66ocah3Jm9078+Or2sFNiCUpwrb/ejq40yVMmrL2YdVTgzzdI5cvfDJ/AP3hAzYcQWmcKmlJ6We7eUoX9298I4Wk2h6GlBpGfCfn3OxBzYJku2ojiKkWfFqTjfj7cNFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713590; c=relaxed/simple;
	bh=v7MFVQIOOzbkyD1nQhUKQnnuKefqs1VMYrTEujIMX0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjY979PAgrMQhTGp/jYh50ZovVjrdA3Nfe/k/ygQ8NaGAAZzyAQuFxAa8Kc06gLC/hizF0L8nu8b71L2q4G6l3ujYwBudX/tUedsq9Fnw5uXPbKddj2Hqc6omUH09lbsm6/cBH1DBu+tAOhbW2H1itXTPt+f4TmBVJjGMMYLs4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rMOxEaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rMOxEaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A47EC4CEEA;
	Mon, 23 Jun 2025 21:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713589;
	bh=v7MFVQIOOzbkyD1nQhUKQnnuKefqs1VMYrTEujIMX0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rMOxEaU7c7Dm/4YEGwBDmvgeEm30k8B3pmg1tNSndhE7bWyuIZhjxfACSt2rDjaw
	 pipT3jiGDnDuZnL72QdZ5GRtS6bOHHhMGaRiaYl07jOWKqGmKgccxlDCHgAvbAnYSs
	 S5BQuYdDWQTEjwFnZE8ATgd6n/hktvFTReIw7L4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Nikiforov <Dm1tryNk@yandex.ru>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 052/414] media: davinci: vpif: Fix memory leak in probe error path
Date: Mon, 23 Jun 2025 15:03:09 +0200
Message-ID: <20250623130643.351121149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Nikiforov <Dm1tryNk@yandex.ru>

commit 024bf40edf1155e7a587f0ec46294049777d9b02 upstream.

If an error occurs during the initialization of `pdev_display`,
the allocated platform device `pdev_capture` is not released properly,
leading to a memory leak.

Adjust error path handling to fix the leak.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 43acb728bbc4 ("media: davinci: vpif: fix use-after-free on driver unbind")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Nikiforov <Dm1tryNk@yandex.ru>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/davinci/vpif.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/ti/davinci/vpif.c
+++ b/drivers/media/platform/ti/davinci/vpif.c
@@ -504,7 +504,7 @@ static int vpif_probe(struct platform_de
 	pdev_display = kzalloc(sizeof(*pdev_display), GFP_KERNEL);
 	if (!pdev_display) {
 		ret = -ENOMEM;
-		goto err_put_pdev_capture;
+		goto err_del_pdev_capture;
 	}
 
 	pdev_display->name = "vpif_display";
@@ -527,6 +527,8 @@ static int vpif_probe(struct platform_de
 
 err_put_pdev_display:
 	platform_device_put(pdev_display);
+err_del_pdev_capture:
+	platform_device_del(pdev_capture);
 err_put_pdev_capture:
 	platform_device_put(pdev_capture);
 err_put_rpm:


