Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E782415E8B;
	Mon, 30 Dec 2024 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574158; cv=none; b=slx7dasw95oB4l899fzqeOseTOcOGaG/S6GbVnHAxeeRrrU7Ej6aV8ise/SSGtGFwO3fF68EwSa4ou9H4YCNiwEtmnXsuwDAXF863LNUNndhk98LWas18DA4EQ+JoNQJRSkg8xdyOU1pdEYqyrYo5cD1DzXZqXihtjsN97Q6SFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574158; c=relaxed/simple;
	bh=Tg4+XpkE7+BO/zeCnoKIAk4kNpbbsY3+qYYFM8LObeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQjf0Pk14bBDz7r0iuv1KoTHfJROwKE/0qYdX2nAp4D6MZo+PHrrk+ASqmUO3nVMss+40SlzCv/yW6sWiZ+ZP5ckgfwIopCj/Rd96sbJObNag2clAdqCxfZpT+KcqikeLmgVApAZ0AVYz+Sx5m3xZewJnXOMbl/mLj8gEp+nG90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYc+WqOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYc+WqOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5610FC4CED0;
	Mon, 30 Dec 2024 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574157;
	bh=Tg4+XpkE7+BO/zeCnoKIAk4kNpbbsY3+qYYFM8LObeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYc+WqOimi1QGbQCz6PtK3nSQg3jdsPQqDGExdkzrgm40DcxIwwe65UNdbWxqfqkQ
	 u3pjqhbccpTWGivO7dIVZNsA8+s1tKRIiwaO5kcytaSiV4pTqm0h5lAwETFbd5P+AM
	 f74SQx0D4inIWQ0Y2B9THXLa0regsgwIDl4w1C50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 023/114] phy: core: Fix that API devm_phy_destroy() fails to destroy the phy
Date: Mon, 30 Dec 2024 16:42:20 +0100
Message-ID: <20241230154218.956423172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 4dc48c88fcf82b89fdebd83a906aaa64f40fb8a9 upstream.

For devm_phy_destroy(), its comment says it needs to invoke phy_destroy()
to destroy the phy, but it will not actually invoke the function since
devres_destroy() does not call devm_phy_consume(), and the missing
phy_destroy() call will cause that the phy fails to be destroyed.

Fortunately, the faulty API has not been used by current kernel tree.
Fix by using devres_release() instead of devres_destroy() within the API.

Fixes: ff764963479a ("drivers: phy: add generic PHY framework")
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241213-phy_core_fix-v6-3-40ae28f5015a@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/phy-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -1126,7 +1126,7 @@ void devm_phy_destroy(struct device *dev
 {
 	int r;
 
-	r = devres_destroy(dev, devm_phy_consume, devm_phy_match, phy);
+	r = devres_release(dev, devm_phy_consume, devm_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_phy_destroy);


