Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC27A2DECDF;
	Tue, 21 Jul 2026 18:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658031; cv=none; b=pyH44AeAOR3T4bsZkr8VllP+yonfTjCf4IS5vWX8Qzd6mEJ3LsAQdiW8XW78fS3be3I+ph+USjq7TMjgB/xc8FYDHFaoR4rqOaztwBXZ+WKIAb58475GwWbcpc+y6ziag/5jqjeu0gJaQq+a/RJKXbILJNY4BHGTWv6h8uqV/uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658031; c=relaxed/simple;
	bh=qAu1gHEIWpvid9YMO1x3ZMYSrjBEma3a4Qq6ncu1pZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUpDDnmEs/XM/HUrChyT9PMxFpam+H8o92Hs0daDN7zddDhkSX2gif9re5Q/hGinPVsZzBQJ6awQKGGhsU83HU53AquWQgblxDErwshHasHG4RlzHMLa7VbaKRDHxzZF/v8bappghuQgTv8+61ZBrkkMCqruPWqhtaf4jxn0Rh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIS4rnUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIS4rnUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE33C1F000E9;
	Tue, 21 Jul 2026 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658029;
	bh=yanbsD5dIOh3X0uRs1Ix9ZC6k0gqkfi97qivbTfEGm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIS4rnUI85bbNyj4k3x1BDOOf2ZQCCtwQ2e8JGrz9I42ciQeBegj/srvNhQWlYkLA
	 4+i0dekjD9zXh/FHWEsOcuNdnODskis3sIxWdfcbI3PvP5+59xV6LBqdQ1y9zQz+ia
	 yjnK3e11p1qtiFXYyrwEX9LuVzvOuOfgmTYjooQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0990/1611] selftests: drv-net: tso: dont touch dangerous feature bits
Date: Tue, 21 Jul 2026 17:18:26 +0200
Message-ID: <20260721152537.660297264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2f7f2e311106cb838d3f3fb6ef25effdb3f8e366 ]

query_nic_features() detects which offloads depend on tx-gso-partial
by enabling everything, turning tx-gso-partial off, and seeing which
active features drop out. Enabling all hw features is dangerous:
we may end up enabling rx-fcs and loopback for example. For the
ice driver we end up getting into problems with feature dependencies
so the cleanup isn't successful either, and the test exits with
rx-fcs and loopback enabled.

Scope the feature probing just to segmentation bits.

Fixes: 266b835e5e84 ("selftests: drv-net: tso: enable test cases based on hw_features")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20260629233923.2151144-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/tso.py | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/tso.py b/tools/testing/selftests/drivers/net/hw/tso.py
index 0998e68ebaf038..061259057fb83a 100755
--- a/tools/testing/selftests/drivers/net/hw/tso.py
+++ b/tools/testing/selftests/drivers/net/hw/tso.py
@@ -184,28 +184,24 @@ def query_nic_features(cfg) -> None:
         cfg.wanted_features.add(f["name"])
 
     cfg.hw_features = set()
-    hw_all_features_cmd = ""
     for f in features["hw"]["bits"]["bit"]:
         if f.get("value", False):
-            feature = f["name"]
-            cfg.hw_features.add(feature)
-            hw_all_features_cmd += f" {feature} on"
-    try:
-        ethtool(f"-K {cfg.ifname} {hw_all_features_cmd}")
-    except Exception as e:
-        ksft_pr(f"WARNING: failure enabling all hw features: {e}")
-        ksft_pr("partial gso feature detection may be impacted")
+            cfg.hw_features.add(f["name"])
 
     # Check which features are supported via GSO partial
     cfg.partial_features = set()
     if 'tx-gso-partial' in cfg.hw_features:
+        seg_features = {f for f in cfg.hw_features if "segmentation" in f}
+        ethtool(f"-K {cfg.ifname} " +
+                " ".join(f"{f} on" for f in seg_features))
+
         ethtool(f"-K {cfg.ifname} tx-gso-partial off")
 
         no_partial = set()
         features = cfg.ethnl.features_get({"header": {"dev-index": cfg.ifindex}})
         for f in features["active"]["bits"]["bit"]:
             no_partial.add(f["name"])
-        cfg.partial_features = cfg.hw_features - no_partial
+        cfg.partial_features = seg_features - no_partial
         ethtool(f"-K {cfg.ifname} tx-gso-partial on")
 
     restore_wanted_features(cfg)
-- 
2.53.0



