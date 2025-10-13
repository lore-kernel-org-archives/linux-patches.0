Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4541A30EF82;
	Mon, 13 Oct 2025 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368820; cv=none; b=gvgDfFjelJ1vw87KXchxPE2gw1bF8J/zMMIaWyHHyfu3nie0hW/iedzAjFsmK9Z2IYGfmbj24l/VXbflXHMBGUUHz7ADFdFcQC2aTbtVfkD2JZnngNLAYfLf2ZK03ryT7pQWYge3COr+ekFADbv/JwZPtN/GugzpgcR1GEmB9Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368820; c=relaxed/simple;
	bh=cCKL/GpQBM/yzaZZiRKviiESUFDZ8AGR6HX6jAJx7HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMZv0Oyu5pVm3oKNR9lAsVljef9kbNipAVD3eWvszK41g4OCgHDhHg9oqigsVQyWLW7J2b4B0SeWtwCUnSZiBwjwfCbCtl+9i6SmaWxlmw+/FyEJlb6g5zWwMJiTXfYwgDWdchhXKjVFdzyPBJzXYG2000dwfj891w0+E0WP2H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+Gdag3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+Gdag3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14FEC4CEE7;
	Mon, 13 Oct 2025 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368820;
	bh=cCKL/GpQBM/yzaZZiRKviiESUFDZ8AGR6HX6jAJx7HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+Gdag3xRzw0loy8XKsNw6BHlwyxBbgZBu5Zi6VoEwcixH6tMgpjz4jq5EGROANWS
	 RiNfXKGdXcZGxg5lzoWpyaRyPuK+T4djZvn07Y6VXSCecHTEPv+C+mWXnwPdThJ7SO
	 CQooZdVXsCU7imB66vIgnqHPv7SvsYl48Ei8gSKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Jesus Ambriz Meza <jose.jesus.ambriz.meza@intel.com>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 031/563] EDAC/i10nm: Skip DIMM enumeration on a disabled memory controller
Date: Mon, 13 Oct 2025 16:38:12 +0200
Message-ID: <20251013144412.416135488@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 2e6fe1bbefd9c059c3787d1c620fe67343a94dff ]

When loading the i10nm_edac driver on some Intel Granite Rapids servers,
a call trace may appear as follows:

  UBSAN: shift-out-of-bounds in drivers/edac/skx_common.c:453:16
  shift exponent -66 is negative
  ...
  __ubsan_handle_shift_out_of_bounds+0x1e3/0x390
  skx_get_dimm_info.cold+0x47/0xd40 [skx_edac_common]
  i10nm_get_dimm_config+0x23e/0x390 [i10nm_edac]
  skx_register_mci+0x159/0x220 [skx_edac_common]
  i10nm_init+0xcb0/0x1ff0 [i10nm_edac]
  ...

This occurs because some BIOS may disable a memory controller if there
aren't any memory DIMMs populated on this memory controller. The DIMMMTR
register of this disabled memory controller contains the invalid value
~0, resulting in the call trace above.

Fix this call trace by skipping DIMM enumeration on a disabled memory
controller.

Fixes: ba987eaaabf9 ("EDAC/i10nm: Add Intel Granite Rapids server support")
Reported-by: Jose Jesus Ambriz Meza <jose.jesus.ambriz.meza@intel.com>
Reported-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Closes: https://lore.kernel.org/all/20250730063155.2612379-1-acelan.kao@canonical.com/
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Link: https://lore.kernel.org/r/20250806065707.3533345-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index bf4171ac191d3..9d00f247f4e0e 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -1057,6 +1057,15 @@ static bool i10nm_check_ecc(struct skx_imc *imc, int chan)
 	return !!GET_BITFIELD(mcmtr, 2, 2);
 }
 
+static bool i10nm_channel_disabled(struct skx_imc *imc, int chan)
+{
+	u32 mcmtr = I10NM_GET_MCMTR(imc, chan);
+
+	edac_dbg(1, "mc%d ch%d mcmtr reg %x\n", imc->mc, chan, mcmtr);
+
+	return (mcmtr == ~0 || GET_BITFIELD(mcmtr, 18, 18));
+}
+
 static int i10nm_get_dimm_config(struct mem_ctl_info *mci,
 				 struct res_config *cfg)
 {
@@ -1070,6 +1079,11 @@ static int i10nm_get_dimm_config(struct mem_ctl_info *mci,
 		if (!imc->mbase)
 			continue;
 
+		if (i10nm_channel_disabled(imc, i)) {
+			edac_dbg(1, "mc%d ch%d is disabled.\n", imc->mc, i);
+			continue;
+		}
+
 		ndimms = 0;
 
 		if (res_cfg->type != GNR)
-- 
2.51.0



