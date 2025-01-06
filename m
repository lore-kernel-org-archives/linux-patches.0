Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5191DD539;
	Mon,  6 Jan 2025 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178297; cv=none; b=s2JHpZEZOcFJur8xnrjQZuVC/PgFvmDCTgDB5ZQ4Ne2pC5i8aGmTTIuyfUIbOhEDJYLVlAR0VTSNeVNqpK/inRQpljLwUL5LiYJJL6Xr4d5CB2UMIJnvD0xKJ6uAYPYAwX13MRsKG5UxGqy9xXLNLQAEcHICA18jA8hcHBttR8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178297; c=relaxed/simple;
	bh=qvlheI/0tY/ShvB5C1fql8KL33nkM4z7cmMSmTsPaWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnQIZz6ay/GsEZLcbK8StY3CVkXKfGEXMpEkvkDccTmvXajlSp3ESUca4r/9QAGBuQ/VZ/fi9KQpDj2NzWAISPnOVH/Bt+OCfQfZQv7IwpCv4Xqy/W72sv3vEq6kyQzx7HXrGWJgQE7zGsFnxspo8D7BG5+sjbzzVptD3ymW0Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kduHSMZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kduHSMZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38347C4CED6;
	Mon,  6 Jan 2025 15:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178297;
	bh=qvlheI/0tY/ShvB5C1fql8KL33nkM4z7cmMSmTsPaWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kduHSMZBmnKoAWjbMT7RLBlk/2JtAjGPiKynr7eJY4FJnacZSRAfgq6wLBM2DbY8m
	 S3eTI7SZaK+wRQAgiI8+s8upxPi/egz5F/ZoJDefbLMOhOA+cUqgbZgJHOiU2DJk9R
	 8dSxHo7OYCTkQ6m7phPUKSyo7WGfifGKseRwC6k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 054/138] phy: core: Fix that API devm_phy_destroy() fails to destroy the phy
Date: Mon,  6 Jan 2025 16:16:18 +0100
Message-ID: <20250106151135.280977409@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -991,7 +991,7 @@ void devm_phy_destroy(struct device *dev
 {
 	int r;
 
-	r = devres_destroy(dev, devm_phy_consume, devm_phy_match, phy);
+	r = devres_release(dev, devm_phy_consume, devm_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_phy_destroy);


