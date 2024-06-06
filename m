Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C27219CCF9;
	Thu,  6 Jun 2024 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683430; cv=none; b=DLbq634p2Obe6gUch9MufQuY3jI0cgQ0sJtMeHr5syck7BZhipc9WwFqfm2WfN/x1Ip00VsOM5kP2gg+QIJJAqUCHufu1hbQxmseEpOJNGChoDVrr5mezPeKtReMODNVRGY+LzEj1S/bBh0iYr8pFbRkxuyc3ydzwI1Uouv5VJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683430; c=relaxed/simple;
	bh=P1+iGhauiYVBbvpqVycRvibLOvnzmh/ZxkJGMfV0ZGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PaFAgJfkPpt15ZBm/if7QBtalh6P2l3vlMztt6WDs1LryENDPhqW1IBTuTzvyV46lUKZfYtO125sfqOexaC4XXs18RagORMo6wyRK2x8Sp0G8sYTzavYMOi2DGrygUf1vy7qEmvkMLsInLo+d3t9qmw8s0EEZfjE0afhO6cgDOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOpeIrNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOpeIrNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB00C32781;
	Thu,  6 Jun 2024 14:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683430;
	bh=P1+iGhauiYVBbvpqVycRvibLOvnzmh/ZxkJGMfV0ZGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOpeIrNP+9orI5uFdGKZIL8VW6SRtTDXl5lAp7P7xzdj54tcMSZ3wsgifGmj7DbPy
	 zPpoyhPRf7RuaDIXJftljHxUMKL18BiTuf0Tw8YRqATguN4GGUjeVGtj3YMjSynwg+
	 kC1ZpKCIrSGtoKGfb0yR8W0GIQpy+y4ugCibU/L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 375/744] RDMA/IPoIB: Fix format truncation compilation errors
Date: Thu,  6 Jun 2024 16:00:47 +0200
Message-ID: <20240606131744.507043210@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 49ca2b2ef3d003402584c68ae7b3055ba72e750a ]

Truncate the device name to store IPoIB VLAN name.

[leonro@5b4e8fba4ddd kernel]$ make -s -j 20 allmodconfig
[leonro@5b4e8fba4ddd kernel]$ make -s -j 20 W=1 drivers/infiniband/ulp/ipoib/
drivers/infiniband/ulp/ipoib/ipoib_vlan.c: In function ‘ipoib_vlan_add’:
drivers/infiniband/ulp/ipoib/ipoib_vlan.c:187:52: error: ‘%04x’
directive output may be truncated writing 4 bytes into a region of size
between 0 and 15 [-Werror=format-truncation=]
  187 |         snprintf(intf_name, sizeof(intf_name), "%s.%04x",
      |                                                    ^~~~
drivers/infiniband/ulp/ipoib/ipoib_vlan.c:187:48: note: directive
argument in the range [0, 65535]
  187 |         snprintf(intf_name, sizeof(intf_name), "%s.%04x",
      |                                                ^~~~~~~~~
drivers/infiniband/ulp/ipoib/ipoib_vlan.c:187:9: note: ‘snprintf’ output
between 6 and 21 bytes into a destination of size 16
  187 |         snprintf(intf_name, sizeof(intf_name), "%s.%04x",
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  188 |                  ppriv->dev->name, pkey);
      |                  ~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[6]: *** [scripts/Makefile.build:244: drivers/infiniband/ulp/ipoib/ipoib_vlan.o] Error 1
make[6]: *** Waiting for unfinished jobs....

Fixes: 9baa0b036410 ("IB/ipoib: Add rtnl_link_ops support")
Link: https://lore.kernel.org/r/e9d3e1fef69df4c9beaf402cc3ac342bad680791.1715240029.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 4bd161e86f8dd..562df2b3ef187 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -184,8 +184,12 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 
 	ppriv = ipoib_priv(pdev);
 
-	snprintf(intf_name, sizeof(intf_name), "%s.%04x",
-		 ppriv->dev->name, pkey);
+	/* If you increase IFNAMSIZ, update snprintf below
+	 * to allow longer names.
+	 */
+	BUILD_BUG_ON(IFNAMSIZ != 16);
+	snprintf(intf_name, sizeof(intf_name), "%.10s.%04x", ppriv->dev->name,
+		 pkey);
 
 	ndev = ipoib_intf_alloc(ppriv->ca, ppriv->port, intf_name);
 	if (IS_ERR(ndev)) {
-- 
2.43.0



