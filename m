Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C586383C8B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302122; cv=none; b=hgvym2INBP1Qq5WYhvpludbgKePx8TpiIhkQkyA7mn1FLPMqGjoROqcjjzP29Mj2MEpBsmQhL9pphP2k3dHoWHHWyu1v91JpC2ioTqWM2WPQYyRv2DrluEMSMTjxZ0DgLQMRrcOsS19YblEKbrB8Ez1++BVgyN9dFobs8MlZAlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302122; c=relaxed/simple;
	bh=ReSrumD5D3WojIuNBeedw7Kni0SaBKY0uxkGqEYAJ/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsL7yhSki0qAvhsk1+TfFii4jGpaK6dYs1W3rClo+WtlYRn39pRKVFMT36OQromLdW1WK5b6Imepm5SCfkC8PPdPUEFKhiLMdJ5CSF1L4R/NHraQsrS3frRMZ2yhkJmnRBnjMzlZSqIFBl5gLQ7E8Drm0FUcJsNgoqCRPuzlO1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e1jqXKBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e1jqXKBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01E1C19425;
	Sat, 28 Feb 2026 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302122;
	bh=ReSrumD5D3WojIuNBeedw7Kni0SaBKY0uxkGqEYAJ/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1jqXKBM2ppBJbo93SGLqknIQRUNTpzj7nkQGftOg4R0GDaBSwJ8QZT+bks6sn4bt
	 3msuANDAusPPttV55DV1X/I0yifhAjEmlGQOJIjhmoxUb0PobEqM/E5pvefEB/+2VE
	 jTxsPNWOH3IvKddQ5Dh1IUTjK17d5oLHJVIM7saY9YPOP4eTo4jhZUvL3mIr78ArPa
	 pkveD1taPS0B4UEoRXIKsR/p0EbK+ZTbcQ9XmtQis46l+CoxQHaVUU/ALVaXvFzbe9
	 2Sx/gsZ1uaEbKpGKLKbzkIvJS57Sttv3psFWgmHM/Slvd5MyEKSPOeohd41X8O/fRz
	 AU2Z+luNvYPSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/283] mctp i2c: initialise event handler read bytes
Date: Sat, 28 Feb 2026 13:04:15 -0500
Message-ID: <20260228180709.1583486-113-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 2a14e91b6d76639dac70ea170f4384c1ee3cb48d ]

Set a 0xff value for i2c reads of an mctp-i2c device. Otherwise reads
will return "val" from the i2c bus driver. For i2c-aspeed and
i2c-npcm7xx that is a stack uninitialised u8.

Tested with "i2ctransfer -y 1 r10@0x34" where 0x34 is a mctp-i2c
instance, now it returns all 0xff.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20260113-mctp-read-fix-v1-1-70c4b59c741c@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 079fb7ca97b62..c8c2c5dc46eb7 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -244,7 +244,10 @@ static int mctp_i2c_slave_cb(struct i2c_client *client,
 
 	switch (event) {
 	case I2C_SLAVE_READ_REQUESTED:
+	case I2C_SLAVE_READ_PROCESSED:
+		/* MCTP I2C transport only uses writes */
 		midev->rx_pos = 0;
+		*val = 0xff;
 		break;
 	case I2C_SLAVE_WRITE_RECEIVED:
 		if (midev->rx_pos < MCTP_I2C_BUFSZ) {
-- 
2.51.0

