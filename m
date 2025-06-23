Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E9A1F1522;
	Mon, 23 Jun 2025 13:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684438; cv=none; b=J/ZuSF1VUY8S7jIG6s13o0F4qYUstLtDcHLS/717QnfhVxxefMnT4CKRSrGjp4G+agzMwqA0S1e5LGf63db/nLSOxX2TJm8/RolqVC0oF6uJQTtO+W6Ucslg2O4UdZTqlxBEn7o2ROXc5ONNaZM+KIDfGvBqTObRJ5aGOzy0a+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684438; c=relaxed/simple;
	bh=oU5iZKKE7RTK7ZZ/TDhzhUYePWSmpkx11FNRVhcABk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkuiPqeCxvdrVQ8F5U1SaqaX8Tgs35CBSx5ddEFzwjc+iMgbZm1ahcRILBpDaFsHyNwg1szAP4L0bIPmQFbHDTJ79klK+sA+i1RJ77QdqMwrb0bHL5vOoV9tULulWYuBcY+WR7OthJqCMnAr8jl3bU1jOfKRPJu/0P2noI1pkYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYstfR7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYstfR7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D36C4CEEA;
	Mon, 23 Jun 2025 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684438;
	bh=oU5iZKKE7RTK7ZZ/TDhzhUYePWSmpkx11FNRVhcABk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYstfR7qqQ2aKutmAfNVXhStuvJHmSAqKB/et5ZbBpZ6M7ydrG2c6dtvybH8h3H2L
	 6hEmhjOW+TjM5XKHFlMILXE3GP4SJeJ+gcqJcZHUrHlL7Ei0xUeAzQR/Nd7Zxf1/0u
	 H787n7HPbLkq1xc8MZVhmQDP9LTKBEJPlLqGJfss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Nikiforov <Dm1tryNk@yandex.ru>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 067/592] media: davinci: vpif: Fix memory leak in probe error path
Date: Mon, 23 Jun 2025 15:00:25 +0200
Message-ID: <20250623130701.853273621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


