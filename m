Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B240A7E58E;
	Mon,  8 Apr 2024 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582842; cv=none; b=Py1SzOrYNSv2LYHmVRYgNjS9lk1GlribLuKk2jhvGQVxps7FhPewm5xT+00gz3uMrgt77TiYUd8UGnIieIbrhA1EbkrteKt7b+MGFAmpx+QEcbJNsgh3S0RyurWBi6qMt2RfACeRZ75S7M6gy86Fx3rzlhsxihXlQ8Ca30pxPD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582842; c=relaxed/simple;
	bh=k4plPOWPcH9YGQm4plbF/vUIeCDRjMndxdCYPnSE6kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doEOJjH/d6SMnhInJcRMZRfvHO0AFpMpd+YMzx4sIzQcC3DeBS7iscPPYpiiRdwevbNG4QlibfTcMpQ62Ny53zNYGdHxEIxgMoWcIGWnKW26zs+Jm+FzI/9R9gSBs6+OJEGsrFy9XV3edaACk6eyigwvr6OpaWQbjjOL+EukPtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EITVZLDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EITVZLDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B2BC433C7;
	Mon,  8 Apr 2024 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582842;
	bh=k4plPOWPcH9YGQm4plbF/vUIeCDRjMndxdCYPnSE6kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EITVZLDoEOLFKTCITVRC1pwekQ9H2rv16ojsrbEmzuU4UQR4QZeIHSv+x2OO5UBIO
	 yPRpb52+XjtdKG7jycTnseCFmbGfvvh2T4Lcnla+b2Ts9X9GwRjSpQtJEGxQAZowgG
	 AhTMyhUW25BZbv7J9fqbBzJR4vv2S/T9Mc7Ek4d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 128/252] octeontx2-af: Add array index check
Date: Mon,  8 Apr 2024 14:57:07 +0200
Message-ID: <20240408125310.594902811@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


