Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7777F4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED90FC433D2;
	Wed, 15 Mar 2023 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884160;
	bh=PpqU1eHttsPilagO+7CE/bYfjxxk7Fs5pEzByd5xpyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUcPrCVJ+dOXGt4gBug7V3dWWx7Op/qzCkj/MRKzUkaPIHcx4HwlK8aruUBK+kVDl
	 nMvaIli66fYFgkDl4h7Ww0wyVsWy0JENsbD+JMYIUd20TywblO/eO7uS2DofC5BW2s
	 5E+miSvTOQ2YCj4GU4c+wyyPK0x9VWJQWH30afp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Ertman <david.m.ertman@intel.com>,
	Karen Ostrowska <karen.ostrowska@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.2 100/141] ice: Fix DSCP PFC TLV creation
Date: Wed, 15 Mar 2023 13:13:23 +0100
Message-Id: <20230315115743.045261092@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit fef3f92e8a4214652d8f33f50330dc5a92efbf11 ]

When creating the TLV to send to the FW for configuring DSCP mode PFC,the
PFCENABLE field was being masked with a 4 bit mask (0xF), but this is an 8
bit bitmask for enabled classes for PFC.  This means that traffic classes
4-7 could not be enabled for PFC.

Remove the mask completely, as it is not necessary, as we are assigning 8
bits to an 8 bit field.

Fixes: 2a87bd73e50d ("ice: Add DSCP support")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Karen Ostrowska <karen.ostrowska@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 6be02f9b0b8c2..789b99963910d 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -1372,7 +1372,7 @@ ice_add_dscp_pfc_tlv(struct ice_lldp_org_tlv *tlv, struct ice_dcbx_cfg *dcbcfg)
 	tlv->ouisubtype = htonl(ouisubtype);
 
 	buf[0] = dcbcfg->pfc.pfccap & 0xF;
-	buf[1] = dcbcfg->pfc.pfcena & 0xF;
+	buf[1] = dcbcfg->pfc.pfcena;
 }
 
 /**
-- 
2.39.2



