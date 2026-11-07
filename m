Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064295;
	b=Z4O2rYMXtLnfy71jM9Czog65oncJ2t/Bux0QyirFvoaa+Mx5UfDOkW7k/XouPQDXiyKI
	 pLLxvlB0fiCHdabW58vyBNvsRxQzqP8GjPCi4WpysZwNt0acnXcb7E836PToT7Y4kDbZw
	 BnSvh9Gn5LlrcY1kBADFeXWVD2pJe6nWZuUfobUNTCuCGv4Hi1atxYdpQT3d+VnOzlYoZ
	 VCVcIUstdi/ug9ac9mFcG93vEeNPPWJcZzLZ21/BICF8Rz3L5w/ggLlQlhy9TtynvtPcR
	 SklRwX2AECLiqEzw3FmtHkMkBG+MLt6SorEnWaL/wwwow1EFzASFwmTBbfN/j3j37tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vR3tl5rcYVRhoPH5G49JZIbjlvVmQOIE/OdqYGwp/A4=;
	b=SMHHQVlOUF19g9RD4yQFCFXVmEO1qVEgMHHIWDDn/jGRRsKCtjcyypBrpR+w2pEauODd
	 Vsi7M6Qdy3U0FQRCN7+2o06iMkjipRGTAOTt1OkVwy+0yLpGwJlPf9mV1HQZWUuxTy16i
	 k9yl0bw/9eMh6vZTIBxk0gwTVGUw1M+lEynr7z+cAvEzS78egPqmGh3M9X2rooEylbRgu
	 U3IvBDdlgwx2l+8xRN3FE20wJXxgkfrrS96Uc9hy2123BPVcqYm1RjVy0LDkdrvp4Kzrn
	 HSiepbRuwXOLSooz+TJnqLlp6+N8ZN05PUmSKTDD9cT6nKKY1AnWiw/7GLDoDTNKGMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nEUgknn5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDDD606A9D4;
	Sat,  7 Nov 2026 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nEUgknn5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7A11F0089F;
	Sat,  7 Nov 2026 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064295;
	bh=vR3tl5rcYVRhoPH5G49JZIbjlvVmQOIE/OdqYGwp/A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nEUgknn5M7IM2sdtI3PDfxX2L9T0DBk4RE6a9h0+o767nVHZBHVlBx0dWwglxf74V
	 dDjlM1JCqVAHPn7lH0pl/nikIvy9hXJRmsl2Fa/atq9Q8qeXKbOGxES9RPgwVLqi3I
	 y91NzKgaduM7HsxL2CS830GWCWEdYEdI7W5WIUTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	"Drew Fustini (Tenstorrent)" <fustini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0389/1257] clk: tenstorrent: Fix refcount leak on shared gate clk enable failure
Date: Sat,  7 Nov 2026 08:44:45 -0500
Message-ID: <20261107134950.292794042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>

[ Upstream commit 3f0655b51eb01dad30d61ced0a81718211f2776e ]

atlantis_clk_gate_shared_enable() increments the refcount for the number
of clks requesting the shared gate clk to be enabled always. It should
only do this when the enable for the gate took effect in hardware. It's
possible to end up in a situation where the gate enable failed, but the
refcount is incremented anyway, so subsequent requests by other clks
that share the same refcount get ignored and the gate enable is never
retried.

Update this function so that the refcount is not incremented when the
gate clk enable fails in hardware.

Fixes: 23c8ebc95284 ("clk: tenstorrent: Add Atlantis clock controller driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/AS8P251MB00013BD9A093C06D2D60E10EC8B42%40AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Reviewed-by: Drew Fustini (Tenstorrent) <fustini@kernel.org>
Link: https://patch.msgid.link/20260924-atlantis_gate_shared_enable_fix-v1-1-303f925b8a3d@oss.tenstorrent.com
Signed-off-by: Drew Fustini (Tenstorrent) <fustini@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tenstorrent/atlantis-prcm.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/tenstorrent/atlantis-prcm.c b/drivers/clk/tenstorrent/atlantis-prcm.c
index 6772035ec8726..bf244b1fbfc1c 100644
--- a/drivers/clk/tenstorrent/atlantis-prcm.c
+++ b/drivers/clk/tenstorrent/atlantis-prcm.c
@@ -397,22 +397,21 @@ static int atlantis_clk_gate_shared_enable(struct clk_hw *hw)
 
 	scoped_guard(spinlock_irqsave, gate->config.refcount_lock)
 	{
-		need_enable = (*gate->config.share_count)++ == 0;
+		need_enable = (*gate->config.share_count) == 0;
 		if (need_enable) {
 			regmap_set_bits(gate->common.regmap,
 					gate->config.reg_offset,
 					gate->config.enable);
-		}
-	}
 
-	if (need_enable) {
-		if (!regmap_test_bits(gate->common.regmap,
-				      gate->config.reg_offset,
-				      gate->config.enable)) {
-			pr_warn("%s: gate enable %d failed to enable\n",
-				clk_hw_get_name(hw), gate->config.enable);
-			return -EIO;
+			if (!regmap_test_bits(gate->common.regmap,
+					      gate->config.reg_offset,
+					      gate->config.enable)) {
+				pr_warn("%s: gate enable %d failed to enable\n",
+					clk_hw_get_name(hw), gate->config.enable);
+				return -EIO;
+			}
 		}
+		(*gate->config.share_count)++;
 	}
 
 	return 0;
-- 
2.53.0



