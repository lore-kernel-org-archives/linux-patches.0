Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F558837;
	Mon, 28 Oct 2024 06:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098122; cv=none; b=hD21crPXNTpAZ3yVEwEG2/iPmTFT2bTZb4tw8KUURBBpAGExTQF/XJBGCg3j+4kO/UHiD9JaFsj3ImwDnYpURP7l6BUQGxtklzXkdWLW/gjREXOZMvPVmXoIqSXb+gjib8Q1FtJbas9RevcIQpwYGVkZO4g6jZdt0F/edPfU48I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098122; c=relaxed/simple;
	bh=9JH3D3GxjeBI7wdB5Wcxpq2/LNyD0xJFdIJekVbCIDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fn/29wqFWq+1wzK1JHfy5RsT5123S5Fdny3qaBEleh4PwouZiSf+GfOA1biEtf6MgypOl9VH02uGtHs+F/4kdjFPm0HS2iWIJEKzXFs13CQSDoBHbY6SdecNhbcqXY4qWr427+wwZbqIsUw8+HBmpUxtpniyNmNaCdp/2RV1jjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwrrDG0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwrrDG0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96398C4CEC3;
	Mon, 28 Oct 2024 06:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098121;
	bh=9JH3D3GxjeBI7wdB5Wcxpq2/LNyD0xJFdIJekVbCIDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwrrDG0acFL/H7xJJd/5X0swbIK8HNaaGe2kw2WS9y8W182EGnnxpDaB3O8D0UEHg
	 oU2XkbJ+zFqTwp9OrQX1vlntcYI/B/8Cul+yQwQ1gSmm3NzD+lc3kS+Pc1UGEr/1ae
	 3i1Qt5IdYD7SliNXnJ73p5280nEX5TbomqW3YqYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 059/261] [PATCH} hwmon: (jc42) Properly detect TSE2004-compliant devices again
Date: Mon, 28 Oct 2024 07:23:21 +0100
Message-ID: <20241028062313.503817020@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit eabb03810194b75417b09cff8a526d26939736ac ]

Commit b3e992f69c23 ("hwmon: (jc42)  Strengthen detect function")
attempted to make the detect function more robust for
TSE2004-compliant devices by checking capability bits which, according
to the JEDEC 21-C specification, should always be set. Unfortunately,
not all real-world implementations fully adhere to this specification,
so this change caused a regression.

Stop testing bit 7 (EVSD) of the Capabilities register, as it was
found to be 0 on one real-world device.

Also stop testing bits 0 (EVENT) and 2 (RANGE) as vendor datasheets
(Renesas TSE2004GB2B0, ST STTS2004) suggest that they may not always
be set either.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Message-ID: <20241014141204.026f4641@endymion.delvare>
Fixes: b3e992f69c23 ("hwmon: (jc42)  Strengthen detect function")
Message-ID: <20241014220426.0c8f4d9c@endymion.delvare>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/jc42.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index a260cff750a58..c459dce496a6e 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -417,7 +417,7 @@ static int jc42_detect(struct i2c_client *client, struct i2c_board_info *info)
 		return -ENODEV;
 
 	if ((devid & TSE2004_DEVID_MASK) == TSE2004_DEVID &&
-	    (cap & 0x00e7) != 0x00e7)
+	    (cap & 0x0062) != 0x0062)
 		return -ENODEV;
 
 	for (i = 0; i < ARRAY_SIZE(jc42_chips); i++) {
-- 
2.43.0



