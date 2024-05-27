Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC0815FCE0;
	Mon, 27 May 2024 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836363; cv=none; b=a+exYzrxlawRt4qrDdxgme6BFmFV/RhQS10dJEV77sdn6m2uLsMuuX03WR+DtXEQKcqvR5S9EPH5qanfjH2/pGjqiDJC1wnxd5ffYFP29ZEeCpPVzJ6W0ANJM8B3VFoFdxbFk38fkI8lTN/v4KziVZh8SB/9zImU9XfO0Y/gazE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836363; c=relaxed/simple;
	bh=+aFhLaNV95jiz7Fwzadz0LqREk4hPsoIOnn6hJv9GVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIRCLlEnAdTqFYZ8/H8iW3RME45aS0SGM8WaygorUlZPZXm63AbgiF0vsrRDL6CxMiSbKYwAxIz4QWlKR6a7cg0Yx+54Ndf4LxyTO5jLAlz1Pd8tdokmIjXDwAIiAt1AMJHUVJRf9vMNg+FIDykNz8mDlq2urfC9QwqHbp+kKBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmSksEGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmSksEGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECFAC2BBFC;
	Mon, 27 May 2024 18:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836362;
	bh=+aFhLaNV95jiz7Fwzadz0LqREk4hPsoIOnn6hJv9GVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmSksEGEmxpzXquDH0hsTokV65ERm59iqsR4ToZxrzBcuzVueO53f3OaIF6vIdYXw
	 6ksmT6QF1Cxj9PhYx+JoaZgt0DHyDSyD84K/07FtxI0RWxc55IVyZmSIIcwbjYzXwR
	 aedi6EWIukfcjhsIH+mBQ6CIprsevRJ0bAu6yH9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.9 024/427] net: lan966x: remove debugfs directory in probe() error path
Date: Mon, 27 May 2024 20:51:11 +0200
Message-ID: <20240527185603.958233998@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 


