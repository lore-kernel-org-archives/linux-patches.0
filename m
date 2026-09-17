Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747CF4EB865;
	Thu, 17 Sep 2026 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664355; cv=none; b=JOHFXOowY1I6q5QP0gdmW3qg6ybqzFVNXsruiDf2hhUNYlSvkdOpNcJm2WhkFfepQj2ZbWTnwKhiXz/3nswNQ1Y0iYn5WDpoJ0ISbt7NzHit/hrJYSrYEpud5uy/2SX+qU8/Rf88w4LXb71IURMSarY6ZzQcs1DUscJ3zSfsmCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664355; c=relaxed/simple;
	bh=LpoakS+p5ozwx0sRRfm2M3EuQr7m2Ox7agBYaK4fzoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeRcKAwtZ4cOt84ZRGLsFGWI72QGXGchKkQNOTxJUf5IB9CWovMAvDtZwQeZqZ/T1Lc818kh4SQPI84BVxFR7eMH6ecX1FwH1Mu6+OsDhvseh4W4c19dg6OJnPxldA9ODojXPbouWf4Bb/2h6wY+UH8JoHeNyYwkRkVFA7OvxB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdER4EOz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdER4EOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F851F000FF;
	Thu, 17 Sep 2026 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664354;
	bh=G3Vqb7xU7R1P3Z/q9KDdwYPaAnm0fUcJ6fbmiRCOimo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdER4EOz3+EHvIAzYBmANbFyskBF7FbstLZ9Ayk4B/m/szs/2kzAqv6FTxRUhN4y4
	 lr39B9thWCqqpXxRFmwUnfVIxl9f8w3UKNOxCHK8WCdygOWK+X+G5mqHIp2InQlzAi
	 ZTX0uU0ErpkxArPIZoRxJWwogQGyHuL8pM6eFqlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0345/1250] net: microchip: sparx5: clean up PSFP resources on flower setup failure
Date: Thu, 17 Sep 2026 16:02:20 +0100
Message-ID: <20260917151601.425643616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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



