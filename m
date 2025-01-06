Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C22313AD20;
	Mon,  6 Jan 2025 15:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178770; cv=none; b=CZ9xtr6ht2gefOQlI2M4Qk6HJxbF+OizymFMRWSLg5xwsew4/cN1tFFbxXZjwfV/rF4MRtaoXbgfBIr8lzrwEHaqNjBRBoBV1Nf3XHgycemwT40Zwm3PRAg+Dtnjd15Rcq3SRpFooYmqVNj4IecIQPPBAwo8XoAQ6feDIjHDGiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178770; c=relaxed/simple;
	bh=JlJAr6dug6TzWwhSbjxu6h1U5GciBd6wa/fWBWec4nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBv40qNiKpRcQ6+AL1QCbNgVXEDawY4X2lyIt5jsKHApkD6KJoBuv9C2xw9C3jdRhT/pT3sQGmXjlAaDyjOCcq6Y8u1KftuHk3Mxh8XQIPQ4w2UlMrBJTtihf9R4/ctM4k+HK370jzvuXE3p0YKfSGb9zJepQJl4AnjC8RWjLGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4zrQKBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4zrQKBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13362C4CED2;
	Mon,  6 Jan 2025 15:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178770;
	bh=JlJAr6dug6TzWwhSbjxu6h1U5GciBd6wa/fWBWec4nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4zrQKBZr8h5fmBPk7d0RdxaT6eIzZei2Y9T8G7TYfanVSfLrUqypqG9+h9ZsQs7B
	 vh1/01/vOZUtVGrN8ZBt/k46Mnw6jgluH6IVLgXKhR+JjjHnqf/wuBrUFu58LuVaXU
	 gfe14buVNKaA4LymXawZBh4ipFKatRJT4iVqXLiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 069/168] phy: core: Fix that API devm_of_phy_provider_unregister() fails to unregister the phy provider
Date: Mon,  6 Jan 2025 16:16:17 +0100
Message-ID: <20250106151141.072343226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit c0b82ab95b4f1fbc3e3aeab9d829d012669524b6 upstream.

For devm_of_phy_provider_unregister(), its comment says it needs to invoke
of_phy_provider_unregister() to unregister the phy provider, but it will
not actually invoke the function since devres_destroy() does not call
devm_phy_provider_release(), and the missing of_phy_provider_unregister()
call will cause:

- The phy provider fails to be unregistered.
- Leak both memory and the OF node refcount.

Fortunately, the faulty API has not been used by current kernel tree.
Fix by using devres_release() instead of devres_destroy() within the API.

Fixes: ff764963479a ("drivers: phy: add generic PHY framework")
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/stable/20241213-phy_core_fix-v6-2-40ae28f5015a%40quicinc.com
Link: https://lore.kernel.org/r/20241213-phy_core_fix-v6-2-40ae28f5015a@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/phy-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -1161,12 +1161,12 @@ EXPORT_SYMBOL_GPL(of_phy_provider_unregi
  * of_phy_provider_unregister to unregister the phy provider.
  */
 void devm_of_phy_provider_unregister(struct device *dev,
-	struct phy_provider *phy_provider)
+				     struct phy_provider *phy_provider)
 {
 	int r;
 
-	r = devres_destroy(dev, devm_phy_provider_release, devm_phy_match,
-		phy_provider);
+	r = devres_release(dev, devm_phy_provider_release, devm_phy_match,
+			   phy_provider);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY provider device resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_of_phy_provider_unregister);


