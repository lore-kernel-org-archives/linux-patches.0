Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5606C47CC62;
	Sat, 28 Feb 2026 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301309; cv=none; b=QjxxfalDgcK9lwDltlfCFn595TfxwWoTxZrkBPzTRc5S3ws2nM/WSARLkZhWtyPSvZx3beGMDbCskrBPt+2Kp2PiaiBPjVQdFyalMXEHpXry18yJ6Q9SvdVTcLJLM0wdpsmizRQp3TlDM8YpACy+Aa4VTVLcx8lq79BdGnTkka0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301309; c=relaxed/simple;
	bh=jVAGHU9MsljkJMXVer6SXYH4Vq7rqfsrTM50qaL2KMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8G3irVKbhNu+qOcuIxifI5H+ZYkgb/RoDBRJGH/KCBN0cOyT5OUzAyz1YanLaNFXExTA4cO5A2POmFvKmvrBul/ijHhGP9dNaL9SoqwKUqKgQpx5Qy+FGRp+X0j9JOyDolRj6iuWU+dxz+CwHWtVwSPozPHdswO8W7JP6YzkV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=flpVb2Jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="flpVb2Jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E902C116D0;
	Sat, 28 Feb 2026 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301309;
	bh=jVAGHU9MsljkJMXVer6SXYH4Vq7rqfsrTM50qaL2KMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flpVb2Jr8EwO+FBTDDvqVTxa+AVQcVkwHIJ/IjZFzsDJaGIjPrNnBc03hoxeAHoBm
	 KgxBrBV5ggskUG59aWbIPxBmYP9OilSCy0V9wMwMqTx6Xv6pW0cFXtLrE/gAaHxegk
	 qVrbX9KlH38jpUZ3ByvNiGTaMn0hj0LcENJWtDbIwrwTkSmnpgEzryfppxbWpFfCqs
	 0qWWpcP/7XvHR1bIT/H94nwr6lNkagyFmFl8nOZpmVmo9h56a/lZHOcFMwaa8QVurm
	 pjpneb7lUagSeIF11Jyp9ceSf62ivmRxvG52wM/9HASWnZu1LT7sKtX4sNxWleWHcF
	 z/lKs17Ao354A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 494/752] ARM: omap2: Fix reference count leaks in omap_control_init()
Date: Sat, 28 Feb 2026 12:43:25 -0500
Message-ID: <20260228174750.1542406-494-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 93a04ab480c8bbcb7d9004be139c538c8a0c1bc8 ]

The of_get_child_by_name() function increments the reference count
of child nodes, causing multiple reference leaks in omap_control_init():

1. scm_conf node never released in normal/error paths
2. clocks node leak when checking existence
3. Missing scm_conf release before np in error paths

Fix these leaks by adding proper of_node_put() calls and separate error
handling.

Fixes: e5b635742e98 ("ARM: OMAP2+: control: add syscon support for register accesses")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20251217142122.1861292-1-vulab@iscas.ac.cn
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/control.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
index 79860b23030de..eb6fc7c61b6e0 100644
--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -732,7 +732,7 @@ int __init omap2_control_base_init(void)
  */
 int __init omap_control_init(void)
 {
-	struct device_node *np, *scm_conf;
+	struct device_node *np, *scm_conf, *clocks_node;
 	const struct of_device_id *match;
 	const struct omap_prcm_init_data *data;
 	int ret;
@@ -753,16 +753,19 @@ int __init omap_control_init(void)
 
 			if (IS_ERR(syscon)) {
 				ret = PTR_ERR(syscon);
-				goto of_node_put;
+				goto err_put_scm_conf;
 			}
 
-			if (of_get_child_by_name(scm_conf, "clocks")) {
+			clocks_node = of_get_child_by_name(scm_conf, "clocks");
+			if (clocks_node) {
+				of_node_put(clocks_node);
 				ret = omap2_clk_provider_init(scm_conf,
 							      data->index,
 							      syscon, NULL);
 				if (ret)
-					goto of_node_put;
+					goto err_put_scm_conf;
 			}
+			of_node_put(scm_conf);
 		} else {
 			/* No scm_conf found, direct access */
 			ret = omap2_clk_provider_init(np, data->index, NULL,
@@ -780,6 +783,9 @@ int __init omap_control_init(void)
 
 	return 0;
 
+err_put_scm_conf:
+	if (scm_conf)
+		of_node_put(scm_conf);
 of_node_put:
 	of_node_put(np);
 	return ret;
-- 
2.51.0

