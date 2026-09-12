Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4298C3905E6;
	Sat, 12 Sep 2026 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230478; cv=none; b=Bbj4tS96kkyH6ndYaVyGxJ989t5sr07yqcHiu6Aoz1w9f5F6nHKIW91ouI/k4pstXXyOKLuo04adpUpyrR1fZVqbR5M9vGuXG6dM8GUWAilDcijRNU8HFMyE3zow6NVXf1h0LnrHg7xHdN2FtGIWzZmNNcPJtaPRxM0tqqH/dCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230478; c=relaxed/simple;
	bh=qZswwdSMX4TSXaUIyIny4S/wtINPXNQybEmOxECFe2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9/HSi58I6EZ82FKIKkYqH1d/Fs1APsaq+2+P5x/7y+lZvvO07sCmh4OzCrFdfeyIjF/3EtmMwveOdebzDy204IeRhnmBFZEcNb9+9mB4wf15gzOS7WdFptkqXDsmUvOCOXMAGeGSikkMk2oPnfY6cb/wcmVGqtYhqvKvPES2+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvifdt4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvifdt4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7C51F000FF;
	Sat, 12 Sep 2026 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230476;
	bh=NLKhOeqRfIUciqtqyo4LRPnlAXEgrXHoANXbjGNft/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvifdt4j+cy0laK1v70KQ2P1EziPiKchZWJHtcJ8WKQd2zi1bsfclB5p0gGp5a2/G
	 /Hly11Is+O+SwSaPEHioOUstbrL3CmD6ZD3A4LV2gNZqna2k6jRnqKo9jcQ7TuhfBU
	 zAblp/vwEn2/eO+EDpHtkkSTaomsae44qiyl3tLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0802/1191] wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss
Date: Sat, 12 Sep 2026 08:58:50 +0200
Message-ID: <20260912065606.285149167@linuxfoundation.org>
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
index 32f15974c04a1..ce4e69e04111e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -44,7 +44,7 @@ mt7915_mcu_get_sta_nss(u16 mcs_map)
 			break;
 	}
 
-	return nss - 1;
+	return nss ? nss - 1 : 0;
 }
 
 static void
-- 
2.53.0



