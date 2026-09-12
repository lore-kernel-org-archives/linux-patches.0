Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02302E7631;
	Sat, 12 Sep 2026 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230483; cv=none; b=TBoWSnwU2vNUT9gM6qGRs94w6ehpEY+nnJjRsARe47Y72S0o2DNbr14bOdrWaRtG7l15HOfGEyaYY8AZqWOXoCkbxsyKZfeE2spj8glB58VjKl7pjLevsg4R4S0d2bGPk8bBRQ+Kd4HWWmZ56lUcBchPnry9z5S3ic69nygbQ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230483; c=relaxed/simple;
	bh=4a9OJZ0jZme/T3mFjfRS+wrK73GVwyBRUpL8pM9jGPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rANtvWyd0HmKArrh/ReJOYZGLiKnBn/Zf8LVdSFH4mgOg2IEJXQGmke7pkoVBHIge2awR0iHO6CyYWri+HBQ/bAY4TvvWdgpKh+vhQXejOONrvR1RyuTG88t0xijzGPahECir/AZwVBAxF/2VnnTFYCROOlVeR1QyIysi4uwPBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2nv6bXt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2nv6bXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D23C1F000FF;
	Sat, 12 Sep 2026 16:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230481;
	bh=RAAZ5wvxzbk++DSKD8LdnWKbcCaoen1w7d4mJiqifyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2nv6bXtlOuo8hzHDPE3QMmZvqJo13mNyuMbyEk6vJ8BofoT6wREutUTbsHPCGOeM
	 qLlCDeZ8cGSgTBUvsmPQDiUSbbE9X75WerAAGT+nB2phkjH7YoVzkt3supHvfuGi8N
	 WHL67ddJT5Prjeb7RzGVmc6m8WZ1o3zQouCpCksM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0803/1191] wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie
Date: Sat, 12 Sep 2026 08:58:51 +0200
Message-ID: <20260912065606.308441989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit dd59a6126a8f1bd52bf6bd057bf0c8307f76a74b ]

The clock enable path for the second adie sets MT_ADIE_SLP_CTRL_CK0(1)
but polled the busy bit of MT_ADIE_SLP_CTRL_CK0(0), so dual-adie
bring-up could proceed before the adie1 clock was stable.

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Link: https://patch.msgid.link/20260722082610.2699628-18-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index 7303b690a64dc..2a8daad98a007 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -857,7 +857,7 @@ static void mt7986_wmac_clock_enable(struct mt7915_dev *dev, u32 adie_type)
 
 		read_poll_timeout(mt76_rr, cur, !(cur & MT_SLP_CTRL_BSY_MASK),
 				  USEC_PER_MSEC, 50 * USEC_PER_MSEC, false,
-				  dev, MT_ADIE_SLP_CTRL_CK0(0));
+				  dev, MT_ADIE_SLP_CTRL_CK0(1));
 	}
 	mt76_wmac_spi_unlock(dev);
 
-- 
2.53.0



