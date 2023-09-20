Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248EBE544
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C771C433C7;
	Wed, 20 Sep 2023 12:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211437;
	bh=j+x4Sm6O97bGUQAXVHdiKQvdOBRYcC5fITlQ1uop+tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aB1aSvuvgYLeo6virwITUcAMyLmKaQK1LxIljJ2HtkUQ8hCE59MGPACPRafu0WaPI
	 +jyGgq6EX2cGvMRqJo/+QgPd0yGa7z21WYbBRcswl9lnnE7TkH8/P8T1RRrnfZ+Oy+
	 m3rZ0YnEnnCNOYBPrw1Uyovtk43uUeFUbNy8+b/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 092/186] amba: bus: fix refcount leak
Date: Wed, 20 Sep 2023 13:29:55 +0200
Message-ID: <20230920112840.251540450@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit e312cbdc11305568554a9e18a2ea5c2492c183f3 ]

commit 5de1540b7bc4 ("drivers/amba: create devices from device tree")
increases the refcount of of_node, but not releases it in
amba_device_release, so there is refcount leak. By using of_node_put
to avoid refcount leak.

Fixes: 5de1540b7bc4 ("drivers/amba: create devices from device tree")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230821023928.3324283-1-peng.fan@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/amba/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 8ea401fc89968..e07d6a4d3f03a 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -344,6 +344,7 @@ static void amba_device_release(struct device *dev)
 {
 	struct amba_device *d = to_amba_device(dev);
 
+	of_node_put(d->dev.of_node);
 	if (d->res.parent)
 		release_resource(&d->res);
 	kfree(d);
-- 
2.40.1



