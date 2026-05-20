Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7A0233933;
	Wed, 20 May 2026 17:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299399; cv=none; b=XEUI8njeOydmEyk+ntmb3nAK/bWyVDRHvyjRdpZgl1WuXaYureDL3ymZYpuLO4tsRVWDiB9A3MFZtWO7IagnHe7pG8/PnhpiXEvOOTVdBZMrm8cHJwHZR9U0jV9Udj8UaquR2nE5BZ3ZJnvWNnEYzYmA2IDaSiLVANVP6SY/Two=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299399; c=relaxed/simple;
	bh=0c6M/HHYsquqVco3SATY95lpqGJFW270kw98kflOmVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R137GEbds1WCAQNoE5eDrm//VEQy2SyoCVDHgUTZMoNh8ZlcCcmTvwCFgxD2SWVXiP7eOk7SAjlJ1jMu0xkOrgBrsXaDtlMIEVV1eZCK7DZEV+TgtR1udIB5LJWcn5HHhaMOp/r+O+lNJkT5nCq7CSgrGuBHCRT6yFbN0L1gdzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xE5yOgpO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xE5yOgpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EF31F000E9;
	Wed, 20 May 2026 17:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299397;
	bh=cwC3w1bvqEZwTmza7399N1adMBUeu5v77ky39beauRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xE5yOgpOv0uNeBWmOn8ZzOE3IJNQlOh+tCI2tj+Ue5S99jI5cT+H88ZfiaEuBSyN3
	 LfG943fO1CppJO2dg9nH7RsKn6Ffur/ALqoPQsukajx7po9LeweC+mvBBzgn7KiIDI
	 IG2t8zc3fN0n80tMJCD4Vx+f9UINA82jl5YKcp4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 705/957] net: mana: Dont overwrite port probe error with add_adev result
Date: Wed, 20 May 2026 18:19:48 +0200
Message-ID: <20260520162149.828577764@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b0d411ab1067f..02090edbd103f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3548,10 +3548,9 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
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
@@ -3563,10 +3562,9 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 			rtnl_lock();
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
@@ -3575,7 +3573,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 		}
 	}
 
-	err = add_adev(gd, "eth");
+	if (!err)
+		err = add_adev(gd, "eth");
 
 	INIT_DELAYED_WORK(&ac->gf_stats_work, mana_gf_stats_work_handler);
 	schedule_delayed_work(&ac->gf_stats_work, MANA_GF_STATS_PERIOD);
-- 
2.53.0



