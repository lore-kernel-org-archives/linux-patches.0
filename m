Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86C035C6A3;
	Tue, 21 Jul 2026 21:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668915; cv=none; b=g7xGizUgZ5MiHYwvZLpPOdfirOvonpX+ITETCuwXGIhpDB/GK/MxGt/vJJtl0Q/Ncl3zolqf6xiZ2TIesT1lr4gpwhPy+bEVN/GrP207CPigzIHk/B4nNKVdrf6ORTq9df5UeOxatr+545ahGGhge2tf98l0Ve+BisSNN4OLEZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668915; c=relaxed/simple;
	bh=BdWLbHaKVPLE79GuclXZgtibzIwnkpQDzrynZyvtgDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3Oc73bj3+ShZCdJrztX/vHUkGALsgRoW4DG5kxfAF/UXXvlZVQQmuxTFVLIlg4S2+PX3t+Fr8GJPQxGafK2GoyGZXzJ+1hTH1Zg47IugaLIz+ZEeUHy9wg9SO8t1ThT27u97Zs2wpxrNBPafOJqw/32hdvfXUlI46yvMj9rXE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGOsEF2A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGOsEF2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDD11F000E9;
	Tue, 21 Jul 2026 21:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668913;
	bh=m5fGBFGT9bkzeJIZ3b0KMK/cVjOrSiXrVjMbBdTvzAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGOsEF2A6U7SyfuDkRxva197hZF5D7M4ZBXiV1rZV2GJDbJ3R9lqq+57T8qis9rd+
	 GeuIq6vqEo+V+hrvPzeyHAz8PEvNHBCNBgqmuZ7U30EoL5LNwPJa3SlckVKmRiwNru
	 3fv+6dmXYwijiwC1jxvZQpWriEjmZdEFbRNA/mCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0356/1067] EDAC/{skx_common,skx}: Fix UBSAN shift-out-of-bounds in skx_get_dimm_info
Date: Tue, 21 Jul 2026 17:15:57 +0200
Message-ID: <20260721152432.574083545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c11870ac1b3c73..c5ff0175aa7eea 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -361,6 +361,9 @@ int skx_get_dimm_info(u32 mtr, u32 mcmtr, u32 amap, struct dimm_info *dimm,
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



