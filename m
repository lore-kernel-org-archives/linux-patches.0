Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8C74ADDB6;
	Sat, 28 Feb 2026 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301316; cv=none; b=qbkrzXWnStJYNo2x9Hcly21fqUHeITpzELYnrIJay7lH8/wefJrD36DM+E1UXPeT76BtNeEpBgkHQ90w0CiKFZr5xxyIyXQPvSoOVl00V/rJC00pr4NXsNDppOGYLqaVzyq/o/ROL6BiiZlJu4sHqD1sI0iarTAPZLkAIak5Rsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301316; c=relaxed/simple;
	bh=jTY4FYVwDJIGe5KfCtsL6WWiMnwR77HoDz51E9tumDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ALDLd9XFW4p5F1b/9EQTJjjaIDqAAHal7ezED0SAtjq5VVlhWr6f3qaSl5GNYYm29nls38WgZOZWfVDKHsylHOlAPzERzsLY466qoO2jMRrmyuo8a4A99TZH6rpZ1G94GpxrHefXV2UJj3fOIYfRmmYE9LC7RKGf+9lLCGdQPY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgo2XCWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgo2XCWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81F1C19423;
	Sat, 28 Feb 2026 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301316;
	bh=jTY4FYVwDJIGe5KfCtsL6WWiMnwR77HoDz51E9tumDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgo2XCWmD+I34SeR33+0xvvvNghIGQWhuKqmAvp03Xu8F6rY+kMiH1hpFA4zXTvzP
	 UMQBderF7iKeNrgZwx0DvDrO5WZEs5cbOgN8j2enKByKfRmoEJyM+28+RTiIvEUcFF
	 xbLsGa2N6Wie4eLhQTGbdwaH9160tlDCqvLwnug+jHe1QjAH2y/yJM6oEGUZO8er/2
	 mfT2GNUz8i/Io1TuGNZ/RYtoa9SzcknYFUE++UiEG2lMv6uc2kUpiuIHNKQtm3X4nx
	 EoGSzVQ99aqkH7+oF+5YR6UTUEll9jgfIs43H6Zof+dVu33QITG7ikVFlscCTH3P6n
	 SX1cEwCak7+Jw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	stable@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 502/752] HID: magicmouse: Do not crash on missing msc->input
Date: Sat, 28 Feb 2026 12:43:33 -0500
Message-ID: <20260228174750.1542406-502-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Günther Noack <gnoack@google.com>

[ Upstream commit 17abd396548035fbd6179ee1a431bd75d49676a7 ]

Fake USB devices can send their own report descriptors for which the
input_mapping() hook does not get called.  In this case, msc->input stays NULL,
leading to a crash at a later time.

Detect this condition in the input_configured() hook and reject the device.

This is not supposed to happen with actual magic mouse devices, but can be
provoked by imposing as a magic mouse USB device.

Cc: stable@vger.kernel.org
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 7d4a25c6de0eb..91f621ceb924b 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -725,6 +725,11 @@ static int magicmouse_input_configured(struct hid_device *hdev,
 	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
 	int ret;
 
+	if (!msc->input) {
+		hid_err(hdev, "magicmouse setup input failed (no input)");
+		return -EINVAL;
+	}
+
 	ret = magicmouse_setup_input(msc->input, hdev);
 	if (ret) {
 		hid_err(hdev, "magicmouse setup input failed (%d)\n", ret);
-- 
2.51.0

