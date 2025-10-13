Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F88BA34;
	Mon, 13 Oct 2025 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367503; cv=none; b=U4PFFxsqqw4wTQ7kd84TE2PXZRLruM/JDXmibglVe5j/tlIWmFE57azIXA35KpvA//bSAJ4mpdYcuUYZjmpl928GH5hr/i6UVSM7/yxphYvqLGuDktfnGizSoVTHbXag6n6d4DCo6GSWs77BnfL54YRJ35thQaPmPkw6/ikG2U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367503; c=relaxed/simple;
	bh=/dvHdz7kjroIMlkmC6dINrkGVhIaskZxcxjFBNP7bnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLTmJm1yO/kCI55gLkG6l89P1yFI0akPyrdUHHO7+GqjT0dmLb5KYiVrxBUJ5bSVn4ZxKp3UyMwzNbqwEMD1OLrNc7x/xlX/nc74o7so8+lLVIxzEjAtkHyGsTeMA+IBjH2SCBEimwziSo0JOCTasYW+wHrtbpqdJNsM3/m9kbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GW5VTyBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GW5VTyBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73409C4CEE7;
	Mon, 13 Oct 2025 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367502;
	bh=/dvHdz7kjroIMlkmC6dINrkGVhIaskZxcxjFBNP7bnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GW5VTyBBev3i3YjS/iRHt2rlKYVULhc0sj6qtWxtFY7UZmjmp2o4q01mZc/72xqd7
	 fSWY0fF0EMvBhnTeVc8EoLq6SMNvsR9RLne9FBXaYpWwqvaFWJqJgClPaZrUp3jRr2
	 Hym33gQix+h2LKmk3DHe0VwRvbscjoe9jhnEQ4D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Jesus Ambriz Meza <jose.jesus.ambriz.meza@intel.com>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/196] EDAC/i10nm: Skip DIMM enumeration on a disabled memory controller
Date: Mon, 13 Oct 2025 16:43:20 +0200
Message-ID: <20251013144315.532046466@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 068597e8fce95..3c70d86074975 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -970,6 +970,15 @@ static bool i10nm_check_ecc(struct skx_imc *imc, int chan)
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
@@ -983,6 +992,11 @@ static int i10nm_get_dimm_config(struct mem_ctl_info *mci,
 		if (!imc->mbase)
 			continue;
 
+		if (i10nm_channel_disabled(imc, i)) {
+			edac_dbg(1, "mc%d ch%d is disabled.\n", imc->mc, i);
+			continue;
+		}
+
 		ndimms = 0;
 		amap = I10NM_GET_AMAP(imc, i);
 
-- 
2.51.0



