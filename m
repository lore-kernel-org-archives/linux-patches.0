Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E5874BE5;
	Mon,  8 Apr 2024 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582972; cv=none; b=kfJfG3AYl8LaSuxSCJm9hnaUV6awv4bn1lomPFAPCejBEcL8vQjFCpyilEtqk0KFCfmWsq6P1YrOQ0phEWRdgyy+OtKYpkhRpbIQTVopLB9VMT+rTBVE+n+CUHsxduPlJTysPN65h8s6Xqdclx8no46sOvhKpZl5AHR1nRRvL0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582972; c=relaxed/simple;
	bh=aX1d1FWvdpOT1LSvrRhbqRqfDJjF5trs+y/J+HeuRbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olNYdsL3LiLAnHOw9T0pLmm0g9jV0wJEd2BQUqi2dSRacfiCTtu60Zcyxr+rZgbgbOSek+IhDNemGmHkHMH5BLSEOXZhsednkWT7+vTBGNgla+pZQVQPReXFBw/O59rmA4OWc5ri+5OfD+hEbO1V/0rKV88z2Vtkue3olLOQJ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlBc0Tjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlBc0Tjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4934EC433F1;
	Mon,  8 Apr 2024 13:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582970;
	bh=aX1d1FWvdpOT1LSvrRhbqRqfDJjF5trs+y/J+HeuRbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlBc0TjcvkE1s7PAMBZ/oJ+gsod7UKOO9PKr83rmFGH1Iw1RJvLiNYSLVLliJHUYH
	 4gmLqQ2iJ7zoK8gkQCTO+Y7Ye899h/qWO7QM1jzluApxpsqKTWtvz9cS8tYNIQ8oMB
	 Y2z6l9zJDkA0deR74c4ZZJcXs0oVb0A3Xa1DPvtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 126/273] octeontx2-af: Add array index check
Date: Mon,  8 Apr 2024 14:56:41 +0200
Message-ID: <20240408125313.207420207@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


