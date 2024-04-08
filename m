Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C243E7E78B;
	Mon,  8 Apr 2024 13:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581946; cv=none; b=sahC6CXRQzaLFh6kRhvtkkf1HrAdrFHkjDR13yIwcTwbe1lQCcf9vQjQMHAaiRoNrtKabV78J3Pne7MgPbYkHNHXj7Dxn9FhBJpW/UjqmpH3PtsLw2gPaCrKG8wWe0VZdd6boAZIiz478KF3mFYB/9yHwU1+5KD1cIxl392WG1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581946; c=relaxed/simple;
	bh=6kGF7VRvEahJBigVOfjKtvFGSnT1/SsvTBQcH77zM5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kxq4OneSLJ4ywtm08lN9HfE/yn7p0We2ZTuXG84bnfe/xGIXr9qNHJJOzaZjuuGgQ+5s17Dt2JS8LlJnhBYO7k2DDd0IT3f+jpGtBxEhwwYkxCfNvgVYEmDk7h3szxcLvOAXTfCoyYqYhYAPJ89l9nNIyGanUIVQgOnMeyJLB1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDSKueLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDSKueLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F8CC433C7;
	Mon,  8 Apr 2024 13:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581946;
	bh=6kGF7VRvEahJBigVOfjKtvFGSnT1/SsvTBQcH77zM5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDSKueLZylsCkL7LQxN/npF+EGJdM3R4svXiuQeBzkU1T8Bfl4lsNnKVg+cUYQEbi
	 Q7XTR16hXobSzsz1uoUyH+qyLG4NM+f8Xq70+xz+J6BeR5bEjhN6VCgHdvV75cUPCg
	 uCTE0LuPhcFj+6gLeEc20TyoVs8Bf9ZhHBiynfXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 066/138] octeontx2-af: Add array index check
Date: Mon,  8 Apr 2024 14:58:00 +0200
Message-ID: <20240408125258.273174077@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

commit ef15ddeeb6bee87c044bf7754fac524545bf71e8 upstream.

In rvu_map_cgx_lmac_pf() the 'iter', which is used as an array index, can reach
value (up to 14) that exceed the size (MAX_LMAC_COUNT = 8) of the array.
Fix this bug by adding 'iter' value check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 91c6945ea1f9 ("octeontx2-af: cn10k: Add RPM MAC support")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -160,6 +160,8 @@ static int rvu_map_cgx_lmac_pf(struct rv
 			continue;
 		lmac_bmap = cgx_get_lmac_bmap(rvu_cgx_pdata(cgx, rvu));
 		for_each_set_bit(iter, &lmac_bmap, rvu->hw->lmac_per_cgx) {
+			if (iter >= MAX_LMAC_COUNT)
+				continue;
 			lmac = cgx_get_lmacid(rvu_cgx_pdata(cgx, rvu),
 					      iter);
 			rvu->pf2cgxlmac_map[pf] = cgxlmac_id_to_bmap(cgx, lmac);


