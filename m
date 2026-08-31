Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C073F549374;
	Mon, 31 Aug 2026 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183984; cv=none; b=k+ITd5fcXwVxoAkD/HUk9thqAJwpE+0GGC8B7x52TyG9tMqCo1bWQicEKvPcDTpA6LcaV6SGpQf/ToZ6gArRIaFnYjjbeDzlTOre8uCnGKWl03FAj7QAnN/xK3N1rbFEcxOGOiw6CsZ1vRYLroHgVzCZllkU3/gjEm3fhp31sHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183984; c=relaxed/simple;
	bh=8Vhh8WTXlZVW78ey5QIgLWEfiXvHFEn+pGKluGZaJwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XCWNgCIHzGsVhTweu/CBfwy96n4QzM6oqIasas1mBBTTygpD4mLa160r5i8bwV3WnA3sUu5+G8rLAlDlabfZVIhXXUTBuM4ydXg0eOmG5SCFtptwq277LPKoaG2lBK9cD2/onQhStcgmXF6kbfcf3w+6gIV0fuky52r3c3dCPRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I0NGyoID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I0NGyoID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215381F000E9;
	Mon, 31 Aug 2026 13:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183981;
	bh=1sFl4euGaq7EWjnVBOPYf+BURn0Jum3RuNPegSYhn+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0NGyoIDBZcbOEWb8b7sAF90Vy/AgHmbJpE6qruekldr7sDT0azC0JiqrkDwcUMbP
	 jBS8YBfUtXDkBZNWHSedV8pLYgPrtli4pQpOldHkMxkf2CftC8MTSoBdHaad8pE7NV
	 pkERQrQXlmLcqUywL/4/jDSIo7NBOs6IQFCgjHESundFz+6suFsU0cqA3NV1MUryrH
	 1XhR6MypVpfcJvY0RvH9l6AybvmSPOtfx1M9kNuVex9rNhCRUjHcNnS913ee2hX91P
	 LI1/8v8RgxtnodszRRuBdGjU8UAcRC/wWdDxNY9OOhdED4aPg5q4rZDYL9tGu/ggDZ
	 eL9bXamOesSqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] net: microchip: sparx5: clean up PSFP resources on flower setup failure
Date: Mon, 31 Aug 2026 09:27:27 -0400
Message-ID: <20260831133314.4125787-419-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 46e50367338702abe3df661df7795bdada40fef7 ]

sparx5_tc_flower_psfp_setup() allocates PSFP stream gate, flow meter and
stream filter resources before adding VCAP actions. If a later step
fails, the resources allocated earlier in the function are not unwound.

Add error paths to release the stream filter, flow meter and stream gate
when setup fails after they have been acquired.

Also make sparx5_psfp_fm_add() return the acquired flow-meter id before
the existing-flow-meter early return. When an existing flow meter is
reused, sparx5_psfp_fm_get() increments its pool reference count, but the
caller previously kept psfp_fmid as 0. If a later setup step failed, the
error path could try to delete flow-meter id 0 instead of the reused flow
meter, leaving the incremented reference behind.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20260603061716.747282-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished and match the earlier analysis:

- **`b4 dig`** couldn't run — the commit isn't in this tree, so lore
  thread lookup wasn't possible that way.
- **`git log --grep`** found no match for "clean up PSFP" or "flower
  setup failure", confirming the fix isn't in **6.18.44** yet.

That supports the **YES** backport recommendation: the PSFP resource-
leak bug is still present on this tree, and the patch should apply
cleanly.

 .../ethernet/microchip/sparx5/sparx5_psfp.c    |  5 +++--
 .../microchip/sparx5/sparx5_tc_flower.c        | 18 ++++++++++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
index cd4f42c3f7ebf..83b37f95ee467 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
@@ -277,6 +277,9 @@ int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
 	ret = sparx5_psfp_fm_get(sparx5, uidx, &fm->pol.idx);
 	if (ret < 0)
 		return ret;
+
+	*id = fm->pol.idx;
+
 	/* Was already in use, no need to reconfigure */
 	if (ret > 1)
 		return 0;
@@ -291,8 +294,6 @@ int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
 	if (ret < 0)
 		return ret;
 
-	*id = fm->pol.idx;
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 4dc1ebd5d510d..e5022d783ee68 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -807,7 +807,7 @@ static int sparx5_tc_flower_psfp_setup(struct sparx5 *sparx5,
 		/* Add new flow-meter */
 		ret = sparx5_psfp_fm_add(sparx5, pol_idx, fm, &psfp_fmid);
 		if (ret < 0)
-			return ret;
+			goto err_sg_del;
 	}
 
 	/* Map stream filter to stream gate */
@@ -816,7 +816,7 @@ static int sparx5_tc_flower_psfp_setup(struct sparx5 *sparx5,
 	/* Add new stream-filter and map it to a steam gate */
 	ret = sparx5_psfp_sf_add(sparx5, sf, &psfp_sfid);
 	if (ret < 0)
-		return ret;
+		goto err_fm_del;
 
 	/* Streams are classified by ISDX - map ISDX 1:1 to sfid for now. */
 	sparx5_isdx_conf_set(sparx5, psfp_sfid, psfp_sfid, psfp_fmid);
@@ -824,13 +824,23 @@ static int sparx5_tc_flower_psfp_setup(struct sparx5 *sparx5,
 	ret = vcap_rule_add_action_bit(vrule, VCAP_AF_ISDX_ADD_REPLACE_SEL,
 				       VCAP_BIT_1);
 	if (ret)
-		return ret;
+		goto err_sf_del;
 
 	ret = vcap_rule_add_action_u32(vrule, VCAP_AF_ISDX_VAL, psfp_sfid);
 	if (ret)
-		return ret;
+		goto err_sf_del;
 
 	return 0;
+
+err_sf_del:
+	sparx5_isdx_conf_set(sparx5, psfp_sfid, 0, 0);
+	sparx5_psfp_sf_del(sparx5, psfp_sfid);
+err_fm_del:
+	if (pol_idx >= 0)
+		sparx5_psfp_fm_del(sparx5, psfp_fmid);
+err_sg_del:
+	sparx5_psfp_sg_del(sparx5, psfp_sgid);
+	return ret;
 }
 
 /* Handle the action trap for a VCAP rule */
-- 
2.53.0

