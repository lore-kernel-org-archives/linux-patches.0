Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B44492525;
	Sat, 12 Sep 2026 19:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240326; cv=none; b=eQ1W+1dl1kIm6k5RqYw+a2GLqBbaPTIJPikh7MO5oWqom8rRolymlhvVy8QZwHTqNxw671lN7OgzyD/RX25+xDrMdOg/39BwWCLQejUHJDIb+NInWtGFdWzXahJlk5Q7l2TOTv6dFIOKHwiBPBo72UfdSLXxJES6ROhKav1KYzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240326; c=relaxed/simple;
	bh=tlqzpKG+u17UZPUE75EF79Th/1F/VApwyx53UKLl68M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LP4PQ7DEQHqaJM23k5b5r7iBfLAuzaJXbaUaWBFIG2us3z3v2w/bpOs+smWEsvKhmlJfybKNQ4trA7I7TkqPZTTXM255kFLYdWUTiTkITC6lootoCjlDkYBEruXPOM395xi3cN38DRfhEYOIYTmg3Lq3SrRnIJmsppCJem29we4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rmE4d2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rmE4d2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1351E1F000FF;
	Sat, 12 Sep 2026 19:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240323;
	bh=YZntjMAYZTliUlWL7CvVJcaTDSvPYuYJ1/kencCuWSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2rmE4d2dnFW57C16tdASvQk+YM3cQG8wPMj6oWvw50fuZEVfC3navIKsYliJ3+Lzh
	 vii1y53CiJdL4+O3bb2c+Da48q6Q/9RwrnPgIPAgdxHLL1gOUJd4KCMfHVYzFBh8nl
	 IDM23c4hFXeKORs9XKGAARTKagliyyA1bI2qZHes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 844/935] net: hsr: Use full string description when opening HSR network device
Date: Sat, 12 Sep 2026 09:04:34 +0200
Message-ID: <20260912065546.184985467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 93ccd67717cb1..646d28c85366b 100644
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
 
 	hsr_for_each_port_rtnl(hsr, port) {
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



