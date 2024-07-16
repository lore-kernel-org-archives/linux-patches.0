Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0690D1DDCE;
	Tue, 16 Jul 2024 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145682; cv=none; b=CntK7w53/x5WQwQUrSbkXy7H95O+QQ+6q/BEYpnP9K68Hku0MTxDGAmUuMlP3U5/IUQd3rL4R/p+z9TWz1MeHvzcV9FxpAcICFbT5HCpdtrIyxcfI6g0mQsR5S/oiZ2Z1+/LCTjMAa7RFLCDWvmVhuFL01uR0KO6L6w9+3rgKoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145682; c=relaxed/simple;
	bh=9sdX51Fv823cxUqNIUZWuLwyhLyDGHVVFhJYp18Hkec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sihzQ2stOOLWpRE6i0+I68i14nc5DEADplthtWdxoddd3BEDiBWP2wdDA7FbZYXl4L1phHWn2GROiWffwqp6x1FDhanMc6gDACaUWg0q1tr8MVfWm8bGtyZL1TX2ZiK2XebfYbyl8Z/uJm4pLkpB29bz2Xkvi/XjPDmNLWl4zTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLnGhHic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLnGhHic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455DAC4AF0B;
	Tue, 16 Jul 2024 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145681;
	bh=9sdX51Fv823cxUqNIUZWuLwyhLyDGHVVFhJYp18Hkec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLnGhHic0aR7UL4D+Q8/mICj5JI1w8YB4IKkNesCstqTfPvfE/91cWUixKFprUJXQ
	 GnNr+qpYTPFmFXY/ZaRUd5RwaS/SzZSmMjOwPj+sq+bORtZilg/7vDV09Z21uRCXkQ
	 x69L2mC2C+T1do+MXYz9XWKf4wQgMDNQC7A5mpVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Mazur <mmazur2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/121] octeontx2-af: fix detection of IP layer
Date: Tue, 16 Jul 2024 17:31:50 +0200
Message-ID: <20240716152753.173456573@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Michal Mazur <mmazur2@marvell.com>

[ Upstream commit 404dc0fd6fb0bb942b18008c6f8c0320b80aca20 ]

Checksum and length checks are not enabled for IPv4 header with
options and IPv6 with extension headers.
To fix this a change in enum npc_kpu_lc_ltype is required which will
allow adjustment of LTYPE_MASK to detect all types of IP headers.

Fixes: 21e6699e5cd6 ("octeontx2-af: Add NPC KPU profile")
Signed-off-by: Michal Mazur <mmazur2@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index c92c3f4631d54..2c028a81bbc51 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -63,8 +63,13 @@ enum npc_kpu_lb_ltype {
 	NPC_LT_LB_CUSTOM1 = 0xF,
 };
 
+/* Don't modify ltypes up to IP6_EXT, otherwise length and checksum of IP
+ * headers may not be checked correctly. IPv4 ltypes and IPv6 ltypes must
+ * differ only at bit 0 so mask 0xE can be used to detect extended headers.
+ */
 enum npc_kpu_lc_ltype {
-	NPC_LT_LC_IP = 1,
+	NPC_LT_LC_PTP = 1,
+	NPC_LT_LC_IP,
 	NPC_LT_LC_IP_OPT,
 	NPC_LT_LC_IP6,
 	NPC_LT_LC_IP6_EXT,
@@ -72,7 +77,6 @@ enum npc_kpu_lc_ltype {
 	NPC_LT_LC_RARP,
 	NPC_LT_LC_MPLS,
 	NPC_LT_LC_NSH,
-	NPC_LT_LC_PTP,
 	NPC_LT_LC_FCOE,
 	NPC_LT_LC_NGIO,
 	NPC_LT_LC_CUSTOM0 = 0xE,
-- 
2.43.0



