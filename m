Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B611170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6680FC433C7;
	Mon, 11 Sep 2023 14:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441351;
	bh=J781aNgR4OJrXngVWR5nbN+mzMPMDlkcXpIXzULR6bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/UmTRb7HEUfKjBrXnaVKVss6wqqpdqiiOo5kWwarnoVFo0WfuiqSJclvddivsU5r
	 W2n991QwBADdTPc1bCJ2cndmKaSivUl4GG7kOvIGXx+XaRzE+USHzJ+K576I1NrNPG
	 C1H/8V/hoZeDTBhdTZ/mWOzpsUhol9g/hm12sY4M=
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
Subject: [PATCH 6.5 383/739] PCI: apple: Initialize pcie->nvecs before use
Date: Mon, 11 Sep 2023 15:43:02 +0200
Message-ID: <20230911134701.889731515@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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



