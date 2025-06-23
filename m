Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A422940B;
	Mon, 23 Jun 2025 22:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716584; cv=none; b=lB5dzQES+lJ934WgH3M8m7Ml4LtDsgBkxouwUzCfUurqzOywrUoiw9/0eR7iPbc44lRZim457cRGzow1aNB6ZXLZQDKGfa31czdQ6oCr7qAzvi7nga2bGEKuL/65GQq4j3sFxrwXFjSFmF+64iWJv1bKm7A+g56Qx7LFsZ3aeNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716584; c=relaxed/simple;
	bh=uLgtRBU5vpPFbkJR1bqWeudCNxi+JrJHy8n1FRj3H9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4KtPembgs94GzgZfKlMa4WrOibcpiYziZjvWHrygLJ2f6c/SeGKRV71choL2VdFeMB6r+aRF9+hjU3HnwKaWrUyNoZuRRMVVaH5TY8Yubd2Yf3GyHNHL1BbKg2Hz+k1PB4tjXDibAWAPu8I0zX+7IhOzztIGG2kl8ULMEvBskU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IH2FIa6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IH2FIa6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C84CC4CEEA;
	Mon, 23 Jun 2025 22:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716583;
	bh=uLgtRBU5vpPFbkJR1bqWeudCNxi+JrJHy8n1FRj3H9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IH2FIa6esqrF9fJypBZJwdl5C/xITy3EhE5zDisr8+4g6uEiU/vGe0drCMypuvZf5
	 8d8dgoLDR/OdXCPa/P4+vb08/fwnsw6I86Sqiw2X0n5Df8WGnZ6fQY33YkBDALkHb+
	 584LW4O0UUxNzeARhMwtyjWkwDfpliNuqqU1p+FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Nikiforov <Dm1tryNk@yandex.ru>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 313/508] media: davinci: vpif: Fix memory leak in probe error path
Date: Mon, 23 Jun 2025 15:05:58 +0200
Message-ID: <20250623130653.021648646@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -505,7 +505,7 @@ static int vpif_probe(struct platform_de
 	pdev_display = kzalloc(sizeof(*pdev_display), GFP_KERNEL);
 	if (!pdev_display) {
 		ret = -ENOMEM;
-		goto err_put_pdev_capture;
+		goto err_del_pdev_capture;
 	}
 
 	pdev_display->name = "vpif_display";
@@ -528,6 +528,8 @@ static int vpif_probe(struct platform_de
 
 err_put_pdev_display:
 	platform_device_put(pdev_display);
+err_del_pdev_capture:
+	platform_device_del(pdev_capture);
 err_put_pdev_capture:
 	platform_device_put(pdev_capture);
 err_put_rpm:


