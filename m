Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0931C1ACEDA;
	Sun,  7 Sep 2025 20:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277015; cv=none; b=lnKp8kz6I7/3/YMLMlRAeXbSrAOTV2SzHgtC1F+gt/mbhpKqgc6LZGbySBDyN//9GhRybZUfuA8/Q+fYfYe214pztyQTUPlg0bIGJF6OfoSbJ5s1HjV1hWxZzPZ6gaQTnpcPNI7q0RDKDn41IfcGlinPkCDqiKou2rTLPww1a8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277015; c=relaxed/simple;
	bh=cKTUfbbcT36CHPmfWG/6sjoB2fK6Jw/Ddhg2SPVIyCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYRmN8ZT0vXS4VlcHhXFjzSGR+/rzOYMhzR8eBreXqKTOcbfdzYr6ZK2npk/07Cpk4zDEGhlaeS7Llk9v8Te4MCtIdZtItpQ2ufAYMX/GJXKB58sGx5d3UOGY8LXz3HkjhnOKuakrii/IiC1z9smshtXjJyY5iiPgJ+DwgzLnb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7a3KP5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7a3KP5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8557CC4CEF0;
	Sun,  7 Sep 2025 20:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277014;
	bh=cKTUfbbcT36CHPmfWG/6sjoB2fK6Jw/Ddhg2SPVIyCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7a3KP5o99I2lflp+2ExziLg4uPU/86TiWPeSZJ8+BFQnjS72O5KytkRZvJDpJMo/
	 38TyRM8MdQFbuMbilOmGlIbzBcBQpsnHGpjzSVMD+kgL1TdBy70q14JSLPTcr70ILv
	 9QZJUJFlm0KMbo3xZDsfWH9r8G1YHk571zsBdHMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 059/175] ixgbe: fix incorrect map used in eee linkmode
Date: Sun,  7 Sep 2025 21:57:34 +0200
Message-ID: <20250907195616.235439398@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit b7e5c3e3bfa9dc8af75ff6d8633ad7070e1985e4 ]

incorrectly used ixgbe_lp_map in loops intended to populate the
supported and advertised EEE linkmode bitmaps based on ixgbe_ls_map.
This results in incorrect bit setting and potential out-of-bounds
access, since ixgbe_lp_map and ixgbe_ls_map have different sizes
and purposes.

ixgbe_lp_map[i] -> ixgbe_ls_map[i]

Use ixgbe_ls_map for supported and advertised linkmodes, and keep
ixgbe_lp_map usage only for link partner (lp_advertised) mapping.

Fixes: 9356b6db9d05 ("net: ethernet: ixgbe: Convert EEE to use linkmodes")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 9482e0cca8b7d..0b9ecb10aa7cf 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -3443,13 +3443,13 @@ ixgbe_get_eee_fw(struct ixgbe_adapter *adapter, struct ethtool_keee *edata)
 
 	for (i = 0; i < ARRAY_SIZE(ixgbe_ls_map); ++i) {
 		if (hw->phy.eee_speeds_supported & ixgbe_ls_map[i].mac_speed)
-			linkmode_set_bit(ixgbe_lp_map[i].link_mode,
+			linkmode_set_bit(ixgbe_ls_map[i].link_mode,
 					 edata->supported);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(ixgbe_ls_map); ++i) {
 		if (hw->phy.eee_speeds_advertised & ixgbe_ls_map[i].mac_speed)
-			linkmode_set_bit(ixgbe_lp_map[i].link_mode,
+			linkmode_set_bit(ixgbe_ls_map[i].link_mode,
 					 edata->advertised);
 	}
 
-- 
2.50.1



