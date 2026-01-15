Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721412D5C9B;
	Thu, 15 Jan 2026 17:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496864; cv=none; b=fJbp0/bOAo/gD4LU2R1/8He6e/s4xcp85TzPPMBVG30U8WHR3Ze24suWZhPMZmvSY//3VV9vS4euHZNTzXPMwnuht8rjtjQqC5KMODZCPiGXGwLmS8RZRieXJGAsj9nia0rGBwOdIW5ffQdB/PgCld99d5oGxOoA5vIsi3sNh3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496864; c=relaxed/simple;
	bh=3JHM7wDqGNHV/6vw7jVf+XW3JP5L7YlprjhBfUJOXmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucEwvNyiXq3HwdLuOr5gp/mcBysR1mO5vTpBaQCBNi0WXzaU1NGCL1W2B5SGFMrmBAlfIBsbrmJX1Vyw7OzhqIGoRKHjdruF0GrAOoWQuTciSI+K3jYJSt1N+VW4sZ65nUkBCmp4lqHS/2SYqJMCQmGWYdemKvtBUe8PeClTZyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXydBgMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXydBgMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A8CC16AAE;
	Thu, 15 Jan 2026 17:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496864;
	bh=3JHM7wDqGNHV/6vw7jVf+XW3JP5L7YlprjhBfUJOXmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXydBgMdY7ECsCLM6wfxrJw4Q1UgKMfrZi3GTRRB8u8sXnPFOdwwD/l4YCyZSFCCS
	 6AEYh1tXF5g97kihxIG3wgOLfcOd66/HstOF7XikZHIKhdx9dp/03wipkhiZzSD4jd
	 kCvB9byzs5ntIosJyrl0XgNQm032WPTndHpoi8xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.6 10/88] drm/pl111: Fix error handling in pl111_amba_probe
Date: Thu, 15 Jan 2026 17:47:53 +0100
Message-ID: <20260115164146.692913432@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 0ddd3bb4b14c9102c0267b3fd916c81fe5ab89c1 upstream.

Jump to the existing dev_put label when devm_request_irq() fails
so drm_dev_put() and of_reserved_mem_device_release() run
instead of returning early and leaking resources.

Found via static analysis and code review.

Fixes: bed41005e617 ("drm/pl111: Initial drm/kms driver for pl111")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20251211123345.2392065-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/pl111/pl111_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/pl111/pl111_drv.c
+++ b/drivers/gpu/drm/pl111/pl111_drv.c
@@ -294,7 +294,7 @@ static int pl111_amba_probe(struct amba_
 			       variant->name, priv);
 	if (ret != 0) {
 		dev_err(dev, "%s failed irq %d\n", __func__, ret);
-		return ret;
+		goto dev_put;
 	}
 
 	ret = pl111_modeset_init(drm);


