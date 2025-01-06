Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0109B1DC9BC;
	Mon,  6 Jan 2025 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177456; cv=none; b=lbCWJWsmS5nxDxE4o8zgGx4s9BdoROYk2sc6UobuBZHI5QzSrEGBZP6l5D8TJaZT2Zrm8CF4XqzVLM97gCgeYaMr6L+QU9yFUtghMxsygIjkesUG/Eo9ABM+JoGLHTKH1sjeRU3jzNirozR7BkQlf9UuOcq2KhGY8b1J0PFw0Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177456; c=relaxed/simple;
	bh=kFI47smtFBCSAm0pMmVAox5ObfMX26Fk39Dlvoa4Mcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obX10IUr8gayk5yD7BluBrZxV+DmLR5fS1MbSPca5xo1j1NVro3+PN2EMFdPhMWbJ5whps7CuiV7o0yxP263kofSVuYvu4s5WfnCWntY5XXwXqsg94ORDIZrEfpi7sqYh5HIoeV5SD8u9vwVZVPucmL440FKcLHtFOTGQHuGfDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIDfhjVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIDfhjVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DBBC4CED2;
	Mon,  6 Jan 2025 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177455;
	bh=kFI47smtFBCSAm0pMmVAox5ObfMX26Fk39Dlvoa4Mcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIDfhjVqmqTfUVwHu76QihdMn5/qF4c10rUrKETIalOwaQV+HcD/0ETk+702r4pG7
	 YkXyn/RgvXNrfQvAuLGo+vpxEjkWIshViYr5mS4kXWZQCHfyj5YJXLAfc9Eys0nQyu
	 ONipYdq2KJOBiFyYE+k0JRMllXBp9ZObdk2n0Tfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Jie <liangjie@lixiang.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/222] net: sfc: Correct key_len for efx_tc_ct_zone_ht_params
Date: Mon,  6 Jan 2025 16:16:14 +0100
Message-ID: <20250106151157.199271051@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit a8620de72e5676993ec3a3b975f7c10908f5f60f ]

In efx_tc_ct_zone_ht_params, the key_len was previously set to
offsetof(struct efx_tc_ct_zone, linkage). This calculation is incorrect
because it includes any padding between the zone field and the linkage
field due to structure alignment, which can vary between systems.

This patch updates key_len to use sizeof_field(struct efx_tc_ct_zone, zone)
, ensuring that the hash table correctly uses the zone as the key. This fix
prevents potential hash lookup errors and improves connection tracking
reliability.

Fixes: c3bb5c6acd4e ("sfc: functions to register for conntrack zone offload")
Signed-off-by: Liang Jie <liangjie@lixiang.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://patch.msgid.link/20241230093709.3226854-1-buaajxlj@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/tc_conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tc_conntrack.c b/drivers/net/ethernet/sfc/tc_conntrack.c
index 44bb57670340..109d2aa34ae3 100644
--- a/drivers/net/ethernet/sfc/tc_conntrack.c
+++ b/drivers/net/ethernet/sfc/tc_conntrack.c
@@ -16,7 +16,7 @@ static int efx_tc_flow_block(enum tc_setup_type type, void *type_data,
 			     void *cb_priv);
 
 static const struct rhashtable_params efx_tc_ct_zone_ht_params = {
-	.key_len	= offsetof(struct efx_tc_ct_zone, linkage),
+	.key_len	= sizeof_field(struct efx_tc_ct_zone, zone),
 	.key_offset	= 0,
 	.head_offset	= offsetof(struct efx_tc_ct_zone, linkage),
 };
-- 
2.39.5



