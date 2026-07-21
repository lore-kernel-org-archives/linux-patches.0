Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB19305E3B;
	Tue, 21 Jul 2026 22:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671525; cv=none; b=QWDpaaovdpkos5p+XvZX6pO/q31KLOhX+ymKxy/lw+tewHRRptGam8LNdlyj4WAn84Jm3CY+M2W0/4H/lbB4N5/YDO1T/twiAWcdDr7wtsj7vDuv+mYxh9ft77CTVqAdk2iy6bMH+Zr01oTSZWgfFKYpNGf1SoQYf3NvDAkjJ/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671525; c=relaxed/simple;
	bh=CbaEUdpcra0twPa0ltNDlspZvh1s2NvM+1uOsPZItBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsuYtpOxXXR6WRn67i4f0C8/aBx5tLSm8qP4xpbf7fBh39T/lf7e5xg78YGWIkROlx6JCgMejmHISCos32XrgthT+prosBi7eeRX4+2JSRWlmtDWaqjUXLpUSD8scSy2sZ59pH98LCveLbAt1UqQZfhYn8Ql7SXOSR2Tj2wX3Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycISToRG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycISToRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF4B1F000E9;
	Tue, 21 Jul 2026 22:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671524;
	bh=ARBbxNcCGfqn3ZJUYNEQ5p566bzYhm1uQWBaggrIokc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycISToRGSD++uAhpSlIEB7s7H37mTTc9z/kRas0ARh7wcnBYVjcKXSX7/VzQyuhkw
	 Dpi5qA8irqxsmk7jJojT7caaBPVLAeRFC430KjlMQ6Gl4q6jXlww2bQT+2/385pKv6
	 tzVlxZgDYNkU/HeSsSujefXauokCw6gk05ggJ6lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/843] EDAC/{skx_common,skx}: Fix UBSAN shift-out-of-bounds in skx_get_dimm_info
Date: Tue, 21 Jul 2026 17:18:35 +0200
Message-ID: <20260721152412.325434848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: zhoumin <teczm@foxmail.com>

[ Upstream commit c63ed6e1f5fe648a4a099b6717f679999be482ef ]

When the skx_get_dimm_attr() helper returns -EINVAL,
skx_get_dimm_info() does not validate these return values before using
them in a shift operation:

    size = ((1ull << (rows + cols + ranks)) * banks) >> (20 - 3);

If all three values are -22, the shift exponent becomes -66, triggering
a UBSAN shift-out-of-bounds error:

    UBSAN: shift-out-of-bounds in drivers/edac/skx_common.c
    shift exponent -66 is negative

Fixes: 88a242c98740 ("EDAC, skx_common: Separate common code out from skx_edac")
Signed-off-by: zhoumin <teczm@foxmail.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/tencent_2A0CC835A18366643CBD2865B169948AB409@qq.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 46eeaa142a6100..c95130a1b97d63 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -354,6 +354,9 @@ int skx_get_dimm_info(u32 mtr, u32 mcmtr, u32 amap, struct dimm_info *dimm,
 	rows = numrow(mtr);
 	cols = imc->hbm_mc ? 6 : numcol(mtr);
 
+	if (ranks < 0 || rows < 0 || cols < 0)
+		return 0;
+
 	if (imc->hbm_mc) {
 		banks = 32;
 		mtype = MEM_HBM2;
-- 
2.53.0



