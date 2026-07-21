Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7333846F4A7;
	Tue, 21 Jul 2026 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657019; cv=none; b=c2mmsy5Jo9DsDULnKl+2nm4E7pFnH5yPW7vwpjHHKMeUYnaVcMJ+gFaAO2R9CQijlmfeOqjTTsZZlcHQEQPcY4dK4Aiv3qUUIOlTFQyuU1s3IQhQDwuLccPVaOjpxe676DhsRgCVEab3/gMzjtw4tVF2uckRSu6VsXx6V4IpVXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657019; c=relaxed/simple;
	bh=WhCyxxPuYZSVZRy34ec3Rc5aL9yWoefrsk3SfW4s+zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuvTyjUqat2qvfkyMfswdRvXL112hX1sYf8OkLVYLe75XDd3a91xPrpGaVEUV2RHLEpqizOYjyqfjS3/VQCUUPIaabXLHhIVfP4l7K6p0snHEDU6Z6e/CxoHvLOkLRLGdLy4R3T4PLdC2GS4t3SifEmwHgIku0JV+W73ipuq/IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7DeWeer; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7DeWeer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EF21F000E9;
	Tue, 21 Jul 2026 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657018;
	bh=IZcvu8YuX6SwNgKfQSlC0oz6nSrzTMswicVveszqx0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7DeWeerMj4HXR4PTWsz3aW2LLGeBl5gi9JHf0AN1EYCm/A8sH/JKbhdhYUY20as/
	 3mU8NtEzEhpV42Wt+8PLul2QjRZ7JffV4P033Z9ZJ3jNGzeI02YbGTaP4h1vQP9xcz
	 SYEo9BHPxQWu31Kjkh0ysK/Dz8DXYGvqVWJVI+U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0563/1611] mfd: cs42l43: Sanity check firmware size
Date: Tue, 21 Jul 2026 17:11:19 +0200
Message-ID: <20260721152528.041796449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 107cfb983fec41..13d446755fe209 100644
--- a/drivers/mfd/cs42l43.c
+++ b/drivers/mfd/cs42l43.c
@@ -676,7 +676,7 @@ static void cs42l43_mcu_load_firmware(const struct firmware *firmware, void *con
 	unsigned int loadaddr, val;
 	int ret;
 
-	if (!firmware) {
+	if (!firmware || firmware->size < sizeof(*hdr)) {
 		dev_err(cs42l43->dev, "Failed to load firmware\n");
 		cs42l43->firmware_error = -ENODEV;
 		goto err;
-- 
2.53.0



