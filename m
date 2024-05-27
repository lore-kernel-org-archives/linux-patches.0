Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA00168C4;
	Mon, 27 May 2024 19:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837469; cv=none; b=F7o93UUjQDcwhKm07WdCcP9wr2G4OcMtE6PI24MG7MR92W9v0wjmGbAFqffUJqSdQJScD6oxyth5wCy8l7azr4tvinCISXkkW9W36xjvZtN91Hjyf3g4U/c/bkhd4nXj3+OIXX93ekRUfsROv7kkEbAJIj6qLaKkR/qU1dn3g1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837469; c=relaxed/simple;
	bh=UnPhMDJj+BcuGHDNP9pu6G3QqtDF0RD1IdTtoHhh86w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usUFK21fmIqpdzSvuoQ2P+5vAVFMNlKACqsGd8wrmVdJtt+m4ULRUoBPgrLa9qO3gjo9AqZgi9fyzQ0Hh1dnUoxMLG72xaPWnMAOTVlIvRfvr//1XxK33TlQmElymMx067AASl5AbUfCQqyXkS++YiFFf/CHqUVqYP5crNjdfpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9ngwMtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9ngwMtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D978FC2BBFC;
	Mon, 27 May 2024 19:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837469;
	bh=UnPhMDJj+BcuGHDNP9pu6G3QqtDF0RD1IdTtoHhh86w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9ngwMtnSw+152XeLBgm6xQuVBwpIw0vvqkoLp5QqidsP52inX8brN521KXh17zuF
	 KMyODOWyWIvwgN35ZzN78WGbGQIY27VzU9oscRucQgNyh0NxOSdom5991iPWZZXPMH
	 zdjQpQvDtDmpywMJtXQ7bdNGbE1dmp8RoxG1N1Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 023/493] net: lan966x: remove debugfs directory in probe() error path
Date: Mon, 27 May 2024 20:50:25 +0200
Message-ID: <20240527185628.805917428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 99975ad644c7836414183fa7be4f883a4fb2bf64 upstream.

A debugfs directory entry is create early during probe(). This entry is
not removed on error path leading to some "already present" issues in
case of EPROBE_DEFER.

Create this entry later in the probe() code to avoid the need to change
many 'return' in 'goto' and add the removal in the already present error
path.

Fixes: 942814840127 ("net: lan966x: Add VCAP debugFS support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -1087,8 +1087,6 @@ static int lan966x_probe(struct platform
 	platform_set_drvdata(pdev, lan966x);
 	lan966x->dev = &pdev->dev;
 
-	lan966x->debugfs_root = debugfs_create_dir("lan966x", NULL);
-
 	if (!device_get_mac_address(&pdev->dev, mac_addr)) {
 		ether_addr_copy(lan966x->base_mac, mac_addr);
 	} else {
@@ -1179,6 +1177,8 @@ static int lan966x_probe(struct platform
 		return dev_err_probe(&pdev->dev, -ENODEV,
 				     "no ethernet-ports child found\n");
 
+	lan966x->debugfs_root = debugfs_create_dir("lan966x", NULL);
+
 	/* init switch */
 	lan966x_init(lan966x);
 	lan966x_stats_init(lan966x);
@@ -1257,6 +1257,8 @@ cleanup_ports:
 	destroy_workqueue(lan966x->stats_queue);
 	mutex_destroy(&lan966x->stats_lock);
 
+	debugfs_remove_recursive(lan966x->debugfs_root);
+
 	return err;
 }
 


