Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD0F1E2834;
	Wed, 25 Feb 2026 01:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983146; cv=none; b=kwKKHsXmVAs4k7wUp0HJsbl2SaTjHbfOaJmAJGDyqPW8UQTF3fqVQJFG8diRP7b9qvC/TQsFGhRm05iHXJlAe+voKEn9/Dxh6uQL8hlSL5YCcfAI+ySMjJnkySoxd9X6VjhWFeQKxG+XB8tQOuT1S0X9WZrjJIo0YDxEOwbiy5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983146; c=relaxed/simple;
	bh=GTdNBxEgwYviG4Kwq0HUD+NfetBo73c6FG9tA92KfeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcNRDQV7yeqc1wnHb5JYjhjcgYM4NP3vHEZqVmOBcs4cCKOARiP4O+Y2YwvQ+Wurpqe8AhZpJNkczo1UP/eRMAO8daEI4GLE/SYA7Q5z24zbGGqc00Q0sD0RozoB0h6izfi+bzRXYapTM91nNu4QEn3gpD9sKxRj8832Id40DjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDBnCC9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDBnCC9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E8DC116D0;
	Wed, 25 Feb 2026 01:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983145;
	bh=GTdNBxEgwYviG4Kwq0HUD+NfetBo73c6FG9tA92KfeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDBnCC9oz6+XOsF3zDK0o7cNKvHvUk5zX1PyfbG7wEjc6yCgt9M02U6CGd4ForSlD
	 KwmE3JidWwTFbOmOJnAfnHcF5u/ewQ+GsDAtBDqaXnMtSkAv8lsodMnkx5gefo0ccC
	 bx7yy1/lcjjHRSTf1LcFtwaTcwO4ekRL3YnYC26k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 257/781] HID: playstation: Add missing check for input_ff_create_memless
Date: Tue, 24 Feb 2026 17:16:06 -0800
Message-ID: <20260225012406.008590727@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index e4dfcf26b04e7..2ec6d4445e84b 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -774,7 +774,9 @@ ps_gamepad_create(struct hid_device *hdev,
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



