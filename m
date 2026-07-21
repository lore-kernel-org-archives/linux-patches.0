Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508432DBF75;
	Tue, 21 Jul 2026 18:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660031; cv=none; b=mILpH7KoLi7Ezw2IGZyEczB06cW4MFic6OqZT9nuX1TxnrQxULIrbAxI9n3GlwwIcCUhGMl6Dwjpcx/cOSz8c/uMvLZhz5XpAALzJ2sBFvsaT9TvmKN5JuXbmEC7Cbfk66gDuAzE3o9SHoAq6pK1hMYuMs6NynAZs+oXxkQ4SwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660031; c=relaxed/simple;
	bh=30xXOzS8+k0VsULdPAkCBI5bXXAqNJOqNTX9axRV/Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fwa4agczdsg+f+2SZzlH6oL7JloxsLFRgIaObNKcbB3d7e9shuqHQwCJ4kfZzRA5V/6HP3c4Pd9g3Yi5XJZ9W+BO4+wSzOlSkbwZRvSvA0dEhVSGgrLzuTZIsCKkhDYodpdBmoqJRj6Yc/eE9gRvsRCjfcE5tcSPfUKqBrOqd70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZhMaq9s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZhMaq9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AEA1F000E9;
	Tue, 21 Jul 2026 18:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660030;
	bh=JAQZJ79hSf6N4u67RthSbv52lzihxOwckJMnyQ1V5f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZhMaq9s4RJGS43jLm21/1k5V3tbEauqCeyTSKG3jfvm3EesksfarBAPQbt2KfUd2
	 AeQ9l9a91I1xsG6Qn8u1iZXYbMvrnd2VB8mQO9gnbEn3V1RaWSJW9KPrkItfNl40DM
	 Z/QIKDsiF/D/QFVCTBa78tNaTyB9p96VrW4eLY50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0823/2077] mfd: cs42l43: Sanity check firmware size
Date: Tue, 21 Jul 2026 17:08:16 +0200
Message-ID: <20260721152612.200243472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit b6ef1a74b3ec254f87a6a3c554fe8f8083ebd37c ]

Currently the code checks if a firmware was received, however it does
not verify that the firmware size is larger than the firmware header. As
the firmware pointer is dereferenced as a pointer to the header
structure this could lead to an out of bounds memory access. Add the
missing check.

Fixes: ace6d1448138 ("mfd: cs42l43: Add support for cs42l43 core driver")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260508134804.1787461-1-ckeepax@opensource.cirrus.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/cs42l43.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/cs42l43.c b/drivers/mfd/cs42l43.c
index 166881751e698a..ed6d93893de04d 100644
--- a/drivers/mfd/cs42l43.c
+++ b/drivers/mfd/cs42l43.c
@@ -722,7 +722,7 @@ static void cs42l43_mcu_load_firmware(const struct firmware *firmware, void *con
 	unsigned int loadaddr, val;
 	int ret;
 
-	if (!firmware) {
+	if (!firmware || firmware->size < sizeof(*hdr)) {
 		dev_err(cs42l43->dev, "Failed to load firmware\n");
 		cs42l43->firmware_error = -ENODEV;
 		goto err;
-- 
2.53.0



