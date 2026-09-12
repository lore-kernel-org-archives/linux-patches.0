Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BF432D43C;
	Sat, 12 Sep 2026 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231684; cv=none; b=VZmRYmV/kFe4AufjvaE4TDtyIyIMBICi+xdzUZt/LvtP77cOQRbG9qIJfyWByz5cU07xJwcfNS3z/9YJYukBDVRW7RTZLCZU0FhzWGPpYRlVDhcf3fHADLIfPESkWw7vMhgghLSckfu91ua7FfpjN9GfeRRZla09+uiGrNsuy7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231684; c=relaxed/simple;
	bh=mF6gdPpvFM/uIW2lfP9v1h9vvdXiSboRO21WnoORMiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+xQqm7hEyXvRXBxThn1d/81Lcbg/yF5LeApJtFB/6E7jQCa2Mpybf9UoZ5oL0aAm97MSojXAZyCmhXkERtIPoP5sQbG2KC+zkq5mT0oHeFdlQLBB4UPxG8hAOLE9kLZWzoSw2V5wtSy70UXGJc1e+uDtB3/fnGorwR+iQyOS/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6A5cLXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6A5cLXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1201F000FF;
	Sat, 12 Sep 2026 16:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231682;
	bh=SN45Kb39EdgFFfNO15fdm42nCD3nmAtlUkinRl8KERA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6A5cLXACr6osNR8vB2/rqQa9vi/79dxiQo5nSFq3/qFTuuNC/cQrNrTZ2BofHsFf
	 Q6D/thpuwbDP2xWMM8AqZ7Kb3ErVJIzHgr/kM4VgBJ9IlTbqYvmpzgZLFH3KsnEn1a
	 N7n+jsm0UmS9hQwcBfAOWh6CFkVBOkyIAlyOztlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1048/1191] net: hsr: Use full string description when opening HSR network device
Date: Sat, 12 Sep 2026 09:02:56 +0200
Message-ID: <20260912065611.715049576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b34a9b680aab3..e66d5b6b7db4a 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -139,30 +139,29 @@ static int hsr_dev_open(struct net_device *dev)
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



