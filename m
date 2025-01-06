Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C01E1DE89A;
	Mon,  6 Jan 2025 15:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178570; cv=none; b=nJ0ecqsp0yeAO9vnK2vDKu5Fur4vyWoaXakQ9zRbQVWfKawTZVIZ2Ug6yTCyzxd6bEKf/wi4G2B0E2jtv7halY0ahDUBEBCMQFf1Yyh06VPRUr/M/BV3uXgJXi9clFYQEu4lYiW+BMGsBE9imgo/hrrpCLxKVHfWXzaAoxacmHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178570; c=relaxed/simple;
	bh=+J2XKdDEZFL/0HYTZS5pTesN1SsC1uCHxMPlYTLFy6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eh2AaxaeXkHumazBRHOazmwxIfx61KnNGmSdxLbkYROh84p/XZ9MsuDkYbVTRMoZarRgAzygdvWArFXsACCDMXBQgDWIwO2UDuS3hrL56YietOys1MEwTAPnZiFQw4CnLA4YWg5ecXT6d60gfaCWeB+QdWkjVAUz3ay/7/5MQvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIePKHg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIePKHg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CC9C4CED6;
	Mon,  6 Jan 2025 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178570;
	bh=+J2XKdDEZFL/0HYTZS5pTesN1SsC1uCHxMPlYTLFy6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIePKHg7IkAFpRLeyZp81qT2Qclc/inKVSCT2Dn+uql1C5c6V1SRu5GXzpjExQnGC
	 mCBsA25dhqL/Io5tr6yyNm3JjVuJzgCFlFJTb1wZ4BKIeI0X5P54kIIci8Z3BFSe6q
	 pzePa9cNP639BeAeU40yIcAxgyxvFN4vcbU1dlc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/168] net: mdiobus: fix an OF node reference leak
Date: Mon,  6 Jan 2025 16:15:31 +0100
Message-ID: <20250106151139.339229311@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 572af9f284669d31d9175122bbef9bc62cea8ded ]

fwnode_find_mii_timestamper() calls of_parse_phandle_with_fixed_args()
but does not decrement the refcount of the obtained OF node. Add an
of_node_put() call before returning from the function.

This bug was detected by an experimental static analysis tool that I am
developing.

Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241218035106.1436405-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/fwnode_mdio.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 2c47efdae73b..92f931fc903e 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -17,6 +17,7 @@ MODULE_LICENSE("GPL");
 static struct mii_timestamper *
 fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 {
+	struct mii_timestamper *mii_ts;
 	struct of_phandle_args arg;
 	int err;
 
@@ -30,10 +31,16 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 	else if (err)
 		return ERR_PTR(err);
 
-	if (arg.args_count != 1)
-		return ERR_PTR(-EINVAL);
+	if (arg.args_count != 1) {
+		mii_ts = ERR_PTR(-EINVAL);
+		goto put_node;
+	}
+
+	mii_ts = register_mii_timestamper(arg.np, arg.args[0]);
 
-	return register_mii_timestamper(arg.np, arg.args[0]);
+put_node:
+	of_node_put(arg.np);
+	return mii_ts;
 }
 
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
-- 
2.39.5



