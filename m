Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36040340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301020; cv=none; b=tvaudgrB0Y9TimsfMSYTvf/C7Wxf8cye69Rfvq6adQAqZE9pBFiDwcEktEDHvzpbqsOXa3mckespDMyAaWFHRmKgGHr4ImK4z4DzsKy8r5A1ECq1P8R8EIuq/HRJ7+OaXrWH4bsxdC/ZS4PMhyAbiwg9B/R63+rwXcPHz/f5zkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301020; c=relaxed/simple;
	bh=yKsvD2YtzuvtxDbpqNH9SY22GB/GFuAqSTj5wKz7q3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0E/pKI4TtDFBBP3s12weX25hUZ52PgZtB1IBzfaY4wlXqeSfd89MP3ZMwHa1KCUU8E5XIOBj1Tzs+ZPMgr/NgpeQ2ELP2G+3a1uWSew4mDib+FREdUSINk7AdAc1e5reExEQGdtWzh3kJwTx+kweM6elJftoIXVCP1nnTlUqLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sULN68of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sULN68of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84184C19424;
	Sat, 28 Feb 2026 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301020;
	bh=yKsvD2YtzuvtxDbpqNH9SY22GB/GFuAqSTj5wKz7q3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sULN68ofpJfG7etA+9qq9G+umvNDykdzuWK7bGtgQULIK/oNKsTZw7+Dvj8d9fC3Q
	 Kd8ALbzp1P5O3dxV7vQEybAzQgToWJCJs6mcJsgf6UfGA6KusOUc1iBqs1HzxJvRnb
	 5aJv+r3qPf48dSQzVkbHb/b3yBgFZ8yjhrCXYv/RMSLGZXa+PJjyNMmZUny6f6Lyg9
	 vF4C8lx2t0nXzRb4v0GkAu5XUlwwrAjI0uGcFi2sBPJkfxuz1WQ0j7E1wUbq2YKhKu
	 ++enF7iOC49U6H7rwO4mGjFhBOcqaybefC1Ysin7qc54dKcfosckxDfZgeABQWnIz2
	 UNaKLM2UbTgUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 156/752] media: solo6x10: Check for out of bounds chip_id
Date: Sat, 28 Feb 2026 12:37:47 -0500
Message-ID: <20260228174750.1542406-156-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees@kernel.org>

[ Upstream commit 0fdf6323c35a134f206dcad5babb4ff488552076 ]

Clang with CONFIG_UBSAN_SHIFT=y noticed a condition where a signed type
(literal "1" is an "int") could end up being shifted beyond 32 bits,
so instrumentation was added (and due to the double is_tw286x() call
seen via inlining), Clang decides the second one must now be undefined
behavior and elides the rest of the function[1]. This is a known problem
with Clang (that is still being worked on), but we can avoid the entire
problem by actually checking the existing max chip ID, and now there is
no runtime instrumentation added at all since everything is known to be
within bounds.

Additionally use an unsigned value for the shift to remove the
instrumentation even without the explicit bounds checking.

Link: https://github.com/ClangBuiltLinux/linux/issues/2144 [1]
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[hverkuil: fix checkpatch warning for is_tw286x]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/solo6x10/solo6x10-tw28.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-tw28.c b/drivers/media/pci/solo6x10/solo6x10-tw28.c
index 1b7c22a9bc94f..8f53946c67928 100644
--- a/drivers/media/pci/solo6x10/solo6x10-tw28.c
+++ b/drivers/media/pci/solo6x10/solo6x10-tw28.c
@@ -166,7 +166,7 @@ static const u8 tbl_tw2865_pal_template[] = {
 	0x64, 0x51, 0x40, 0xaf, 0xFF, 0xF0, 0x00, 0xC0,
 };
 
-#define is_tw286x(__solo, __id) (!(__solo->tw2815 & (1 << __id)))
+#define is_tw286x(__solo, __id) (!((__solo)->tw2815 & (1U << (__id))))
 
 static u8 tw_readbyte(struct solo_dev *solo_dev, int chip_id, u8 tw6x_off,
 		      u8 tw_off)
@@ -686,6 +686,9 @@ int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch,
 	chip_num = ch / 4;
 	ch %= 4;
 
+	if (chip_num >= TW_NUM_CHIP)
+		return -EINVAL;
+
 	if (val > 255 || val < 0)
 		return -ERANGE;
 
@@ -758,6 +761,9 @@ int tw28_get_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch,
 	chip_num = ch / 4;
 	ch %= 4;
 
+	if (chip_num >= TW_NUM_CHIP)
+		return -EINVAL;
+
 	switch (ctrl) {
 	case V4L2_CID_SHARPNESS:
 		/* Only 286x has sharpness */
-- 
2.51.0

