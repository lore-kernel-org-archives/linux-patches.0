Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0D341169F;
	Sat, 12 Sep 2026 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216806; cv=none; b=Ad5nMk4f9c63JF3J57qTAaqM23MofckX5KCUgz+tLIEdy43XIRGwIgBdKjZ4jHRPOpnMzU+rQ3GRmVNcHQ41l5ohe7YVe4Iz7DZ9xzxfeowOJEuoearwCKAPY7TloTJoSTj2QkqcJfBCf2wfGPR9vu5EgamP7aBot2uB4XgtNR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216806; c=relaxed/simple;
	bh=jGzxtid/+CW/mQikFcDUBRGfYhPln4RDqKYpdH3D0Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBdWtsccmBw8IH3+VAPYD/W3SyI0zrUGzto7LOd26TVVN3accMP9zCWVc1hSo0uBdPJRPPDc8MfkvBj0NivCgiGIKtnfKiESN7Wh6dgnwRJ6jFTHxQeHn7mD1JgMWZXZJ3ZdwPJ/6bahWxjJK4qPX1yfXXoHHfc2mfm8shFUBM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXpmmMQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXpmmMQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB301F000FF;
	Sat, 12 Sep 2026 12:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216804;
	bh=rnR51BYZ9VPyihu3+xAwwMDAtP2/6KHjxyTSPSqAFOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXpmmMQkHGUZ+DVpt9gmtCaM4D+ulzwyFkQteZ0/6X6PG1uUgDJ7AZrlfSwhUGa3H
	 2POZiUIaS4mBudPGyu6Pykt+26WTVsW29TwNNyPE7wdrdJsD74BMBfvYyMKZlS3jQd
	 xD2y79EcW70+tbmfT0QrEfEproeFxoliw6mMXleE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0811/1376] wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss
Date: Sat, 12 Sep 2026 08:53:57 +0200
Message-ID: <20260912065625.616934740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 32e9c0960657a..dcebe55c9010e 100644
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



