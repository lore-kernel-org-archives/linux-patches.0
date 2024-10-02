Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605CE1D0793;
	Wed,  2 Oct 2024 13:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875719; cv=none; b=Qo3TPxX2LEph4kxQlEbqwGyR63gN9ESwzGNq8fRThSVYD4oZe5u3+EIwJ4eHpWTTFdSV0/EHsc5F2cgsFrIR82EpsD3iFhGCrUGubPfllmV3QR94jxwb0OG/SJjRF+kNiEZKVI8WnH+XDMzg8ivf5G6XK6ZmByE9m+44eT8Gw/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875719; c=relaxed/simple;
	bh=yDP0KzAVKRFlSn/Ge5BnTEDHJZdE4OqPmmyJKhEcRJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpylqsRI+ovdpCYshgp/35LNcWj7o8NRItJ3L/ktxS6jA1prfq+gXFwjQlk0+aMH1GLl/RcoGSKHueJ77CYh3R0sXmlepbndz3HheRd4Vuw3lC9fXerQxS8Xla5KVY9nZmJPlVDSm6yI6Wu/voQxKWQPrv2d+z4mGZMDdggKpAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nH01zVao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nH01zVao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB86C4CECD;
	Wed,  2 Oct 2024 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875719;
	bh=yDP0KzAVKRFlSn/Ge5BnTEDHJZdE4OqPmmyJKhEcRJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nH01zVaoC7/Xurd44RD+CmJXcAwN6sHpX8K0nndPBLsuPq4tVgC8cfqeOiVp6RWck
	 1SPpepmnN/+4XBjQzlEiMlhLPNLwyXJI3AR8hFvZQdZQ6+sCA2JCIDlEpYZIHRrip/
	 PIg/uEmynbvNB+5rzSUa3KM0OmkB1vNPTTx8zj9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 198/695] drm/stm: Fix an error handling path in stm_drm_platform_probe()
Date: Wed,  2 Oct 2024 14:53:16 +0200
Message-ID: <20241002125830.368913475@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ce7c90bfda2656418c69ba0dd8f8a7536b8928d4 ]

If drm_dev_register() fails, a call to drv_load() must be undone, as
already done in the remove function.

Fixes: b759012c5fa7 ("drm/stm: Add STM32 LTDC driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20fff7f853f20a48a96db8ff186124470ec4d976.1704560028.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/stm/drv.c b/drivers/gpu/drm/stm/drv.c
index e8523abef27a5..4d2db079ad4ff 100644
--- a/drivers/gpu/drm/stm/drv.c
+++ b/drivers/gpu/drm/stm/drv.c
@@ -203,12 +203,14 @@ static int stm_drm_platform_probe(struct platform_device *pdev)
 
 	ret = drm_dev_register(ddev, 0);
 	if (ret)
-		goto err_put;
+		goto err_unload;
 
 	drm_fbdev_dma_setup(ddev, 16);
 
 	return 0;
 
+err_unload:
+	drv_unload(ddev);
 err_put:
 	drm_dev_put(ddev);
 
-- 
2.43.0



