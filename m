Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38773D978;
	Tue,  2 Jul 2024 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940919; cv=none; b=Za8QoDfzmOSN3HrjqMhClX1XsXIelKf7QpknQOEL9IB2GTaFEUZBfJcpOWOUJksHLQ55XM+bfD+IYsjhmCHZGJNaKueHtbNWy3ZNTqYuoMLGge1xO7Fl2OFpqGDr/gRbMdVlgdgB6PJokHbISTzm88qQut1d2CJ9YH4oQxGFwfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940919; c=relaxed/simple;
	bh=23eru5sUMM+nO4ddJaSiMIYzDIygQSfUUlWpohgt99o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSZFXQ3I6j4zsSsURcm3Ykedh/qv68hp4kByaAlQgWOPdRgDsz2vTP/42qVk9cYZaNQ63lcI+23Bo8fv6IGH1+oT+MFng5mbJv3CvUCNHcMd3o+fWMfX9vcHkwLDb3dwvUG2sv3M9chYqWwYpN5b4Ny3U4RjT1S6SuWWvHHweNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ds1Jrfkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ds1Jrfkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552D1C116B1;
	Tue,  2 Jul 2024 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940918;
	bh=23eru5sUMM+nO4ddJaSiMIYzDIygQSfUUlWpohgt99o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ds1JrfkkhUgY34ypF80M66OYr33tjBNo/eC9bErTewOXvCKUT6sB1Swgq7cPfnH9i
	 g18g+IEBHGE1xZRZjStf9G7cS7yyKKgLdPS72xaDucB6hDIjDa5paP+xm+bEH6KyQ0
	 rH/x/x2rJGF2Rjx5Bwa3iMGKkNe4tiQ304JVapuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jan Sokolowski <jan.sokolowski@intel.com>,
	Karen Ostrowska <karen.ostrowska@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 035/163] ice: Rebuild TC queues on VSI queue reconfiguration
Date: Tue,  2 Jul 2024 19:02:29 +0200
Message-ID: <20240702170234.386554941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jan Sokolowski <jan.sokolowski@intel.com>

[ Upstream commit f4b91c1d17c676b8ad4c6bd674da874f3f7d5701 ]

TC queues needs to be correctly updated when the number of queues on
a VSI is reconfigured, so netdev's queue and TC settings will be
dynamically adjusted and could accurately represent the underlying
hardware state after changes to the VSI queue counts.

Fixes: 0754d65bd4be ("ice: Add infrastructure for mqprio support via ndo_setup_tc")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Karen Ostrowska <karen.ostrowska@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 26ef8aec4cfdf..600a2f5370875 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3958,7 +3958,7 @@ bool ice_is_wol_supported(struct ice_hw *hw)
 int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 {
 	struct ice_pf *pf = vsi->back;
-	int err = 0, timeout = 50;
+	int i, err = 0, timeout = 50;
 
 	if (!new_rx && !new_tx)
 		return -EINVAL;
@@ -3984,6 +3984,14 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 
 	ice_vsi_close(vsi);
 	ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+
+	ice_for_each_traffic_class(i) {
+		if (vsi->tc_cfg.ena_tc & BIT(i))
+			netdev_set_tc_queue(vsi->netdev,
+					    vsi->tc_cfg.tc_info[i].netdev_tc,
+					    vsi->tc_cfg.tc_info[i].qcount_tx,
+					    vsi->tc_cfg.tc_info[i].qoffset);
+	}
 	ice_pf_dcb_recfg(pf, locked);
 	ice_vsi_open(vsi);
 done:
-- 
2.43.0



