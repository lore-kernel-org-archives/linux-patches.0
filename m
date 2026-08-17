Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3923F23D1;
	Mon, 17 Aug 2026 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976999; cv=none; b=FeeoR588RUJ/RrLKlCuzvl+Wbj6Myk/Tap5WjPRS1apvpG+yHKfpYfvQNbq6gHOtjPUQUc1biaBtK5Z0CGARLPvmk4DATkOE7jMkMjwafdWLTyEBF07tb03gNqhyH4sCoE9Hmhv1/Bg7IoHuG2SbSy5140RwLHyeYolAiRi+y6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976999; c=relaxed/simple;
	bh=Z5H+zDoGitVa0wDVZyiVqd3i1+BXhY3qOGdiRPIF9jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ED0j5phSe9/hKkuAD9FJ9mdS2db0oDgYsMIs2ZVV7B34XSGqk4UawAI59jloRUxWnUsHV83bKgEmXqV+KcYwZ4bsy60jJspoLosF7tW0p2afQbbJh9Bt3rf+wQiFHQ7n1vWu2GNoxP4GhMPjBkhawiHXhsJlKxhKZzd+3GUCQ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExgwcrGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExgwcrGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38E41F000E9;
	Mon, 17 Aug 2026 14:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976994;
	bh=1JmOrGIhCJQmFpe+ltYdwHe1PGtfQ+2ZYGnYr6c1ej4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExgwcrGFyP5H0vGJnDI8TF746sgwfRdkhSUKprKQreUkB2HalBbcvAfko91em54ui
	 qXQlhhRM//SefhvmRq2FygQ/9ecr5fKPK0rWqXHrkm3M+0YOXE41cEOFtmcGy2AFUK
	 IqQsiOSFbFBUUoYOxea7bAFnri9GokCtomZwWbnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 175/456] media: vidtv: fix reference leak on failed device registration
Date: Mon, 17 Aug 2026 15:29:25 +0200
Message-ID: <20260817132546.965962347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 9aa21e1549db8882ff77b691e7714153df21dff0 upstream.

When platform_device_register() fails in vidtv_bridge_init(), the
embedded struct device in vidtv_bridge_dev has already been initialized
by device_initialize(), but the failure path returns the error without
dropping the device reference for the current platform device:

  vidtv_bridge_init()
    -> platform_device_register(&vidtv_bridge_dev)
       -> device_initialize(&vidtv_bridge_dev.dev)
       -> setup_pdev_dma_masks(&vidtv_bridge_dev)
       -> platform_device_add(&vidtv_bridge_dev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: f90cf6079bf67 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -596,8 +596,10 @@ static int __init vidtv_bridge_init(void
 	int ret;
 
 	ret = platform_device_register(&vidtv_bridge_dev);
-	if (ret)
+	if (ret) {
+		platform_device_put(&vidtv_bridge_dev);
 		return ret;
+	}
 
 	ret = platform_driver_register(&vidtv_bridge_driver);
 	if (ret)


