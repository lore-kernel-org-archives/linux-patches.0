Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FE53F8EA7;
	Wed, 20 May 2026 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296586; cv=none; b=hVY44Qf87FEGP9w0GhzLDi3p0TOOzM2OsgcSWPZuNrMAF6244qG6wn99i1l2jl32rt94/yzKCq/Qlv4DjS5HO+YJUpdRrYQURCKK3aaUVqWRuKZKVGToGXeFeBdTHYjlUX350HeruvynRy4KWfOZ8Ot36WKJ/1CmDO0Kd8xSfAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296586; c=relaxed/simple;
	bh=kj5EESWoKw/EV7XKFwA4SlX0kRCJgR/V91nJw8nk1M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7j7ChrRDpYqxq6+yt7GmyEm4is4iSTON7VUOcrxF27pB5es+AaVo2yM5gIf1ZzZyQe2j7OxOWjXtaJ2MZ0ymP0ZTE7WHtzkBcZR6XooZbx4XIpAu8mdMbBSX3DyudlyCmGzr1wOU9hLr63nAKKC6dTkSOaIWTaiNGhcFFEctFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNXCsPyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNXCsPyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB411F00894;
	Wed, 20 May 2026 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296582;
	bh=3kpA4HnR/pc5Kl5l4jh5eMZiQ8KogBP2DzDKV/zijkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNXCsPyRO0xd88umnROpENeXS4cFxyDYNxqqeVY5Dw7wXZROmsXFsJ8p302XL6Cco
	 A9xAUkoMidlztfeUZmhUzdU1CRWLgVEINvsG3BfMPuwGUAJ/6VEK0yl/RTmAmDiSZQ
	 bVaNIEiawEj/dSI1pAKc/Fsdg/nGfDrQHe5gu6k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0853/1146] net: mana: Dont overwrite port probe error with add_adev result
Date: Wed, 20 May 2026 18:18:23 +0200
Message-ID: <20260520162207.543350661@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit a7fdaf069bd031fcc234581fa6a580be11bf2175 ]

In mana_probe(), if mana_probe_port() fails for any port, the error
is stored in 'err' and the loop breaks. However, the subsequent
unconditional 'err = add_adev(gd, "eth")' overwrites this error.
If add_adev() succeeds, mana_probe() returns success despite ports
being left in a partially initialized state (ac->ports[i] == NULL).

Only call add_adev() when there is no prior error, so the probe
correctly fails and triggers mana_remove() cleanup.

Fixes: a69839d4327d ("net: mana: Add support for auxiliary device")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260420124741.1056179-5-ernis@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index e5b4f07e009bf..09d67617dfbbf 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3643,10 +3643,9 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 	if (!resuming) {
 		for (i = 0; i < ac->num_ports; i++) {
 			err = mana_probe_port(ac, i, &ac->ports[i]);
-			/* we log the port for which the probe failed and stop
-			 * probes for subsequent ports.
-			 * Note that we keep running ports, for which the probes
-			 * were successful, unless add_adev fails too
+			/* Log the port for which the probe failed, stop probing
+			 * subsequent ports, and skip add_adev.
+			 * mana_remove() will clean up already-probed ports.
 			 */
 			if (err) {
 				dev_err(dev, "Probe Failed for port %d\n", i);
@@ -3660,10 +3659,9 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 			enable_work(&apc->queue_reset_work);
 			err = mana_attach(ac->ports[i]);
 			rtnl_unlock();
-			/* we log the port for which the attach failed and stop
-			 * attach for subsequent ports
-			 * Note that we keep running ports, for which the attach
-			 * were successful, unless add_adev fails too
+			/* Log the port for which the attach failed, stop
+			 * attaching subsequent ports, and skip add_adev.
+			 * mana_remove() will clean up already-attached ports.
 			 */
 			if (err) {
 				dev_err(dev, "Attach Failed for port %d\n", i);
@@ -3672,7 +3670,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 		}
 	}
 
-	err = add_adev(gd, "eth");
+	if (!err)
+		err = add_adev(gd, "eth");
 
 	schedule_delayed_work(&ac->gf_stats_work, MANA_GF_STATS_PERIOD);
 
-- 
2.53.0



