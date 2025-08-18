Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BDA22A7E0;
	Mon, 18 Aug 2025 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523855; cv=none; b=AzFb/rFeMwPrfdN8haGxrAqkRFnHRHAGeVup1fpuoevOKZCruYd8khXcPE1sHu63XYe1Na5pFjhovLUfgMY7p/tsXhajHghw65A2T6gITJKE5YT1mNXabmSVoOjzPX14Nmf/Z8MSmsKwVQJUlWkHoT85wp6vBDKOvpEI9yJj1Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523855; c=relaxed/simple;
	bh=aA25WD4uNjeTRql57BX2I4XTriD2zitYYJwu67ATZaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDtl/8p0i4UsbIYrJNiaJyHqb7DorYcnL2CbF6CeZ2DX6/shdSvV0f4hoT/c3MxM+vITSihVoa0EM+qWQyhlrKPdIqYWBRuo2WayIaJ9lDnBd02Uy5d6fwY4AQgg8WMFEzAlPZP5wqBGzsgX/1RaFaLSuJURY4WSKws8YLB1yLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rctK4Fxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rctK4Fxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533A6C4CEEB;
	Mon, 18 Aug 2025 13:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523855;
	bh=aA25WD4uNjeTRql57BX2I4XTriD2zitYYJwu67ATZaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rctK4FxexXADZ11kIVO4qwkmYrvyBURCmFFK/o71yxWVKNoELMqhYyRvSVOfFMXTE
	 uczf/i+WO04AX5cvMTrGNaGAuCFv//ZWy+bskhHjqeZHkvQm6kQzqra4nSDLSRg85E
	 9CRQh0zso8xmCGZROHna3UB4M9C64xu33CGnQeEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 261/515] wifi: mt76: mt7915: mcu: increase eeprom command timeout
Date: Mon, 18 Aug 2025 14:44:07 +0200
Message-ID: <20250818124508.470814430@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Bauer <mail@david-bauer.net>

[ Upstream commit efd31873cdb3e5580fb76eeded6314856f52b06e ]

Increase the timeout for MCU_EXT_CMD_EFUSE_BUFFER_MODE command.

Regular retries upon hardware-recovery have been observed. Increasing
the timeout slightly remedies this problem.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20250402004528.1036715-2-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 45dd444ce360..cac176ee5152 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -208,6 +208,9 @@ mt7915_mcu_set_timeout(struct mt76_dev *mdev, int cmd)
 	case MCU_EXT_CMD_BSS_INFO_UPDATE:
 		mdev->mcu.timeout = 2 * HZ;
 		return;
+	case MCU_EXT_CMD_EFUSE_BUFFER_MODE:
+		mdev->mcu.timeout = 10 * HZ;
+		return;
 	default:
 		break;
 	}
-- 
2.39.5



