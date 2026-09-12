Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791B030ACF6;
	Sat, 12 Sep 2026 15:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225792; cv=none; b=cDbOapq4P3tXUTeUqHiI/ahl3mKO6sm67kmtOTqyQ5n2lvN7rCc9r/n9iORjMgvZuoZkvFkAQwjTUC1FtoCcJ7JNpjl1G/16qaIfOEF+SF1lb4uqBVh5LF4IHJCsAHDVci+GbAFWzc66Ar7x5HyN7rekBnScaLgMsZUTUqy0eUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225792; c=relaxed/simple;
	bh=kA7/9szwOcOf3pS5eL9Z3twisTt4JwWRPuVI5XK8bog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiWxqKkbRGkKNV4vvi+63JlCzV/5JFh79Uvh/AyXXoiBd5PDaBTl7ZwF5HeoVVpsurjSBnSTB5DaGxPmgKcErsqKCBdOOU7pESj7UnAplPeSVOmBUpDWGuYp739sDz/SXLAP6rIsQ7e5TrDAcdOfGdm1qdI3/xuFbEIQ/gSWuyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Viq1KvyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Viq1KvyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992AF1F00893;
	Sat, 12 Sep 2026 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225788;
	bh=DaAfisoWlmgCB6B5U4peTABG3wUka3tM71+vo9SOJ9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Viq1KvyNXznvUyE3ChcCb5ZD+IJsmsgejxC2hNebcBl9GMFzSZ9ufUMgVc1qo1t7O
	 wyzLDVdmWxtvQnfTbNSZ8ojJAwLLH8vDTuFeywLI1g3f7yWHftp5xh1IIN4Fo43+Zk
	 RoFQxRAilP5re3r3czj44ePUKz9vjirbKcEaWBts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1267/1424] net: hsr: Use full string description when opening HSR network device
Date: Sat, 12 Sep 2026 09:01:39 +0200
Message-ID: <20260912065635.653070884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



