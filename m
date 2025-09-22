Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42213128C4;
	Mon, 22 Sep 2025 19:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570173; cv=none; b=c92neWX+/XoqdjxE3XWyhQ1W1m7yncVEKaeGM/yyDL2THR/wCx8/zAYgKA4eMn0hr+nWfIkcFI94ZWhbS2uhWqOsK2rBV+PHn4HqW5j9hxZ3esgecXuCEpJwaWuNI/0/4r35NDJWJcGnCNnJlweBxpHA/qge9N9+IPXuRatjxkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570173; c=relaxed/simple;
	bh=/rbcM0dtWHoeHuNcFMHF+TY1FhFto49kqyOutDMJ20Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcrRVuKVBGBE9i6AtcXrsec0UBVWy4m9bz8E1Fc74geUOlzo1R1Zzwbi87/8FgJCzkuvVxONsJew8a2Lyp9JDgDOgfO0+lWFzffZYPy/SXZitpBY9Nb1e6Q7C6Rv7QCwOiywJFl2zCYrPgqiOQECoD1gmqeWPdMwKVFLgd0HV2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKQfxTSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKQfxTSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3248CC4CEF0;
	Mon, 22 Sep 2025 19:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570173;
	bh=/rbcM0dtWHoeHuNcFMHF+TY1FhFto49kqyOutDMJ20Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKQfxTSJ7Zt7EQpcXZ7ndwXjliwiNUrRKYNCyNALxTVZ7wALgoFMJsxlndw96mwr+
	 ltAE2iTxFeRXU3Ce6ZHmzNi8VJJQV1HVUjokqj8WwChtSFUZ/HzI90/rO5pvMaSrJ0
	 4m0V2s/2SA6olvSWI9nSB7mxyhKv8u5Mbb+0JcOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathesh B Edara <sedara@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 039/149] octeon_ep: fix VF MAC address lifecycle handling
Date: Mon, 22 Sep 2025 21:28:59 +0200
Message-ID: <20250922192413.848655034@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sathesh B Edara <sedara@marvell.com>

[ Upstream commit a72175c985132885573593222a7b088cf49b07ae ]

Currently, VF MAC address info is not updated when the MAC address is
configured from VF, and it is not cleared when the VF is removed. This
leads to stale or missing MAC information in the PF, which may cause
incorrect state tracking or inconsistencies when VFs are hot-plugged
or reassigned.

Fix this by:
 - storing the VF MAC address in the PF when it is set from VF
 - clearing the stored VF MAC address when the VF is removed

This ensures that the PF always has correct VF MAC state.

Fixes: cde29af9e68e ("octeon_ep: add PF-VF mailbox communication")
Signed-off-by: Sathesh B Edara <sedara@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250916133207.21737-1-sedara@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
index ebecdd29f3bd0..0867fab61b190 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
@@ -196,6 +196,7 @@ static void octep_pfvf_get_mac_addr(struct octep_device *oct,  u32 vf_id,
 			vf_id);
 		return;
 	}
+	ether_addr_copy(oct->vf_info[vf_id].mac_addr, rsp->s_set_mac.mac_addr);
 	rsp->s_set_mac.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
 }
 
@@ -205,6 +206,8 @@ static void octep_pfvf_dev_remove(struct octep_device *oct,  u32 vf_id,
 {
 	int err;
 
+	/* Reset VF-specific information maintained by the PF */
+	memset(&oct->vf_info[vf_id], 0, sizeof(struct octep_pfvf_info));
 	err = octep_ctrl_net_dev_remove(oct, vf_id);
 	if (err) {
 		rsp->s.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
-- 
2.51.0



