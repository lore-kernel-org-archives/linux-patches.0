Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E441AB505;
	Mon, 30 Dec 2024 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573504; cv=none; b=lbjUQBroDDGyVcjGt+B/c7khwvRY/YCjEe2oiQVGaLndSGjufntOEQuhhHNXNQUS+73IheXcXGrYRMirEbuWXQ+yYbg7JUcsL5C47LfTU1gRsJx2nKPP3LUjM2ZHdMCr3cNJ4/7YwCf8xaY8CGEPXZyZPjI8Vjn9GdhwiP4+9BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573504; c=relaxed/simple;
	bh=rghf21gGfjRetS41Tc+X7u2dSjsIoDMCpkPp2IFOivc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrsoFHdWaCUaWQESoCtuSW94TaaYKmPjQqr/Mpurxy7xT14IqIgNdTrI+YyCf8oSMj1YR6w7cyF0USrONrxFBQs6XUgm8PjgdwpSILrw46yE8SSy6HgAD0wsUThiIfcNn6xIYbYPoxjDA6ZETEN1ZIjN0ITCf450dPTiXwbC/js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMFzNQ74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMFzNQ74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBB4C4CED0;
	Mon, 30 Dec 2024 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573504;
	bh=rghf21gGfjRetS41Tc+X7u2dSjsIoDMCpkPp2IFOivc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMFzNQ74vBJubDHdOlB0oyfa3FuSQ0e8KGh+5nBCpLLfUJl1svbAuUagaAqn9NI0s
	 WLRbrJk5gqeR5fqyetYwASjHB4Kv4kr1nXz7iZ3LIKSUKGcGVqDce7HTmL22GkfQbP
	 S0iWw4nLlbtOEjr9vxAInD7vZyeD0+rh6w5vdVg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 15/60] phy: core: Fix that API devm_phy_destroy() fails to destroy the phy
Date: Mon, 30 Dec 2024 16:42:25 +0100
Message-ID: <20241230154207.867080870@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1061,7 +1061,7 @@ void devm_phy_destroy(struct device *dev
 {
 	int r;
 
-	r = devres_destroy(dev, devm_phy_consume, devm_phy_match, phy);
+	r = devres_release(dev, devm_phy_consume, devm_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_phy_destroy);


