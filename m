Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3934F70838;
	Mon, 23 Jun 2025 21:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712832; cv=none; b=UL7GB1T2Dno/eAK9dd/U6SARpn8iJ/rvi8C3BRF+qKphLq3gHtOmA90SclBL3SftmkdUDQ+QcCMGwXqa8rU33vQ60NfkZsFIu42CCQJg3gYq6bTdUaCu9X6XQCywF9ZrG6JQY2WrrYtHhxfdVpOw5uYBoiIzfsR53fuHVAhslc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712832; c=relaxed/simple;
	bh=R6YO3X8ZEhL1VcuW+0wATVLV2GbnygU6XFGWR84Nvmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRuoUJRtBmBeHi64/APUHV+wh/8y8jygf0LAE15+Foyh4UMGW6iWjjrQHqPlD8t9XG9+9DUhWThIwpBB7atCFjyg+vvbfG676zHLPq2nvOyqier4ONL/nDSonTeR09hGyqLmaJNmS1xTaQNhwPiIdxRO1xHcii2N7CEyNKp7tf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yi1/N6DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yi1/N6DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5704C4CEEA;
	Mon, 23 Jun 2025 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712832;
	bh=R6YO3X8ZEhL1VcuW+0wATVLV2GbnygU6XFGWR84Nvmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yi1/N6DYfWiD3+Sgfy/ZgPYmSvZlZav5HdDmaqU+F8a4yKbK8DBHICOysiqJpfGFq
	 pQn4y33eSxH9uVxqAYD8YuE1EMvyQIvlbLs/Is1idv+ow775rvzonL6ECZl1KDp8RV
	 4DhWI8noZo0pWxScV7GZyWwxUEGuQqLm6qdVDyG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Nikiforov <Dm1tryNk@yandex.ru>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 033/290] media: davinci: vpif: Fix memory leak in probe error path
Date: Mon, 23 Jun 2025 15:04:54 +0200
Message-ID: <20250623130627.996228216@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


