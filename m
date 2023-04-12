Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14962F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D7BC433D2;
	Wed, 12 Apr 2023 08:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288555;
	bh=Rq08TbII99Z6iYT+clEcAC1SLfJ6CcTvOB6Ok4dvmWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YagwZLdDXavonW8ciSRZRIR1T7VFIH/2qyKN3rfIX+uNeYW/61kmkhGvAj5yS2huH
	 QKojm2F8MoxAGHs4TE/pAuyRz3f2x4UQZgNMInPxvMJwyL4hv8kvCP8fR2shPgNxi/
	 UTcjUz4nYb01/OGcGjie3lOrE+H3fg39W2OzGgS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/93] soc: sifive: ccache: fix missing of_node_put() in sifive_ccache_init()
Date: Wed, 12 Apr 2023 10:33:08 +0200
Message-Id: <20230412082823.346117157@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8fbf94fea0b4e187ca9100936c5429f96b8a4e44 ]

The device_node pointer returned by of_find_matching_node() with
refcount incremented, when finish using it, the refcount need be
decreased.

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sifive/sifive_ccache.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
index 4b9d0a656a979..09914cb4f0284 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -209,12 +209,16 @@ static int __init sifive_ccache_init(void)
 	if (!np)
 		return -ENODEV;
 
-	if (of_address_to_resource(np, 0, &res))
-		return -ENODEV;
+	if (of_address_to_resource(np, 0, &res)) {
+		rc = -ENODEV;
+		goto err_node_put;
+	}
 
 	ccache_base = ioremap(res.start, resource_size(&res));
-	if (!ccache_base)
-		return -ENOMEM;
+	if (!ccache_base) {
+		rc = -ENOMEM;
+		goto err_node_put;
+	}
 
 	if (of_property_read_u32(np, "cache-level", &level)) {
 		rc = -ENOENT;
@@ -237,6 +241,7 @@ static int __init sifive_ccache_init(void)
 			goto err_free_irq;
 		}
 	}
+	of_node_put(np);
 
 	ccache_config_read();
 
@@ -253,6 +258,8 @@ static int __init sifive_ccache_init(void)
 		free_irq(g_irq[i], NULL);
 err_unmap:
 	iounmap(ccache_base);
+err_node_put:
+	of_node_put(np);
 	return rc;
 }
 
-- 
2.39.2



