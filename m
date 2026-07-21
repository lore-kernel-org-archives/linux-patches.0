Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7568846A60E;
	Tue, 21 Jul 2026 19:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661782; cv=none; b=Cuaxefw/ZVKtgptZhCJKLJyNH0JJ5X22iHh/ZKwEcvW5XfNJKMGyW//9gAxeO33/t69s+WUzTwJiFSu+M8Nf594tpzBWAmbjQSSWHVThaPmu58Ht3VcZZPJC5m/W2Ba5Lw/XA3QgRuJWl9mbL0DXOc42Au4vC9Bbc3rVx5GzhNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661782; c=relaxed/simple;
	bh=47JkOpItVlwZM7NT+fHCFEhMmOpL2TUD8D7J659Hb9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfB/CAgA+7lOY+xx3jLLEkZM3upgEQixa/bmMrD5cymOKqqUTQAml70VP4YLuJ6y3Gz4LmdmPYOiazd2CUWoaKJco6Whswk3Z9gqA0xKXfochxPBxWj9s45WM84SLPGdQ2HhbF3QM3GoOetSo4q53lG2Q7I1bN33jwhVLEV8rrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zB6bnTkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zB6bnTkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D0D1F000E9;
	Tue, 21 Jul 2026 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661781;
	bh=ohfshcdHjlpMKKYHPieBlCiAJlHPesJMkfBidr5Rg8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zB6bnTkOJV+tg5pZCFB5nk4iciwS/EVBpiRi+rJx2dIaGFV42Y+QdNGd0QoY6RSkU
	 o1dGCFwyaSTQteZlQ3uaR/SWnGslvMHkTVXTw9YO4THvj4JdONO2vKw6L7PnrQXDAb
	 T97rgA310xbAgYGVoeWG+lfY/VTgbfbJzSvnv63A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0197/1276] EDAC/{skx_common,skx}: Fix UBSAN shift-out-of-bounds in skx_get_dimm_info
Date: Tue, 21 Jul 2026 17:10:40 +0200
Message-ID: <20260721152450.493090768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 88f5ff249f2e0e..f584165994cb0d 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -417,6 +417,9 @@ int skx_get_dimm_info(u32 mtr, u32 mcmtr, u32 amap, struct dimm_info *dimm,
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



