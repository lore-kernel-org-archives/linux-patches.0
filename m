Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890A937EFE5;
	Sat, 12 Sep 2026 19:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243022; cv=none; b=VVV2kJecb252/67TRDRZ/g3jO7ECeOE+NJyfO0tTiCCQeZiOvgyMpu+JcVxPtAbwVvlnICnBe3HssXpM2tI1DqlStvDt5czgIzA00gELbfoH+OmmmdbtmZ2hRBSfCJzRx3KcxBHpmBnXZ+AXHTHFTDu05z6rWpVVGIlFIuRCElw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243022; c=relaxed/simple;
	bh=+HtiakM2FzEK99QUxaWJ5HrTpOB6IJVWdtdk1aqr91A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5KYhhoWO5CJzX82ZdhQhKiEos0qaV7zfEwG719LgCXPro1DsHS0QUCt0l+ibi4xrV4i58VNitV+3eomato9zzrWA/5h97PO9lbmriNTLDDOHC98Vi4qgDpyKJPVUvpjAbuXzH0/ppi4WfiabHyvrPGiybWTu4Ap1sKo/Jk21dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lyctl+z/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lyctl+z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A621F000FF;
	Sat, 12 Sep 2026 19:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243021;
	bh=UU4/VaXix65lSy+F1FHwHovzdBHnW0SX85PRhcX+Ag8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lyctl+z/iDgSRDYbkelSMz88+Cz+JXoOg/kUKaAYE01y9CL/xv+EBd7g0HB85vsr5
	 HRGZ00ixQMb4nOu2T3LciTi7w3VZCDKjLxxi+km+123zwahpi2vg2Z1xqbY0bsHSZs
	 jocaJW9jOWdi3ixBxnFkF72dx7qkIplnALwQHtvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 556/798] wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss
Date: Sat, 12 Sep 2026 09:03:04 +0200
Message-ID: <20260912065529.873072618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 41054ee43dbfa..53caa5f63a057 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -212,7 +212,7 @@ mt7915_mcu_get_sta_nss(u16 mcs_map)
 			break;
 	}
 
-	return nss - 1;
+	return nss ? nss - 1 : 0;
 }
 
 static int __mt7915_mcu_msg_send(struct mt7915_dev *dev, struct sk_buff *skb,
-- 
2.53.0



