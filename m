Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51C24B34;
	Mon, 16 Sep 2024 12:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488399; cv=none; b=jc5cgpds+DUzVIRcjutqF42Tn36gOld74n6jsO2422/ueN+C3YeO08cMJf0iiEOaZ2yxIrZuTyBK8cr8Alxc7qF1kFrEjQbvTMMfCoDM24Nw15/tvA7Y4gv9SY3o6G4opuZlWg6EB3x7YiJTax/DZj09fXB6dV7+mCPRrH2DqAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488399; c=relaxed/simple;
	bh=BmVlT2jIvUvfTPsW7mvuncWMqU8zVi41ExXt9MrInXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8p4LIcT+huMqoVKShOebZL7tmZl38g7SuzjVgKRd24nlVM1IfoOMZlkLqZyvxfntulELScsQaZCId/DWDY+ZVDisftl8SdhXmDBhx+ww2bOTQWlCp22zfK3DNXBdMiBJ9Yf6OBQhhJitM0Oh/8iGE76LMTe9xxX8mypmABC7tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCcJsWu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCcJsWu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668FFC4CEC4;
	Mon, 16 Sep 2024 12:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488398;
	bh=BmVlT2jIvUvfTPsW7mvuncWMqU8zVi41ExXt9MrInXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCcJsWu7r0rByn4GRhb3e5b6RgSrp9/YDMXzGsE2OR2uaTbaphGn3rT87CSGfJnb+
	 6anyW5W2WZ8fcGbkAf9uGyVRJ0BvTqVzTWnQ3drp3wAZydp6u+cXcKhXnZ3DhWzUsA
	 u3r0YqQpVL2LnVuI+ebSyO+ZZjSnAfRxnTvMKPLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mat=C4=9Bj=20Gr=C3=A9gr?= <mgregr@netx.as>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.10 072/121] ice: Fix lldp packets dropping after changing the number of channels
Date: Mon, 16 Sep 2024 13:44:06 +0200
Message-ID: <20240916114231.556017826@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>

[ Upstream commit 9debb703e14939dfafa5d403f27c4feb2e9f6501 ]

After vsi setup refactor commit 6624e780a577 ("ice: split ice_vsi_setup
into smaller functions") ice_cfg_sw_lldp function which removes rx rule
directing LLDP packets to vsi is moved from ice_vsi_release to
ice_vsi_decfg function. ice_vsi_decfg is used in more cases than just in
vsi_release resulting in unnecessary removal of rx lldp packets handling
switch rule. This leads to lldp packets being dropped after a change number
of channels via ethtool.
This patch moves ice_cfg_sw_lldp function that removes rx lldp sw rule back
to ice_vsi_release function.

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Reported-by: Matěj Grégr <mgregr@netx.as>
Closes: https://lore.kernel.org/intel-wired-lan/1be45a76-90af-4813-824f-8398b69745a9@netx.as/T/#u
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7076a7738864..c2ba58659347 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2413,13 +2413,6 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
 	struct ice_pf *pf = vsi->back;
 	int err;
 
-	/* The Rx rule will only exist to remove if the LLDP FW
-	 * engine is currently stopped
-	 */
-	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF &&
-	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
-		ice_cfg_sw_lldp(vsi, false, false);
-
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
 	if (err)
@@ -2764,6 +2757,14 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		ice_rss_clean(vsi);
 
 	ice_vsi_close(vsi);
+
+	/* The Rx rule will only exist to remove if the LLDP FW
+	 * engine is currently stopped
+	 */
+	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF &&
+	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
+		ice_cfg_sw_lldp(vsi, false, false);
+
 	ice_vsi_decfg(vsi);
 
 	/* retain SW VSI data structure since it is needed to unregister and
-- 
2.43.0



