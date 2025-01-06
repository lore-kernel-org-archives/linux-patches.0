Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C1513BC39;
	Mon,  6 Jan 2025 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178835; cv=none; b=rCmzyjQKuzY1T67dzo+SZYfkx//Bj4U/2PpyRau1LZnTtolcdFua5Y94ruv/rptIi0mT/Y4FDYDqAxSZBgYqhoqF7t2WUbfcWCuzHjUuu1ZyBjW9DF0n8v1E9WLXC2A1BXELn2JMX2zUctv9f96i5kmv/9i0Maa6aNptP7g34hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178835; c=relaxed/simple;
	bh=cLFIzJcPaWNTsKrrXTPxFsBJZQM9/Gh10AToL68T7BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vn0F8CzveS+WIV9Y3xX5fgE1dh04EFbVV1cVL4kmOoLh10wVXrPW3PHNkQH/ohZMyglgSRs7jY1pydtEFwhpwHN4X3QndBEu3l6CY+rja7j7T3hT99OpaH9tZRbrbveMmCUUH8tJZ1F+R82qy7K9pFKyW85LkuNrF1QyDYMY9sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqpZrMdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqpZrMdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3314FC4CED6;
	Mon,  6 Jan 2025 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178835;
	bh=cLFIzJcPaWNTsKrrXTPxFsBJZQM9/Gh10AToL68T7BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqpZrMdNiNzcbH4xEiUwPfYPKffyhf3dJ5SBb7veiXA2gpNk6+6KEoOkq/jCTaLg9
	 fqoZJ6CtOLT8zyAQ7dP8+T+37VT4XjZcFeQAV7KmD6JDUx71uo9DVPtYa2WVQvnCC/
	 GA+JkQ3bDHzj3NQsRLF+KB9ntGwN+ugnugiaRNZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 067/168] phy: core: Fix an OF node refcount leakage in of_phy_provider_lookup()
Date: Mon,  6 Jan 2025 16:16:15 +0100
Message-ID: <20250106151140.992696801@linuxfoundation.org>
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


