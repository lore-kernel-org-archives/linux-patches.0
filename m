Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B707D1459F8;
	Thu, 13 Jun 2024 12:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281186; cv=none; b=XTZvIla6AvLs2Wgr2VCAKSpFbguMkMNkOsnoAGa1yzFZ70rse7GsJ8S0UR9nQRpb3xDYYD80aBGCre24l4TsGTUG73sWBnnO8/Ayb0wvhRBnRJbkCUgz326PZTRKmRllMi/b9byihh8mbUrLdbs1QwUL17sfkfwbRbu9SXk9W7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281186; c=relaxed/simple;
	bh=CMr9atO26fLQ+yRAAXlYNtmwcHWYulz8zuUkEc9hF2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hiuzJZfquIgXZUa7aWGgzhRsTeRBPKK3EB4JLqCo0pXdJxh7BlEQgOs0DY5cnfsBEMBCyfawwN6Ktdg5bpEmohLeIJRT9Y3Zrj2w0wHbNIzuk1xph5zgoxsN6xY9L0m4tr9GdSROelKBCL8KfKUI6hxNLmrhjQRpohk7A+jsd1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+x4V2s5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+x4V2s5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFA0C2BBFC;
	Thu, 13 Jun 2024 12:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281186;
	bh=CMr9atO26fLQ+yRAAXlYNtmwcHWYulz8zuUkEc9hF2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+x4V2s5xeA32eIPUerHeESjwzynsywzAO9CLZSR9y4rr7y4A6X2aHU6RPuaOnhj5
	 lFiCLznWuSVJWxz1eV2uhryrFbkpNhre8wJFUr3jFJk2+mRLujybypuhB9IadyEp8G
	 4t0n/Aj3bc8L5SIPw7YF6EiPdOK6XqV+js1w/scA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/317] RDMA/IPoIB: Fix format truncation compilation errors
Date: Thu, 13 Jun 2024 13:32:27 +0200
Message-ID: <20240613113252.549399871@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4c50a87ed7cc2..15a7cda44676c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -185,8 +185,12 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 
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



