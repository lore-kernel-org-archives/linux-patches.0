Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB87446EC91;
	Tue, 21 Jul 2026 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656132; cv=none; b=Z4w+ZfKZ09g4IRQCkuNpIh2K1pm4y0UmwEdoS5CxlBtBRs3VTgpoC+iKaJXnjeCw5arZqhvJrK/RKaEiGUv7X7iTfZVLPbhhgHo9+tq1khQ/xbVikhbengMxxUyQYuZzUYZA4xuUwIju7vdCtz0IQTP/y+1FtCgtfGa3QLJUcS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656132; c=relaxed/simple;
	bh=XVM6AfxwvaU+I4PvD757nDTv1rUfhyVQR88znFa5kIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwzC6SnB1AiQuun+scTbW3IKL4VwHMOKagcbk+iUa3L6R1vcNHUOC4v7oCx3ZBA/Oj3LAv9kRDJ8D2/uQxh7MLHFZDYZvzI9tZZ4O560iNC1MkiKdChMNk+udgKoXfET6e772zsrf7YgqNBoOPcsqKS04Imi7O/UJaniAqp3coA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No54dF3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No54dF3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B031F00ACA;
	Tue, 21 Jul 2026 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656130;
	bh=upTbGs9EGVD38Ujkhr6OJLpASbl0xEWy2Uz1Z7VnvY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=No54dF3X2+RTwjkMPG4ZtYlCC7H/z1RqSSffF7Wmscg0Cpeq9wzfF42U0kjYArNRf
	 KcwTmAwPf2wZYZwy+9Slt2hCvNIWKLCDvHfKUoVT0OkDbMAQ3+ikyK7/rGiCkPd9Mz
	 LykPx2IlsP9K/9w0eu7sZFhllG2kNSPYj4aGdY+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0270/1611] EDAC/{skx_common,skx}: Fix UBSAN shift-out-of-bounds in skx_get_dimm_info
Date: Tue, 21 Jul 2026 17:06:26 +0200
Message-ID: <20260721152521.124477417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 724842f512acac..ef124729bbae36 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -452,6 +452,9 @@ int skx_get_dimm_info(u32 mtr, u32 mcmtr, u32 amap, struct dimm_info *dimm,
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



