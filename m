Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7533438656D;
	Sat, 12 Sep 2026 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239357; cv=none; b=lcge/FIKsliilcBVfqWSViWI9swYbaulXXpBMiWFf2B1iTlj1pXJ47B4t7LzLHxUUZC069qLpLrX+OBHO7wnxcepnhesTF4DFcPsUyRocfKoPi4AiHpKIQdrEO48NAhSO484Jf38tK5ix1sJUNouHYLhrZYvmMf5VINNdLVzytQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239357; c=relaxed/simple;
	bh=tr+MbfHuny4fG2GueotFwm3kgiGpE7SffefpTc4tuSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s//8yhwZ0eS4blRljYnhBdMKCUai9+ZXLvoI2qcq5fYGiRBj69vs9csevwxVPByosVtfvhcfPk7Kq9FbxPQhukFIuVwbWpMan3OY4W7sPozBRCKP45tETLfSmvdtGpz8663yZz572MEnQsuC6PykYET07glrPiLj1lzhS0VcwY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2+gHWdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2+gHWdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170CA1F000FF;
	Sat, 12 Sep 2026 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239356;
	bh=XVZXCdsisK+GgKiLdDyX9x/bd4nf3Fi9vkhJVThM9Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2+gHWdqU9Nt4M1DRY27ETdFJqC8yNjTxvDndPuW4GHeGAfB9Qjfs0rkKR7rOQ51v
	 /T4pRNFuxhhQlZ6iv7HKDtYtO1ijPQnjv1uzY+wwi4MJqDYF/YaLKM3MrvEjf335qa
	 XDgCL0KJsfWgdg22ATr177JuxRdlkcU/4OweG7Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 648/935] wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss
Date: Sat, 12 Sep 2026 09:01:18 +0200
Message-ID: <20260912065541.704801319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index 169055261e9b9..1d7f136ad0812 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -206,7 +206,7 @@ mt7915_mcu_get_sta_nss(u16 mcs_map)
 			break;
 	}
 
-	return nss - 1;
+	return nss ? nss - 1 : 0;
 }
 
 static void
-- 
2.53.0



