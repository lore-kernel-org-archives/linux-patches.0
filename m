Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B4019DF60;
	Thu,  6 Jun 2024 14:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683100; cv=none; b=CYim2pkCMNEFVv0qKasJnRGcgmgdHlm9xvHLd5Y3+Ut4epiu4GnmjYlsNDdnHTva5caeeGKW1QmRorpIHnVNzcO0pMS9BIyYfL9AyZ52QylT5ATqHGutlriz6IEs/x9DgNNVNgxsYwjyGmZYurP32cVvgzh8GGzqFT/HC3/Zstk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683100; c=relaxed/simple;
	bh=GeoYgmxpYgnLS3JA18z8N+vI45b1k0YLucTFsCJGvqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRu85Vf5VoNfS3FhqNZ2BDMAs4Qhu/0qfnzDfSUPKsrCpa950rk1eyLLYHZiQFLZXHohP3x/jlBmI/xdTZaW4wye5UMdXf+TNY1mz0O+GfjqE5cEYW+emmW37QVraTSikhsOnEXBZy/+h5H+/X56VcYcCM2uZTPNBX6ien6fOOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpmgF407; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpmgF407"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F73C32781;
	Thu,  6 Jun 2024 14:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683100;
	bh=GeoYgmxpYgnLS3JA18z8N+vI45b1k0YLucTFsCJGvqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpmgF40776z4CyxpJCRPro0Gp8mOfkC4G83laAyXSbcMNY5+TPznGcWegpn5H4ssh
	 8J7WTgOBrxXHjEVqE1qTpKLxdjwakbU9BfrIOexU5WDZWvoqbZo1OHs/hJWThhchv6
	 /iHUipXUwnLjuaCSvCbbBKELtTeujdXT6JZCPTaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 018/744] net: lan966x: remove debugfs directory in probe() error path
Date: Thu,  6 Jun 2024 15:54:50 +0200
Message-ID: <20240606131733.028526305@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1088,8 +1088,6 @@ static int lan966x_probe(struct platform
 	platform_set_drvdata(pdev, lan966x);
 	lan966x->dev = &pdev->dev;
 
-	lan966x->debugfs_root = debugfs_create_dir("lan966x", NULL);
-
 	if (!device_get_mac_address(&pdev->dev, mac_addr)) {
 		ether_addr_copy(lan966x->base_mac, mac_addr);
 	} else {
@@ -1180,6 +1178,8 @@ static int lan966x_probe(struct platform
 		return dev_err_probe(&pdev->dev, -ENODEV,
 				     "no ethernet-ports child found\n");
 
+	lan966x->debugfs_root = debugfs_create_dir("lan966x", NULL);
+
 	/* init switch */
 	lan966x_init(lan966x);
 	lan966x_stats_init(lan966x);
@@ -1258,6 +1258,8 @@ cleanup_ports:
 	destroy_workqueue(lan966x->stats_queue);
 	mutex_destroy(&lan966x->stats_lock);
 
+	debugfs_remove_recursive(lan966x->debugfs_root);
+
 	return err;
 }
 


