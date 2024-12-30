Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69DB126C13;
	Mon, 30 Dec 2024 15:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573492; cv=none; b=F0v9YZBSpCbcOf6Hjpu3xQ9a9znCSakpzPRG5sFXLVoqK2rYnAD3FZVah27FJ/bzPfH5L8ynC/e3ywp/0QqMSUhs1xmTo+mSs6z/5gv7KXxaCjQMxdN2Kd/adBDZHiBSSq3EcKbplOzQrT3MtAZkJaNnvAblJMUcd84tPHV5VlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573492; c=relaxed/simple;
	bh=ft3sFnr+svwkIRBEPpDFz9i2ap17yNF+ykRxPudAmVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ghoc7cF12rl7wFhcpIMGsb72nuei5ZgLpPzhJ2uKsSve8Blq6/6Y6RfxM98HbOI5bKf9WwZaLSe3A44n8p+wWSmrBbAkwiTZG/KgYwMLw6CuGO91hYXtUqxfcMXY+Efm40WQAcxdZveaSNqcQc40svwYMlLd4Bb3gFLYW6gzodg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2G7O0o7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2G7O0o7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF69BC4CED0;
	Mon, 30 Dec 2024 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573492;
	bh=ft3sFnr+svwkIRBEPpDFz9i2ap17yNF+ykRxPudAmVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2G7O0o7pRjpcORRh6q7Tq2o+18M1Hq09mICDNW9mryWxtRgDlxUABkKLHMeGx8r4
	 a35GbLHs37eruhKeZImiWHMgRNyw4yO00oYlviAdKgIC3935B32iO0xa2tqrVwF7lQ
	 fM6rI+4ZO6UAungRmgvkNogbZmrMB7E4pf7bst54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 12/60] phy: core: Fix an OF node refcount leakage in of_phy_provider_lookup()
Date: Mon, 30 Dec 2024 16:42:22 +0100
Message-ID: <20241230154207.754244527@linuxfoundation.org>
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
@@ -138,8 +138,10 @@ static struct phy_provider *of_phy_provi
 			return phy_provider;
 
 		for_each_child_of_node(phy_provider->children, child)
-			if (child == node)
+			if (child == node) {
+				of_node_put(child);
 				return phy_provider;
+			}
 	}
 
 	return ERR_PTR(-EPROBE_DEFER);


