Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31A11422DD;
	Mon,  6 Jan 2025 15:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178265; cv=none; b=FBXN8b7GKaZz/dwFUBaV5gqJkAdjye6DX/asNfaJUmU4+fa3e9qogvqqehKsoV0Iy4VBSddYuiEotfLMVVYQC0/Shtwc2OaSP5JCdwWsY08z3jwMiEQ0CJwS80GRzM548n2r8BDx1xvrZasLkufhUZLmqPdAr1BaySO5jiovC/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178265; c=relaxed/simple;
	bh=HiAoptANd6z++l4LfwqFo9luHBVeFptZGAO06L+Rxm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzvxnrbnINz70/cAvqvclJ8IpgNhFKmh9mzjYu88xPQqTBntBl8uhFWbT3bDpYjik+aEuzu5ok4LeBNNONnlp7drzma0RY+K2kfcm7GXN/Z9h8d2DQJPuTJZG/qPn85OQZgIOW+IrMFXGkIFw7z4C0N6gyQKBXuv/aXjIf/NDTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMSRLZOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMSRLZOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B345C4CED2;
	Mon,  6 Jan 2025 15:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178264;
	bh=HiAoptANd6z++l4LfwqFo9luHBVeFptZGAO06L+Rxm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMSRLZOUg9vYoqaPua9aTVHqZjTfmgsgFvE09Tz+yr24HZQiqPWPBEhONe306BNrk
	 BrefqL7y1WuNWH7hDVFsC0kX0J6e767uIV1xllWjmjkHUqAUTI7VxzYVWRJSC6bz7Z
	 JhCw63deLSch2XsvNC8KXAxO71QBgQeJkFggGIls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 053/138] phy: core: Fix that API devm_of_phy_provider_unregister() fails to unregister the phy provider
Date: Mon,  6 Jan 2025 16:16:17 +0100
Message-ID: <20250106151135.243375637@linuxfoundation.org>
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
@@ -1129,12 +1129,12 @@ EXPORT_SYMBOL_GPL(of_phy_provider_unregi
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


