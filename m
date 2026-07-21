Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B635364959;
	Tue, 21 Jul 2026 18:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659365; cv=none; b=ZMHc4j9dxuob4tesmSfIaIuNqAEP1W+k9YTFTzS5UwsA3kVwjzJ4Eg7CrGnTAKj1k+2bl/t3mP1TiRKwZOJ8t+3zUH6NqypHePKtmvr2PPws8sKS5Ok5ymYBRGZ9qfU+GRlfps9Iuwufd7MmGk28wB70KGiKm9K0QiyIseiaH7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659365; c=relaxed/simple;
	bh=lQGyHnG+YxZKyw1/R6TTWL5EJIgfEyAntaMjgLhLytc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6JXKUY13rzOfO9ab9DphrtO5DI7D8lMmS1BmnfmLt2lPOByYWO+Lpwau5uXj7gwI8j5mVA62S93v/WHN9MMrofuLTJQmlwy/K3gHHH+QrqFVZHihWkMAW1VxuUZILozzKuyPfvoewLG9RShFxvuTi7F+UjIcpW/2cp/piymKSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=195Hzi+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="195Hzi+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08DE1F000E9;
	Tue, 21 Jul 2026 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659364;
	bh=Riv+EMgjp5F9MVqlmfKqgcGqNDv6tptsqIbrOADbaVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=195Hzi+kzGZHE/y5xeLmz/OrLAUmxFxwzHFhFdiFtwGgeH4EIlg5drJJPJVtS+ULj
	 vfC2m1SPIXU39YSjmyvMx0x0fd1bKLXlq5nzq69RK9psr9YdfuT3o/2PAGk/Nuzbeg
	 pwpxNPstUVL06S+LZohLxsuOPMQYorb29SJuEjqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 6.18 1494/1611] reset: sunxi: fix memory region leak on ioremap failure
Date: Tue, 21 Jul 2026 17:26:50 +0200
Message-ID: <20260721152549.047331685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit 1a8c89f8c112c75e84ff9a140f969e372aed0c9a upstream.

In sunxi_reset_init(), when ioremap() fails, the memory region obtained
via request_mem_region() is not released, leading to a resource leak.

Add an err_mem_region label to properly release the memory region before
freeing the data structure.

Fixes: 8f1ae77f4666 ("reset: Add Allwinner SoCs Reset Controller Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/reset-sunxi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/reset/reset-sunxi.c
+++ b/drivers/reset/reset-sunxi.c
@@ -44,7 +44,7 @@ static int sunxi_reset_init(struct devic
 	data->membase = ioremap(res.start, size);
 	if (!data->membase) {
 		ret = -ENOMEM;
-		goto err_alloc;
+		goto err_mem_region;
 	}
 
 	spin_lock_init(&data->lock);
@@ -57,6 +57,8 @@ static int sunxi_reset_init(struct devic
 
 	return reset_controller_register(&data->rcdev);
 
+err_mem_region:
+	release_mem_region(res.start, size);
 err_alloc:
 	kfree(data);
 	return ret;


