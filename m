Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D172153C6;
	Wed,  7 May 2025 18:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644179; cv=none; b=RxdCCikegQyAxaD/l1EnCqE5z7cig7zOAHjgP3/6ko5wNamwtMeqCqik992toEvWeIRGFV88Ug8ngo+0rRnep+H5I8CNMBIYwEH+6GuhpXaciTuGWwboP2Vmul4VQXBxdyYKUI6LG2WB19ra9MB2W1kqiRuNbsk8eXRuWT19004=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644179; c=relaxed/simple;
	bh=vGKOeHfRKsoXvUhVZOPot7URCwfGIU/5TGm1kOyHVw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtF9RMNAM2iHmFmn2OdKE9+WaGLD+Asq/3dfHAyvBRItvq9aQd3Q6e0iViVNY5hqqYOzX5sGg0C2Wc3P7nfRHoVrlAz4c/50nApbsyXdhYRK/pZi/+XsOg2+i5l3znWx12Q7kRV4lvAIdXgSqy8LS+vU/yLyzdyIQm3lleF484A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x164vJfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x164vJfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E35C4CEE2;
	Wed,  7 May 2025 18:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644179;
	bh=vGKOeHfRKsoXvUhVZOPot7URCwfGIU/5TGm1kOyHVw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x164vJfxp2bIS1M0X0AtHUJrfnY23eR3CU2BDbJId6ViisJZnnQxdkDHzFewdX8BG
	 GJ2D1bpwxiR7QVefwzvBOMOBC1YlHoQ2mhxWqNiNryoM4XpPS+f6yTH++nrNE1skTN
	 HUBKZRq+Jrp5BsTOAMNHKyRad8TRUSjAwREGDNjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 114/183] idpf: fix potential memory leak on kcalloc() failure
Date: Wed,  7 May 2025 20:39:19 +0200
Message-ID: <20250507183829.443457098@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 8a558cbda51bef09773c72bf74a32047479110c7 ]

In case of failing on rss_data->rss_key allocation the function is
freeing vport without freeing earlier allocated q_vector_idxs. Fix it.

Move from freeing in error branch to goto scheme.

Fixes: d4d558718266 ("idpf: initialize interrupts and enable vport")
Reviewed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Suggested-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 78951d62f6171..6e8a82dae1628 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1112,11 +1112,9 @@ static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 
 	num_max_q = max(max_q->max_txq, max_q->max_rxq);
 	vport->q_vector_idxs = kcalloc(num_max_q, sizeof(u16), GFP_KERNEL);
-	if (!vport->q_vector_idxs) {
-		kfree(vport);
+	if (!vport->q_vector_idxs)
+		goto free_vport;
 
-		return NULL;
-	}
 	idpf_vport_init(vport, max_q);
 
 	/* This alloc is done separate from the LUT because it's not strictly
@@ -1126,11 +1124,9 @@ static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 	 */
 	rss_data = &adapter->vport_config[idx]->user_config.rss_data;
 	rss_data->rss_key = kzalloc(rss_data->rss_key_size, GFP_KERNEL);
-	if (!rss_data->rss_key) {
-		kfree(vport);
+	if (!rss_data->rss_key)
+		goto free_vector_idxs;
 
-		return NULL;
-	}
 	/* Initialize default rss key */
 	netdev_rss_key_fill((void *)rss_data->rss_key, rss_data->rss_key_size);
 
@@ -1143,6 +1139,13 @@ static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 	adapter->next_vport = idpf_get_free_slot(adapter);
 
 	return vport;
+
+free_vector_idxs:
+	kfree(vport->q_vector_idxs);
+free_vport:
+	kfree(vport);
+
+	return NULL;
 }
 
 /**
-- 
2.39.5



