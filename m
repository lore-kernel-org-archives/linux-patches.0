Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AAD42049;
	Thu, 15 Jan 2026 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495960; cv=none; b=DjInJQCwUPUtX22yfcrsp+lCJ1i7QTJJXI/vBvgO3K/7h4+7pm/7EKYf6Ki7tUU9fdHB2lYSySarAk9fVT2m0q3mb7FqdoNQdnbCNjLv9C1mqOxK7+MA/ZhujzmSENT+xCcFY2oYZpc7OmrbrMUruSfnNkgfqqjNzzQqTObSACY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495960; c=relaxed/simple;
	bh=NBL2ht6b0hQ2IGaYE9QarfJw4IvWBRvIe9hcSsPvgps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya/zqenO7KdONwUnd94pAnF4zS3TM6qPqxpyoy/XVDzwee/hILmbswQGdenFBpB2wqyP2bW3lCiWZ/mA4h75pCNIp0fM147YWYV26sEznHH196IWE/8a2t5vTBTTyplomuIZ2Ni4TtF0GbIAKl2QWJP64hjm/YBvni5JXWcLFP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPb1a4Vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPb1a4Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A53C116D0;
	Thu, 15 Jan 2026 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495960;
	bh=NBL2ht6b0hQ2IGaYE9QarfJw4IvWBRvIe9hcSsPvgps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPb1a4Vmt6wI5ami3DcDk4XZUpJ1/WWmQJiJxga0NR9eHdWsYgI7XGBAyhZyXfXB0
	 D/H3F91ofuqYEAqg+cWzy8Q2TX7N8wFlFoMayMcmJJzqh0zCmE0dF4esi8VgNGrVCO
	 slkYqrnk4pXOUQ+AFkiqD3oirur6vwd//8GR7tNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 028/181] drm/pl111: Fix error handling in pl111_amba_probe
Date: Thu, 15 Jan 2026 17:46:05 +0100
Message-ID: <20260115164203.344351110@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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
@@ -295,7 +295,7 @@ static int pl111_amba_probe(struct amba_
 			       variant->name, priv);
 	if (ret != 0) {
 		dev_err(dev, "%s failed irq %d\n", __func__, ret);
-		return ret;
+		goto dev_put;
 	}
 
 	ret = pl111_modeset_init(drm);


