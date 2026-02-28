Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E08342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301752; cv=none; b=FeKqDkYHDvvXXj7Y4s09suz6rwkAMRCBfc2B0QiDDZlcWY9ZmF0mmnxBRJJrJDJpIxgjh17Cb2CiRDJa5Y+eq6HrzUfNcqcVStB/Nqaz5K9TzORPZhBQNT4oR7/SZvqOmHXQM3k5VawPxwMshSf4UmwewxfB1nSwE920xaFPdpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301752; c=relaxed/simple;
	bh=659phb0CeW0nNQ3yoSfmY5u7mDeEXiccDIQFmiOyaHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+0nMygyAsyktpAQvWTfgNWzwyEgYmtlMyJJoAmT8xVI+i/AUgXscOVUvOiWvbismxfDhs3DjqQ6/azF7KBGBbPTl3oeOvznkWWw/r2aYXNt+1DrK4QGXxPf/9384//4gvMb0W7jWa4Jrsq8+btSTuF687pl1l+CeIFfgZAyrk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DDk1I7O/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DDk1I7O/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B2AC116D0;
	Sat, 28 Feb 2026 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301751;
	bh=659phb0CeW0nNQ3yoSfmY5u7mDeEXiccDIQFmiOyaHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDk1I7O/GVLBK0XdNjhIzX4rlk8qmleAOLtgsDiNdoH/YbFETPXTZ2Mx3YlGMX+lP
	 lDhgrZczkay0bESVpP1aRv8Tg/FLsqRUVitZeOberFbRNHKTsnzJ+f2FtB+NNPprMH
	 QWIzxyhpKfOqSt6rzYUtuhm89KUJkJFIVC79Ng9T8J7c8Vo6G2kdEbmRNLYWuC/imE
	 yeZ5Y8BbFkKclt3c+P8+0RCs+buuYJv2EnUDCJ7fQshBaH5R/xL0YCykplQrz/4pmS
	 nq52H85LI7jZNF07GUjSvEOtVO1jVxE6UUrqY6xEamMOojoTobboVKUb4iQ1xxw8Pr
	 U5pZ6e8mJMhEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/385] HID: playstation: Add missing check for input_ff_create_memless
Date: Sat, 28 Feb 2026 12:56:17 -0500
Message-ID: <20260228180011.1568201-155-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit e6807641ac94e832988655a1c0e60ccc806b76dc ]

The ps_gamepad_create() function calls input_ff_create_memless()
without verifying its return value,  which can lead to incorrect
behavior or potential crashes when FF effects are triggered.

Add a check for the return value of input_ff_create_memless().

Fixes: 51151098d7ab ("HID: playstation: add DualSense classic rumble support.")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-playstation.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 71a8d4ec9913b..b13a8f27cda0c 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -739,7 +739,9 @@ static struct input_dev *ps_gamepad_create(struct hid_device *hdev,
 #if IS_ENABLED(CONFIG_PLAYSTATION_FF)
 	if (play_effect) {
 		input_set_capability(gamepad, EV_FF, FF_RUMBLE);
-		input_ff_create_memless(gamepad, NULL, play_effect);
+		ret = input_ff_create_memless(gamepad, NULL, play_effect);
+		if (ret)
+			return ERR_PTR(ret);
 	}
 #endif
 
-- 
2.51.0

