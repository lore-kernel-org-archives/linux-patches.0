Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DD32DB794;
	Wed, 30 Sep 2026 18:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794366; cv=none; b=PTyzzC6AElRqk8txfohC0s8jweNOkngUsH6WdtlBuWNTh+D+Zh/vpf5L/E3UFj2XZ+KM4dHgKgz1Dtd5fCKT1og+S3Ij8Mw9/rPeb4ozP3ocHqUqXklFa4x1PdPOWK7wK0OkZ+L5FYYE6rsACmgyscHKp+q5M0Y8div1ZzwAXwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794366; c=relaxed/simple;
	bh=s8jPAee0GQEWmJ04nDjcdFDQnK5LoAKBw09v+Trfypg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDBIMvvRvDsKSMjkxbEEeFmYd01LqhbklPkepcOo81ChAUw+IKpFwfZpUlDCbji+YATrvGXOZypEmbe1RbkkTBMy3kyaH5i4hcO9NqrrmeiArz+Lp1HTLfZ1SFrX2DbXJ7MEvifjPDb0O+8fOI1ptAI2e9QvsQbF1HCSJ52miqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOPJ4IbJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOPJ4IbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7221F1F000FF;
	Wed, 30 Sep 2026 18:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794365;
	bh=IjYl81H+7cPef/lfbMudZwKgQylvkWzZxkMUWJSItAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOPJ4IbJn1zNe1HuGo8EvA1lxqI7g0OVuuoa95QWvcmDugO1FZUM9TNhvKqbgNrqI
	 RQIEukOWXeOmBsS1amomf2Fd2IwkAsW/pzSw/VJUqvZybr6uYHZYO/AEl/SoFo+spu
	 s1gRr/7QYP1zyWoaN43ZR2jqb32rECI4l1gB3+Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0184/1193] net: microchip: sparx5: clean up PSFP resources on flower setup failure
Date: Wed, 30 Sep 2026 17:14:28 +0200
Message-ID: <20260930152438.283469928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8dee1ab1fa754..2f06d7ab7d4b7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
@@ -273,6 +273,9 @@ int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
 	ret = sparx5_psfp_fm_get(uidx, &fm->pol.idx);
 	if (ret < 0)
 		return ret;
+
+	*id = fm->pol.idx;
+
 	/* Was already in use, no need to reconfigure */
 	if (ret > 1)
 		return 0;
@@ -287,8 +290,6 @@ int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
 	if (ret < 0)
 		return ret;
 
-	*id = fm->pol.idx;
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 55f255a3c9db6..be53af6f6adda 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -801,7 +801,7 @@ static int sparx5_tc_flower_psfp_setup(struct sparx5 *sparx5,
 		/* Add new flow-meter */
 		ret = sparx5_psfp_fm_add(sparx5, pol_idx, fm, &psfp_fmid);
 		if (ret < 0)
-			return ret;
+			goto err_sg_del;
 	}
 
 	/* Map stream filter to stream gate */
@@ -810,7 +810,7 @@ static int sparx5_tc_flower_psfp_setup(struct sparx5 *sparx5,
 	/* Add new stream-filter and map it to a steam gate */
 	ret = sparx5_psfp_sf_add(sparx5, sf, &psfp_sfid);
 	if (ret < 0)
-		return ret;
+		goto err_fm_del;
 
 	/* Streams are classified by ISDX - map ISDX 1:1 to sfid for now. */
 	sparx5_isdx_conf_set(sparx5, psfp_sfid, psfp_sfid, psfp_fmid);
@@ -818,13 +818,23 @@ static int sparx5_tc_flower_psfp_setup(struct sparx5 *sparx5,
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



