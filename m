Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A129015E8B;
	Mon, 30 Dec 2024 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573719; cv=none; b=L+tSzD9dKu7hx4HddzIo0skd7art55VaGcufY+2O2ka2j5KSgd9w0XFM4QWRkPv5FlqNRbJrMIfW+vurU9Ll9xYDgo3xYTPn3yszVj2cBiHWXehejT33QCXjts1wyPeyrpPtq41F5n27tnBq5uJFJCt7XVdHByszl6BGHmW8DC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573719; c=relaxed/simple;
	bh=E8WotHogovt/9riWKy5y8CfBgnVWZPMwfSPuZM6t9jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxJIUkKjHyENjjLDEeOa9CC0TAAhhHqDBgQQMenoaghOG2GBolxiV6f8nanr6z0/hwrgTxiZ+roM1I25Jx1oYQD6LxC+N77hzElthwl+z43sJop34xhoPuix4qUkBsWubh7Ftge4v3qzItfvzpbXggl0/x1Sykpc+ZGU5iwwXpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gy44GVxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gy44GVxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE27C4CED0;
	Mon, 30 Dec 2024 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573719;
	bh=E8WotHogovt/9riWKy5y8CfBgnVWZPMwfSPuZM6t9jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gy44GVxU8X/KgdLomyLMuRVU5x9smM/jUImxV2WSiQiBm9ryEBf2L/fGsh6MUGsYr
	 0kzVX68kkTXvr16B2whTlJIWl/WmDtoRGfsARw7VWd2jc8JVRphGcfs8HGnMEglWsW
	 JZYQ3g7PNy+wmJswP5xif5v+GBH/Leyqi60uOErA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 16/86] phy: core: Fix an OF node refcount leakage in of_phy_provider_lookup()
Date: Mon, 30 Dec 2024 16:42:24 +0100
Message-ID: <20241230154212.338218235@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -140,8 +140,10 @@ static struct phy_provider *of_phy_provi
 			return phy_provider;
 
 		for_each_child_of_node(phy_provider->children, child)
-			if (child == node)
+			if (child == node) {
+				of_node_put(child);
 				return phy_provider;
+			}
 	}
 
 	return ERR_PTR(-EPROBE_DEFER);


