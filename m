Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D0F3A16B6;
	Sat, 12 Sep 2026 20:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243368; cv=none; b=eap1dX6330CGiWiqRo3CarYCIlaKkpPwn/hH6jeBuDuGYY61ySHiTFv31OdLLHtY4dKHzsuzQQ3gtCIdUY0gBQF9YJysj3v3ba86naksgRIXmwRBM+LQG/ujvUaGPzwo7TtSSORF0V7aZVCZTQolC5MRhVTsCyx2/HmiUkyFll8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243368; c=relaxed/simple;
	bh=cLy6WQMIdLOCLjdponsdiSQNAgj8cia6VEDbqfI3uT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLQ+OUISUFSdtbYFOsQfTQTEp8FSRw45wkXmUzvyIyNTqP7kpaVmGxjemJS8UabFTC5XY+AmpTkVONaoNMXvLdHR6JKnIHkn4Ou5e4+Y+frie46s1CtII4s/tT9MvUANHgNU4bQvaUfDWWdXENHQqHHjXxchQXRwFOZNjg1dBow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gka1l+oJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gka1l+oJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B501F000FF;
	Sat, 12 Sep 2026 20:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243362;
	bh=aKoNQCDd8rKqdMOnKML0um5nlOUpGsRgpUo0iTI+jqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gka1l+oJzs1nJPbkXxLSSbuQsSd0TbJS8a65cUXj9ts6LUdn5ko+w6jj8YSETLyU5
	 ci/o+DsGmORQVP06f3NKdQJZnNDipDR7aRhereIsymLAF85IJxJ83ByMSj5Lwrc+WS
	 WGOzmXQMseS64KTvaTILd30DZlRRj2C4JDuRDDQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 728/798] net: hsr: Use full string description when opening HSR network device
Date: Sat, 12 Sep 2026 09:05:56 +0200
Message-ID: <20260912065533.765583296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit 10e52ad5ced2a7dcdb3fb18c9cef111d5f30471d ]

Up till now only single character ('A' or 'B') was used to provide
information of HSR slave network device status.

As it is also possible and valid, that Interlink network device may
be supported as well, the description must be more verbose. As a result
the full string description is now used.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7f16289b91eb ("net: hsr: free learned nodes on device setup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 1a6f528399610..1b647ce48dc10 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -142,30 +142,29 @@ static int hsr_dev_open(struct net_device *dev)
 {
 	struct hsr_priv *hsr;
 	struct hsr_port *port;
-	char designation;
+	const char *designation = NULL;
 
 	hsr = netdev_priv(dev);
-	designation = '\0';
 
 	hsr_for_each_port(hsr, port) {
 		if (port->type == HSR_PT_MASTER)
 			continue;
 		switch (port->type) {
 		case HSR_PT_SLAVE_A:
-			designation = 'A';
+			designation = "Slave A";
 			break;
 		case HSR_PT_SLAVE_B:
-			designation = 'B';
+			designation = "Slave B";
 			break;
 		default:
-			designation = '?';
+			designation = "Unknown";
 		}
 		if (!is_slave_up(port->dev))
-			netdev_warn(dev, "Slave %c (%s) is not up; please bring it up to get a fully working HSR network\n",
+			netdev_warn(dev, "%s (%s) is not up; please bring it up to get a fully working HSR network\n",
 				    designation, port->dev->name);
 	}
 
-	if (designation == '\0')
+	if (!designation)
 		netdev_warn(dev, "No slave devices configured\n");
 
 	return 0;
-- 
2.53.0



