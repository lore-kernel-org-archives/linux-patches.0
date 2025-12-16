Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA1133ADAD;
	Tue, 16 Dec 2025 12:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887833; cv=none; b=XtbNJkoRwo34w4w1McEJy6gGlTxwUyKBFcY9Hg6UGm9aanAP9hpsGPbiw2zW1eFv/CaFN/h3iUdpeDj+ACfBdg82A/NndwGLxS8W8lTBPUsrbWMa3wB7Yh7Iv5PrODOzwd/KlwYMqxcJf7wnTuSJVnJhXqY3wAVEOB0i1nO+Gv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887833; c=relaxed/simple;
	bh=+ETTEnlZCu1HOFhZRpiFbjjJm83d3r0dXMcgrnhZemk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtN0v/kFvg7I4mYWsYsYYgjY2eZEuAeXrgNNKy3Z/s4vf4XKdYTo8bJcL/BuubEh2Cvv6rJA9kAhbI2Sr3MAhol8pGpObo8pP+9ZmQ9MxDgfrbEbwVRjRrlOBXaowM3dx8jDcZ9ctmvqYpCNS6GZn5AUW1NgcX2YIzkl/dKej/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bi9gLJtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bi9gLJtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D08C4CEF1;
	Tue, 16 Dec 2025 12:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887833;
	bh=+ETTEnlZCu1HOFhZRpiFbjjJm83d3r0dXMcgrnhZemk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bi9gLJtIkK/TjFf+InM39YePTFYcgwczS3azJ/REOlsJ4C93yPRdFw8QkwehdN+Hv
	 QprIflL3aIlBbzqRuqckBx9qs2SH7gNLNyvGzn0egneaYLlba33wcMGOhKaW1Wtv+p
	 qwfrrQgrS5CuCXhglPLHHJr6H0ifYLbbnEsEJNtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 318/614] net: stmmac: Fix VLAN 0 deletion in vlan_del_hw_rx_fltr()
Date: Tue, 16 Dec 2025 12:11:25 +0100
Message-ID: <20251216111412.886731025@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit d9db25723677c3741a0cf3643f7f7429fc983921 ]

When the "rx-vlan-filter" feature is enabled on a network device, the 8021q
module automatically adds a VLAN 0 hardware filter when the device is
brought administratively up.

For stmmac, this causes vlan_add_hw_rx_fltr() to create a new entry for
VID 0 in the mac_device_info->vlan_filter array, in the following format:

    VLAN_TAG_DATA_ETV | VLAN_TAG_DATA_VEN | vid

Here, VLAN_TAG_DATA_VEN indicates that the hardware filter is enabled for
that VID.

However, on the delete path, vlan_del_hw_rx_fltr() searches the vlan_filter
array by VID only, without verifying whether a VLAN entry is enabled. As a
result, when the 8021q module attempts to remove VLAN 0, the function may
mistakenly match a zero-initialized slot rather than the actual VLAN 0
entry, causing incorrect deletions and leaving stale entries in the
hardware table.

Fix this by verifying that the VLAN entry's enable bit (VLAN_TAG_DATA_VEN)
is set before matching and deleting by VID. This ensures only active VLAN
entries are removed and avoids leaving stale entries in the VLAN filter
table, particularly for VLAN ID 0.

Fixes: ed64639bc1e08 ("net: stmmac: Add support for VLAN Rx filtering")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20251113112721.70500-2-ovidiu.panait.rb@renesas.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
index ff02a79c00d4f..b18404dd5a8be 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
@@ -122,7 +122,8 @@ static int vlan_del_hw_rx_fltr(struct net_device *dev,
 
 	/* Extended Rx VLAN Filter Enable */
 	for (i = 0; i < hw->num_vlan; i++) {
-		if ((hw->vlan_filter[i] & VLAN_TAG_DATA_VID) == vid) {
+		if ((hw->vlan_filter[i] & VLAN_TAG_DATA_VEN) &&
+		    ((hw->vlan_filter[i] & VLAN_TAG_DATA_VID) == vid)) {
 			ret = vlan_write_filter(dev, hw, i, 0);
 
 			if (!ret)
-- 
2.51.0



