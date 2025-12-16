Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1823A3451BF;
	Tue, 16 Dec 2025 11:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886085; cv=none; b=GsImNayLVYQl6cRCyB6+5Mvsn+bznEZZgxHiuo9XUySTjBbyX79NFuJNLJ4CcgLbMREvRmG8f+H+J73zzi4Kq7mTIHgF9PiYYtg2UBxWAe1Tvsbms/niFrkPCsYN1oyoqFmK93f4IUHmkOcHaMLmbdzFnryMhElnLpJckY8nLpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886085; c=relaxed/simple;
	bh=l1S1Vpfuw40NMHSkHrEc48IDY6KIYSjc8uUu6Q1HgIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=be3QwmdsZkQLVi01dMwwqqHt8i28Nx2P3w+Iy+qkjaUYcWRz6XUnZ6FNp1UtnXs6F865Pslcxk1T7uI5Zx7rv4HGuYp0H3caxoOoR+S56cf6hhQMweDmc7V+9mE+quFmhWHcuxa3X2dsbyN4mra71aUb23lSs45b8gCJM1KtaDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eri1zfc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eri1zfc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8458DC4CEF1;
	Tue, 16 Dec 2025 11:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886084;
	bh=l1S1Vpfuw40NMHSkHrEc48IDY6KIYSjc8uUu6Q1HgIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eri1zfc7a0v7g9yERtp8JKCkB/tj6OGTm3ze2RO8P56tXH3uoBd3s5zVnb9rZLT57
	 6yd1J6JkzIFe5iDFm7iH4Puvrh/Dao8qtZGD04Y86xRKUPdG8b9yyL37+0ACpN0kOu
	 yKoFL68M8Hlur+0wPqp9xHgIoCOItfkpCRcRhw+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 333/507] wifi: mt76: mt7996: fix using wrong phy to start in mt7996_mac_restart()
Date: Tue, 16 Dec 2025 12:12:54 +0100
Message-ID: <20251216111357.529128454@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit f1e9f369ae42ee433836b24467e645192d046a51 ]

Pass the correct mt7996_phy to mt7996_run().

Fixes: 0a5df0ec47f7 ("wifi: mt76: mt7996: remove redundant per-phy mac80211 calls during restart")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251106064203.1000505-11-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 30e2ef1404b90..b0092794f37c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1894,7 +1894,7 @@ mt7996_mac_restart(struct mt7996_dev *dev)
 		if (!test_bit(MT76_STATE_RUNNING, &phy->mt76->state))
 			continue;
 
-		ret = mt7996_run(&dev->phy);
+		ret = mt7996_run(phy);
 		if (ret)
 			goto out;
 	}
-- 
2.51.0



