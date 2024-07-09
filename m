Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF3955E4C;
	Tue,  9 Jul 2024 11:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524812; cv=none; b=gjm/rycOJWVi2LS0QUvWsDnhh4HcuFX/RLNSzplsAeJ2b1jo3dYfjBSjAsJN2k2RJkqYgoiOXn7scrAYGJ+YMkoSEaToYCFWhPuOssYibTlnB1xlEJTtrnZhmFX2OA9N+TQ7LryTOiUIRExrHiE6cErxb8o9k72SwuENX1CTbkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524812; c=relaxed/simple;
	bh=FWeAXlbMoSp7HdkTdexExInX99XPyfiswYGILHpLZH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiUyfkJFcaT2Aw2Cu4xdyGW5fjzIF36siG9fJKzSxNnIm48H1SOohjIjBKO76UAY0AhxXnK9wI1f+BHNi294u4f1yJDYwQfnpub8FjAB7zIV8AF85Tw8w2EoEM5+Py2eLDu8WivX4clUPrFHoiXypDXabuRajMFsp71h2I1W3Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEAdurCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEAdurCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AD2C32786;
	Tue,  9 Jul 2024 11:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524812;
	bh=FWeAXlbMoSp7HdkTdexExInX99XPyfiswYGILHpLZH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEAdurCVhMdt+F+LKnvTdZAByVwu8QC4P6HLzf36vGd0Rdd8BGNZDVKTsPRrqiF2O
	 vNPPOqvlMJGX0vlt8cvDqOwnamzos6zYQXhf3ik4WdaL6DYU6WTBOtBKrGt8VznNeR
	 bDrbKBPFWi62W9Hz80l7h0oTZkfbfkPGLZJR3Q1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Wylder <jwylder@google.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/102] regmap-i2c: Subtract reg size from max_write
Date: Tue,  9 Jul 2024 13:10:57 +0200
Message-ID: <20240709110655.026053675@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jim Wylder <jwylder@google.com>

[ Upstream commit 611b7eb19d0a305d4de00280e4a71a1b15c507fc ]

Currently, when an adapter defines a max_write_len quirk,
the data will be chunked into data sizes equal to the
max_write_len quirk value.  But the payload will be increased by
the size of the register address before transmission.  The
resulting value always ends up larger than the limit set
by the quirk.

Avoid this error by setting regmap's max_write to the quirk's
max_write_len minus the number of bytes for the register and
padding.  This allows the chunking to work correctly for this
limited case without impacting other use-cases.

Signed-off-by: Jim Wylder <jwylder@google.com>
Link: https://msgid.link/r/20240523211437.2839942-1-jwylder@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-i2c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index 3ec611dc0c09f..a905e955bbfc7 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -350,7 +350,8 @@ static const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,
 
 		if (quirks->max_write_len &&
 		    (bus->max_raw_write == 0 || bus->max_raw_write > quirks->max_write_len))
-			max_write = quirks->max_write_len;
+			max_write = quirks->max_write_len -
+				(config->reg_bits + config->pad_bits) / BITS_PER_BYTE;
 
 		if (max_read || max_write) {
 			ret_bus = kmemdup(bus, sizeof(*bus), GFP_KERNEL);
-- 
2.43.0



