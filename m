Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A174639FCE;
	Mon,  6 Jan 2025 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179141; cv=none; b=to/L5eamVEsywg00865SjEhL6bxNvW0Rz8HMMKHrDmoJrvkg63sjVQ5mP5kpnLodM8DY3Ih6N7hGoZpRg6ALVElHBsBuG7n0AetUKVf7W4QbOK41qUNffs47Y9zlqZMw6BavrLLRhBECVS+bhpqiI6xS7BmPKfpbUlqT3QcXc58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179141; c=relaxed/simple;
	bh=2Jz8Pth7dmP3SLpObu7EZnPZS1wqJ/KxmZ0xZS3R2kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6wGt3Z8lMAD22cDdWFjcY3saECfdewNFjrJMp9IxctQmyqilfnDgCuzz0Y8LvPKlKoNwVLx0M3azWiJoATSOb3t9AtxWYNw7CvL4b64u5pkjGn2ex3owosVdQFFTDhJ/VXaQ8ouMsvdYmOxjy31HdfJO9yNkOawuUOVJmif+wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGLls1SC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGLls1SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7E2C4CED2;
	Mon,  6 Jan 2025 15:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179141;
	bh=2Jz8Pth7dmP3SLpObu7EZnPZS1wqJ/KxmZ0xZS3R2kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGLls1SCJZM2KuB+OitoMcBhMR8E+ZXbI54X9rvy55dlXtfnZGJYJL32zBSrhz6+j
	 wIq9rzkzOHizG92tr+pAlEbmZLtWrEkSWV0qI18Hdrat5H6I1vDUGEn8wDrBOo+vHC
	 ufSWgBwNnLne6fAZLplDZYTh26DeduAIX+t5l+OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 39/93] phy: core: Fix that API devm_phy_put() fails to release the phy
Date: Mon,  6 Jan 2025 16:17:15 +0100
Message-ID: <20250106151130.177234813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit fe4bfa9b6d7bd752bfe4700c937f235aa8ce997b upstream.

For devm_phy_put(), its comment says it needs to invoke phy_put() to
release the phy, but it will not actually invoke the function since
devres_destroy() does not call devm_phy_release(), and the missing
phy_put() call will cause:

- The phy fails to be released.
- devm_phy_put() can not fully undo what API devm_phy_get() does.
- Leak refcount of both the module and device for below typical usage:

  devm_phy_get(); // or its variant
  ...
  err = do_something();
  if (err)
      goto err_out;
  ...
  err_out:
  devm_phy_put(); // leak refcount here

  The file(s) affected by this issue are shown below since they have such
  typical usage.
  drivers/pci/controller/cadence/pcie-cadence.c
  drivers/net/ethernet/ti/am65-cpsw-nuss.c

Fix by using devres_release() instead of devres_destroy() within the API.

Fixes: ff764963479a ("drivers: phy: add generic PHY framework")
Cc: stable@vger.kernel.org
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Krzysztof Wilczyński <kw@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241213-phy_core_fix-v6-1-40ae28f5015a@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/phy-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -606,7 +606,7 @@ void devm_phy_put(struct device *dev, st
 	if (!phy)
 		return;
 
-	r = devres_destroy(dev, devm_phy_release, devm_phy_match, phy);
+	r = devres_release(dev, devm_phy_release, devm_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_phy_put);


