Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952F13FD96B;
	Sat, 12 Sep 2026 09:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204989; cv=none; b=h+aUsxEghsSRTy9NBi96sqlFDK2CTot/ABbzU7TF8U3MVMSKhGaKct7OQ060SybXnOxFCGGWz5yujy+F4VGtGMGlhfhwggCjOc83JWXbar5+tNQQsvLapLS+0QH6daYaqNVEPU2XVHoD7a7Jr7ckPpknEKcNpVqk35uWNJuCa1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204989; c=relaxed/simple;
	bh=WNcBtM+hLuSrZUnnRV8VqNW5YS7K6/5zFOHro2xzCa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr1lq9AwuwcUd1FbB8hnuTD9Jnuu108or5x5VCPCHLnF4CVbloAn7Rfy6HF8mr3AYW4SajuN9h2q5hIM037MdaRphxuFeFBMOCAU14W8WCcwC1lm9gmaiOprf9kpO8s2Qo7oXNfEwnssGpveB5+Lsu4PNrasF+Csk02Jna6p+5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9ZpMaRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9ZpMaRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943D01F000FF;
	Sat, 12 Sep 2026 09:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204988;
	bh=2BRdVaY4aIXKcLcnpQB6Ciz8p72NwedfPS79W8vFuRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9ZpMaRsBQVkhOlMfGYyjboOkY8oXNzAwvRAWVcPBOqcUTlOo7wDzi2yL8c0t18Ij
	 nEdVlQgQ9hyCNYyfIhnlt9gDeK83c/8z7FP7heKP/7DbB5dDwa2ScCJ8Hnxx/zrAlB
	 xWYUTSh0rbDoutw3o6Su1U+dTEuMWoutO0Ke9k58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1725/1815] Bluetooth: RFCOMM: Validate MTU in rfcomm_apply_pn() to prevent infinite loop
Date: Sat, 12 Sep 2026 08:57:55 +0200
Message-ID: <20260912065729.471681299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 44c98fd082eafd49d55a8a4077ff488175b2fe24 ]

rfcomm_apply_pn() accepts the MTU value from a remote PN (Parameter
Negotiation) frame without checking for zero. When the remote peer
sends an MTU of zero, d->mtu is set to 0. This causes the sendmsg
path to enter an infinite loop when fragmenting data, as each fragment
has size == min_t(size_t, len, 0) == 0, so the remaining length never
decreases. The infinite allocation of zero-length skbs exhausts all
system memory.

Fix by clamping d->mtu to RFCOMM_DEFAULT_MTU when the negotiated
value is zero, consistent with the initial value assigned in
rfcomm_dlc_alloc().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 5d150e8623d54..63fa0f542ccf1 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1455,6 +1455,10 @@ static int rfcomm_apply_pn(struct rfcomm_dlc *d, int cr, struct rfcomm_pn *pn)
 
 	d->mtu = __le16_to_cpu(pn->mtu);
 
+	/* MTU 0 causes an infinite loop when fragmenting in sendmsg */
+	if (!d->mtu)
+		d->mtu = RFCOMM_DEFAULT_MTU;
+
 	if (cr && d->mtu > s->mtu)
 		d->mtu = s->mtu;
 
-- 
2.53.0



