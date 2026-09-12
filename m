Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE05F373BF3;
	Sat, 12 Sep 2026 08:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200886; cv=none; b=X2Yx6B0x8v5k3Jjcp5PaahiufQnsVe9y/KK6ip2fZQ/fdO+S3ADhve9Xdcl5FB6RrM15v/iTxFWW0Sp6GssiBcuv8svVkJ9cTDy1fKTMfc8bUPhUuHH95NYRyCiK29l/1FErNMbgR0m574vZtAcJIXxWGL1QOJ+n10F+ggHutUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200886; c=relaxed/simple;
	bh=ZTPJ7emN+/FzKvogDw1kGMtzErRnNkdJFnPyc4WcLUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxMbt2/iASZxTwUR24/CkgGs6Kon88zbiBaHYEhWdYg5nnTXGjFPiT7V5vB7b+9mY0/M2UI1syAX9unpx4/HNhWWKQxosc9ImFGGy6XTwuoZQ3VSquyfuE1B9SqB9vDqcEK23p+buzBo67IIjvsCF3DG9Pak25z/vFdsikxy9qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEOBuTR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEOBuTR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4BF1F000FF;
	Sat, 12 Sep 2026 08:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200884;
	bh=FyOlqTlysrRqbmpZ39GNl4JN2YveiOrTmDwJ0U0EGnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEOBuTR/koQ2Ucgp2maQZbQBQUXCqPRRIdLnCi2WZQ2Ycwy1m9jwg5F36TLhIF833
	 6s2FdDHeK+pItX40ILeKyhvUgMGww0vTIxQGsXB8FHVb0y99ysQXO7M4zL67/f+D4v
	 i2IC7/7sVaW82mdy9mz+IzYzeDJ76R2N02IiNRIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0883/1815] wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss
Date: Sat, 12 Sep 2026 08:43:53 +0200
Message-ID: <20260912065709.649810470@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 4a2f4be532e3ea4e2b536e411793a05aaa51af25 ]

If a peer's VHT/HE MCS map has no supported spatial stream (all fields
0x3), the loop exits with nss == 0 and the function returned (u8)-1 (255),
which was then written into the firmware sta_rec_bf beamforming fields.
Clamp the result to 0.

Fixes: 89029a85482c ("mt76: mt7915: add Tx beamformer support")
Link: https://patch.msgid.link/20260722082610.2699628-9-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index bbb2fedacb25a..119bd35822958 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -51,7 +51,7 @@ mt7915_mcu_get_sta_nss(u16 mcs_map)
 			break;
 	}
 
-	return nss - 1;
+	return nss ? nss - 1 : 0;
 }
 
 static void
-- 
2.53.0



