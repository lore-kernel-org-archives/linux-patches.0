Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73AE11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676F7C433C8;
	Mon, 11 Sep 2023 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445480;
	bh=V0GJWpnoLKNj4nHhg5lweOybXCxITJocfRhvjA+g95A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkyPPX6nryYYEHm9zClnF8o5UTX1ZSmG1AOyJdriBJruWpdE7Rs5WCIC5YOXSrGd8
	 nMaLLJlXV5whyMr1XO1HniSDrSqU09S085lf1jCTkkejAgGi5rnILTnbH+WKjj6cUj
	 B/Qy5xjmQwXaNFWaQWEBEGCpS2mCA83InL3iWgYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@svenpeter.dev>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Eric Curtin <ecurtin@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 335/600] PCI: apple: Initialize pcie->nvecs before use
Date: Mon, 11 Sep 2023 15:46:08 +0200
Message-ID: <20230911134643.577843800@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit d8650c0c2aa2e413594e4cb0faafa9958c1d7782 ]

The apple_pcie_setup_port() function computes ilog2(pcie->nvecs) to set
up the number of MSIs available for each port. However, it's called
before apple_msi_init(), which initializes pcie->nvecs.

Luckily, pcie->nvecs is part of kzalloc()-ed structure and, as such,
initialized as zero. ilog2(0) happens to be 0xffffffff which then simply
configures more MSIs in hardware than we have. This doesn't break
anything because we never hand out those vectors.

Thus, swap the order of the two calls so that the correctly initialized
value is then used.

[kwilczynski: commit log]
Link: https://lore.kernel.org/linux-pci/20230311133453.63246-1-sven@svenpeter.dev
Fixes: 476c41ed4597 ("PCI: apple: Implement MSI support")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-apple.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
index 66f37e403a09c..2340dab6cd5bd 100644
--- a/drivers/pci/controller/pcie-apple.c
+++ b/drivers/pci/controller/pcie-apple.c
@@ -783,6 +783,10 @@ static int apple_pcie_init(struct pci_config_window *cfg)
 	cfg->priv = pcie;
 	INIT_LIST_HEAD(&pcie->ports);
 
+	ret = apple_msi_init(pcie);
+	if (ret)
+		return ret;
+
 	for_each_child_of_node(dev->of_node, of_port) {
 		ret = apple_pcie_setup_port(pcie, of_port);
 		if (ret) {
@@ -792,7 +796,7 @@ static int apple_pcie_init(struct pci_config_window *cfg)
 		}
 	}
 
-	return apple_msi_init(pcie);
+	return 0;
 }
 
 static int apple_pcie_probe(struct platform_device *pdev)
-- 
2.40.1



