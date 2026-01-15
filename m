Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4E027A462;
	Thu, 15 Jan 2026 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498645; cv=none; b=lglOmbaeKfc1Fy39jbZRzTxWHBhpgfWIJXF4zikXqGP1Jj5fSZrCktu0UBuaD/ANzRxi9stziYIN+8w+UAuZUkKz/8xihPh017mtOfVhM7Kl7KNjG66VBxRT4NaTROIdnm7xL61+BMhSVjhkrNP+QGi0FyHKen9yFuTlubswfsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498645; c=relaxed/simple;
	bh=I97X+y9fbhAJygZPWhCAFNLtmuTAf+nWFJSqUF7ACyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NU3cHagZ0FcbpJWbEgdt+81kduZf27ESYgK/MqfzXlP9ZH3GXf1/TNa/T8gJhVf+P+rWqTJf8Sq46rj48bLCOBYIrggYduc4D791Jd2KanKttz0YQXr06bFnF3Mhc37OZJqvc5gJVP53+GO1R/3nKrtOcHUfq18r4Wa7M/tRKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDCYEbw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDCYEbw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7CFC116D0;
	Thu, 15 Jan 2026 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498645;
	bh=I97X+y9fbhAJygZPWhCAFNLtmuTAf+nWFJSqUF7ACyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDCYEbw2XsCqR63kFf+Er8MzCSPjkMKkC4pWKEDznfveCAbRjVphzIwG7EkjjoyC3
	 7RDPGQu3gloKUmkkkczlQNfSm9Rhi5cWtlhLp4hkqLCsubi1sADd8Vv3w3eVaWCA2n
	 75bKZBJNj7CYZqUT1K+T7wZUiUZoTip+VVZHcnbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 5.15 505/554] drm/pl111: Fix error handling in pl111_amba_probe
Date: Thu, 15 Jan 2026 17:49:31 +0100
Message-ID: <20260115164304.596276383@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -297,7 +297,7 @@ static int pl111_amba_probe(struct amba_
 			       variant->name, priv);
 	if (ret != 0) {
 		dev_err(dev, "%s failed irq %d\n", __func__, ret);
-		return ret;
+		goto dev_put;
 	}
 
 	ret = pl111_modeset_init(drm);


