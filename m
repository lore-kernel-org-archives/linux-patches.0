Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28F54078E8;
	Sat, 12 Sep 2026 10:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209077; cv=none; b=C38G/rFYStKPMoK++vX3sY3UgVGMG5VlqvF7QA/hIA/eRVwi9OkfiQ5bpuqprz6HvSQZXV3fD0QpBgzOZMbBDhysbf0q/vCqndAX8H3EAgoqa0ROnjFMvp9C3rq62IxEy8NFOn0JACYZPBb4Cw2+Gva0B8l8AANP7/5KDuiBfHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209077; c=relaxed/simple;
	bh=o0wUHX6FT3y+uYd8AFuNajGYvlf1+AOlPTxDTZ+leyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmIIqpmeYLloV3k93KPVMjYn5RKOYAZ9TazFYfsjJkuthPwjFjP2fEjdBcN52EClLhuDlBRf38OBDypx4H4HaO3mKFqJG1kFRTXnhVg8dbc30scC5fKBUqUqIRn5xkJZPvZmEQIIuyCM5i0Jg4kAE0Dsd0O1s98B/2S54rYlS8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSJd+Fdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSJd+Fdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC981F000FF;
	Sat, 12 Sep 2026 10:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209074;
	bh=y8GLGEluNHwWjoxomAjaU7XCCqjsLoA8cczu1nEbfl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tSJd+FdySJfi80UmXQEyeiL7eHE/3RVjLgSV8H9v52Sqt9z2l5nyTBaIJFsiAlBpg
	 d1s/KNN0jnJZRATIlmofQAKRzq0sznnOEHBpgw2kqdTnEzXbUDyzIwLxQvjWwqX9kx
	 zqZtpGAzvIAhG7xij+hqmKsXtw6lfRSShPpr4LtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0748/1518] wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss
Date: Sat, 12 Sep 2026 08:48:37 +0200
Message-ID: <20260912065640.352288040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1646b9ba29805..01d6ea6332440 100644
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



