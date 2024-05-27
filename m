Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D37C1863F;
	Mon, 27 May 2024 19:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837408; cv=none; b=q0eRKLCZHtMv2LhjKVswYV4jhTHXbG9QPIJ5r+S7pzbMun+kJJhqEWdOxsSR642bMCPlekZrpiL+guSBLWdp9NNEo5BMZ0dbbcWSHDbkHRvN2sAWBg9FmX440LhF10hJZjzzJGpHBhEJA9Z5ALzBeYgYfBS/4Yu2VDJPZBRn06k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837408; c=relaxed/simple;
	bh=AllN4PymFLFzPbYi7cV97hTl4LQdJC5JQ1lKOtKykXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NyJHe9D8cw/wlnf96AuTLS4wfbSedlRsF5qKATn6PvszNXUoNwxEyhbMSX8V8GUxa6xGxXVQzgOGljijSACMk+oSJHJJgKPFJKTS4/MDyNbX7gjYldo8S4fsOxVQLG/b06BqJbQ8fRM5DtqH9frKfoOjRSSDtsSkGMTN5BfxEZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkpEPnkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkpEPnkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D2BC2BBFC;
	Mon, 27 May 2024 19:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837408;
	bh=AllN4PymFLFzPbYi7cV97hTl4LQdJC5JQ1lKOtKykXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkpEPnkZEVu+y2gEDM+4jAftazo49l25dGiiXvEpVnQvSDLcEFFMXAwbGkXvuPTEO
	 xb3Ox+7Czp5Pb1Az7DdP+aj/ZYSGkdiI6sPnV7NE8aZIg3NQ3C9GZkSQQH6m+NcfIq
	 OAjMc0rSdn7CqQDkeUw/Jl2ngiaArTR9YUuU+Nt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 406/427] RDMA/IPoIB: Fix format truncation compilation errors
Date: Mon, 27 May 2024 20:57:33 +0200
Message-ID: <20240527185635.282014471@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

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



