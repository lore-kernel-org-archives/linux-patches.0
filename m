Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D4215E8B;
	Mon, 30 Dec 2024 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574137; cv=none; b=NV5kjhtAA6qTtvR5jLbHPx6lsoStTYkWdKU5YZ6eU0oGnNOOdXOO+7m1FAEV7zdfecN/LExXQhmat25hRurkc4r4hSuOBGYirXO87F3t5SzR9GFeweOcdedVJvZGerk+C/qHOiTiVFSjTZWkYyMNXU6drXFgsONLyZAsaG/9PBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574137; c=relaxed/simple;
	bh=ZWEY+JlXGwZQMsyYv6JO8z+x9qwArBcvcZhTWekbcy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6sL32GXWNCt+OOgUaRy3RodeeT6lRzIWv+IbKP3rq7R5TRietvVZWYfcEy6Z3n2wH6BUGXPuKGQXvhG0bd+3bu5Jn4lh1D/LEMhvveYKXH8lJt5QPDMR+9QMt0LsEkz+LHUfuQILKEkuTQTflco3agXkz1WIVN4wBtSJ/XGcTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcEJcwcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcEJcwcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB9AC4CED0;
	Mon, 30 Dec 2024 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574137;
	bh=ZWEY+JlXGwZQMsyYv6JO8z+x9qwArBcvcZhTWekbcy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcEJcwcYh5TUhCW0vlQKLu+jIJuW0x+k9+DojGpwydO0v1Q/dWLyoChWxmHBeCGCM
	 bi3CkYk4hEkbZwIgJfcw54Of+rumNPfPqn66Z3QsAfmCSTZbeX4ZqEFIZeD3WAX7sY
	 +zJyhsEuywXrD9x1cL1goRKTv4kypBb3mEDdAMMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 020/114] phy: core: Fix an OF node refcount leakage in of_phy_provider_lookup()
Date: Mon, 30 Dec 2024 16:42:17 +0100
Message-ID: <20241230154218.841014587@linuxfoundation.org>
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

commit a2d633cb1421e679b56f1a9fe1f42f089706f1ed upstream.

For macro for_each_child_of_node(parent, child), refcount of @child has
been increased before entering its loop body, so normally needs to call
of_node_put(@child) before returning from the loop body to avoid refcount
leakage.

of_phy_provider_lookup() has such usage but does not call of_node_put()
before returning, so cause leakage of the OF node refcount.

Fix by simply calling of_node_put() before returning from the loop body.

The APIs affected by this issue are shown below since they indirectly
invoke problematic of_phy_provider_lookup().
phy_get()
of_phy_get()
devm_phy_get()
devm_of_phy_get()
devm_of_phy_get_by_index()

Fixes: 2a4c37016ca9 ("phy: core: Fix of_phy_provider_lookup to return PHY provider for sub node")
Cc: stable@vger.kernel.org
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241213-phy_core_fix-v6-5-40ae28f5015a@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/phy-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -145,8 +145,10 @@ static struct phy_provider *of_phy_provi
 			return phy_provider;
 
 		for_each_child_of_node(phy_provider->children, child)
-			if (child == node)
+			if (child == node) {
+				of_node_put(child);
 				return phy_provider;
+			}
 	}
 
 	return ERR_PTR(-EPROBE_DEFER);


