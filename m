Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3226A346772
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302105; cv=none; b=IheFljOsBhyJhXlFlUMvZZ0qf8TeTFc+cXc+mH+8ZMQNtP95yGs7cDS3ORgCUNeTTV8sojV+JfVDQMRcTg0jR9ZiEW5M/FcGnomlbZtXMQcVmfy8NjkZaKIcPPf9xc1z74uWnAaBmuNWV9b0umpOEXubVb0qE0up335DMkheh5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302105; c=relaxed/simple;
	bh=ufSIWzOEOzbzm+08GmYByYTOshZsAS+ZZW+WONif0Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orGPGVuJ4KUQ1dAVc1tN2G00Y0Lpevuv6XCA+jk6h9ICLAAOYulPlBX64qtX+sdkF6gBDr1UYI7etaK0Kq+tLbR/PHMMd8EyWyye/IQbwOGY3ga1igGy1A7ZTY6Ry+lyr9OWY/w7lzSz7ZX8C6qQ0mh0e9fl5AWeYGbbOfc8hwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3j6sH8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3j6sH8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D35C19424;
	Sat, 28 Feb 2026 18:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302105;
	bh=ufSIWzOEOzbzm+08GmYByYTOshZsAS+ZZW+WONif0Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3j6sH8kwHx6I2SwPSiQ9CgXhdeVHZRR9f22HagzopE74ilJl0SzhqzLiQ5jvEYXW
	 C7B9xFml8xPKUlDDedKBa3Ihf4kWt4U8+gmzCGNqK5Cy+pvyYbP8LoZrrz+o++OXAL
	 uRyMJss7dfqUQD2jfJVzEGq4JPIic3tGum4rKopVNJldZ5zc60iStdkvV7mRs849Tp
	 7zKzCRosAGZTfNSTb7WepIsozPmuNoj+6tWQiexsRFRGv9GG7aD0U1fGwss4h9+5Ew
	 PJPmNY+hOOIirJcAUBBngv5C7zaFRyZv3aS67YV/QdCAXH8sD4xQlo9ay+JKnlzw0v
	 983Iv+5fvbC3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/283] HID: playstation: Add missing check for input_ff_create_memless
Date: Sat, 28 Feb 2026 13:03:54 -0500
Message-ID: <20260228180709.1583486-92-sashal@kernel.org>
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
index 32f65c45fdc8a..199f76988bae8 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -732,7 +732,9 @@ static struct input_dev *ps_gamepad_create(struct hid_device *hdev,
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

