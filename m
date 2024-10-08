Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D04E1DACBE;
	Tue,  8 Oct 2024 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389515; cv=none; b=L5RhW7gBpyNQ79FoN1DILPsFUnEmvXs97ZBWGktMnwfpj2BWtSoC2EQxVv2VRY2v9NP717ntyy80O7Z6/rvGylSh7fN1C9rLxrsyjmkmOOoA0j4uN8cY9s2Nj4Tw9CVJQ7xbRgNoTZNfKn0TAiaFEqLWNfrPgb/AOyiLNMHhBkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389515; c=relaxed/simple;
	bh=h0FdP+4uDD+DGlzdqAc3LQaAU2+NbNCfQitaIc/ggXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXVYitWDWS9vimotzt3jS6xNGTXXBM3UXky3GXrG5/l1/kObpe8AfB0zi7OHt1yadUVPhxjtyuMeGqfsjoJDzVnOAiamJVAVBmfAiNZ7CMdbPr4PAkif7T/UpEIgqMo+c3ayIIHVhJckr/e870C8KTmZLwVOPnGuKLdEdDdDEqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhmUgHzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhmUgHzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2296C4CEC7;
	Tue,  8 Oct 2024 12:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389515;
	bh=h0FdP+4uDD+DGlzdqAc3LQaAU2+NbNCfQitaIc/ggXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhmUgHzl/130dxjpdDMYZOBNkVtQlDb7oC60r4WBnauR5Ay/b/qIuWKkjt1EOyCOH
	 5kQ/3YKtSdW68MlZyKvqz/7oqtEqb4lD6l0rIBPmtoSn1LzZOipl6deAQbhnV2Pi82
	 p7RGGk5hMae1vgtZzQEoqOKWRdtmUQpz33vJUXdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aakash Menon <aakash.menon@protempis.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 017/482] net: sparx5: Fix invalid timestamps
Date: Tue,  8 Oct 2024 14:01:20 +0200
Message-ID: <20241008115648.976939447@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aakash Menon <aakash.r.menon@gmail.com>

[ Upstream commit 151ac45348afc5b56baa584c7cd4876addf461ff ]

Bit 270-271 are occasionally unexpectedly set by the hardware. This issue
was observed with 10G SFPs causing huge time errors (> 30ms) in PTP. Only
30 bits are needed for the nanosecond part of the timestamp, clear 2 most
significant bits before extracting timestamp from the internal frame
header.

Fixes: 70dfe25cd866 ("net: sparx5: Update extraction/injection for timestamping")
Signed-off-by: Aakash Menon <aakash.menon@protempis.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index f3f5fb4204689..70427643f777c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -45,8 +45,12 @@ void sparx5_ifh_parse(u32 *ifh, struct frame_info *info)
 	fwd = (fwd >> 5);
 	info->src_port = FIELD_GET(GENMASK(7, 1), fwd);
 
+	/*
+	 * Bit 270-271 are occasionally unexpectedly set by the hardware,
+	 * clear bits before extracting timestamp
+	 */
 	info->timestamp =
-		((u64)xtr_hdr[2] << 24) |
+		((u64)(xtr_hdr[2] & GENMASK(5, 0)) << 24) |
 		((u64)xtr_hdr[3] << 16) |
 		((u64)xtr_hdr[4] <<  8) |
 		((u64)xtr_hdr[5] <<  0);
-- 
2.43.0



