Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4663F23C5;
	Wed, 20 May 2026 18:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301187; cv=none; b=X9Y3i76nBN1hBxxRP7yP38OfUROjrqRkFnaS2dI61FMD+Q3iAoVKLs6JKwniqnyvg3l/jXA/liaw9T+z0XTrY8udrfvQ8V2zCfRYaXo1rezlqkAmypWTAOIe2AZeWc3dkQ+yvRChdiFt1PUXN3doXplKNhIZHo4iuFlmPm9g+aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301187; c=relaxed/simple;
	bh=0kV9jellMsyRPmZiwB0j08RUC17mJiydXpWHLphfdoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mux1l+fjtSZiGekpQf34K19hU9mgK87vuP9GMswOQlnslz/5Xu2rq4L0AfV+Ey1/ppG1MUSOf+UBNYe5wSGCBXVokWULt3VygTPVWFJZfnn6LB9G8lK4D+fPAj1VOcaaaIFhdQDopPuDwKRYRKDjYFLIjjWq7uFzDLKPsQhzlf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9HHPxYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9HHPxYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B661F000E9;
	Wed, 20 May 2026 18:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301186;
	bh=V1QRENEsE6x3gv+pqZ+sEOwR83QUMCopj2dU7PVGWNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9HHPxYNYQGe2nTbXn948LgVf29NMRISQEfcENQ09WMoIS06hkeRoybw9r83tgKZS
	 EhoaUNMXzkW26irtfk2zxpKxxXUJ6tPudCm6GuAs94pTy93Bm0J2fVkdgQP1cnennR
	 FA9+oL+xyjibEWi5U3/f14Pl+DcbJZCmzmXnyI1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/666] ice: fix ICE_AQ_LINK_SPEED_M for 200G
Date: Wed, 20 May 2026 18:21:10 +0200
Message-ID: <20260520162121.218010743@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit 4a3a940059e98539de293a6e36e464094c2e875b ]

When setting PHY configuration during driver initialization, 200G link
speed is not being advertised even when the PHY is capable. This is
because the get PHY capabilities link speed response is being masked by
ICE_AQ_LINK_SPEED_M, which does not include the 200G link speed bit.

ICE_AQ_LINK_SPEED_200GB is defined as BIT(11), but the mask 0x7FF only
covers bits 0-10. Fix ICE_AQ_LINK_SPEED_M to use GENMASK(11, 0) so
that it covers all defined link speed bits including 200G.

Fixes: 24407a01e57c ("ice: Add 200G speed/phy type use")
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-6-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 66ae0352c6bca..d8013818da960 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1347,7 +1347,7 @@ struct ice_aqc_get_link_status_data {
 #define ICE_AQ_LINK_PWR_QSFP_CLASS_3	2
 #define ICE_AQ_LINK_PWR_QSFP_CLASS_4	3
 	__le16 link_speed;
-#define ICE_AQ_LINK_SPEED_M		0x7FF
+#define ICE_AQ_LINK_SPEED_M		GENMASK(11, 0)
 #define ICE_AQ_LINK_SPEED_10MB		BIT(0)
 #define ICE_AQ_LINK_SPEED_100MB		BIT(1)
 #define ICE_AQ_LINK_SPEED_1000MB	BIT(2)
-- 
2.53.0



