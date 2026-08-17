Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055B744239E;
	Mon, 17 Aug 2026 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977473; cv=none; b=IshClaiaPdUf3mcOAPrtICWqDBrD1Leo7DpYMUb+lYW8Q6KdLfJOuhHGua7e9tsIu+2SH3M9pyVFumhmzDeJtqNAqArVwjtT/ajU8HZ0PPEUMcAVotet4oVzzA9umgGkd5ARKzMkdlSso+yv/RFx39qLLhr+68RrZl0MzEUFqwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977473; c=relaxed/simple;
	bh=AarjFawMtI/iRrySTWRgQA856igxRUIRZbLGWzcdcIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4ly1DK4j18HJ/c8RdNWiBWrrygkG4LuThmLougor76iuaHm70PAk4XlC2MauhFHVMNwYY8q3BPIP5Ev/6YriBc+GYLZX2DW0TerYJ4KueJvHuX1FnHD/5Jx6Mh5rhIPOC+gKBgKWQnuV3SG8iRclRJ+sSUX0HdzhmSdDaXuSxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UW5DzfcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UW5DzfcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4BA1F00A3D;
	Mon, 17 Aug 2026 14:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977471;
	bh=TnyN7MZ2lYo9b7tfwLIc/XCrndijCVSwFwSv3j8qZac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UW5DzfcJsJ70wE6PUnNjkeCZQpT1zvlztYAfSFPk3qtvUI3Hnn1SVXVNkJ18cEzIs
	 IRk9/l8vvU029uExbQL+08+9bJpdjpq08JhigmlFRlhbay+1TR+tttwtexOWsJmALR
	 THHLwcdyWHR135ECGxVvt/267j2PneJbYWIzlwpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nava kishore Manne <nava.kishore.manne@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 340/456] phy: zynqmp: use read-modify-write for SERDES scrambler bypass
Date: Mon, 17 Aug 2026 15:32:10 +0200
Message-ID: <20260817132552.896291127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nava kishore Manne <nava.kishore.manne@amd.com>

commit 21e0749f931702765b9d52d05740092bc87fcd8d upstream.

xpsgtr_bypass_scrambler_8b10b() used xpsgtr_write_phy() which performs
a full register write, silently clearing any bits beyond the intended
bypass control fields.

Switch to xpsgtr_clr_set_phy() with clr=mask, set=mask to set only
the bypass bits while preserving the remaining bits in each register.

Fixes: 4a33bea00314 ("phy: zynqmp: Add PHY driver for the Xilinx ZynqMP Gigabit Transceiver")
Cc: stable@vger.kernel.org
Signed-off-by: Nava kishore Manne <nava.kishore.manne@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260627155229.2791113-3-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/xilinx/phy-zynqmp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -491,8 +491,12 @@ static void xpsgtr_lane_set_protocol(str
 /* Bypass (de)scrambler and 8b/10b decoder and encoder. */
 static void xpsgtr_bypass_scrambler_8b10b(struct xpsgtr_phy *gtr_phy)
 {
-	xpsgtr_write_phy(gtr_phy, L0_TM_DIG_6, L0_TM_DIS_DESCRAMBLE_DECODER);
-	xpsgtr_write_phy(gtr_phy, L0_TX_DIG_61, L0_TM_DISABLE_SCRAMBLE_ENCODER);
+	xpsgtr_clr_set_phy(gtr_phy, L0_TM_DIG_6,
+			   L0_TM_DIS_DESCRAMBLE_DECODER,
+			   L0_TM_DIS_DESCRAMBLE_DECODER);
+	xpsgtr_clr_set_phy(gtr_phy, L0_TX_DIG_61,
+			   L0_TM_DISABLE_SCRAMBLE_ENCODER,
+			   L0_TM_DISABLE_SCRAMBLE_ENCODER);
 }
 
 /* DP-specific initialization. */


