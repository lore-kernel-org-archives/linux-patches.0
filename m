Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1AF26656F;
	Tue, 25 Mar 2025 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905623; cv=none; b=h0GYQiaFhZqg2YrOUUbPJuctJmetulHwX1c55xSzUpdDd+tuOiMzuglofQoyJs10nRL5p8IkaF946CGqM0I2Toyu8mqmnhYJPjqBUfwVwGdVGavUqX9jSJNrCnawxKykEY7b/Io4KxCGX2gQluwa+pUI/C7JpRskoRUwFer5jxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905623; c=relaxed/simple;
	bh=insaydItU3KuHVKde3++Mfxx3x44y5tQcQgQnQuI23I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt7HsSV5Cf4Iz5vct/7xxLVkyWsPqmKDci/oJgP1g4qdb4pbzN2aIJCsok9p6fvG+Lw1NoIRbpqz7+y6uvaS5wHmn/xnXniVoT9XPXzLzcigPSkbBmuLSiAc4tNnont+kQPeDrDbksQ7hj8pQg9XFdrYH0nDY6wd6kirvHQosQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q3jOJSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q3jOJSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB7AC4CEE9;
	Tue, 25 Mar 2025 12:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905623;
	bh=insaydItU3KuHVKde3++Mfxx3x44y5tQcQgQnQuI23I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q3jOJSbnnCBXAgVbTNVZGogNa55L5qFVPCII+WmcQGCDgSV/y1ycAQ+g1k7/H46t
	 FctLVXN+v/Uqd0ieY1VhdfKFJoAMxhw6DHOZptetllXxNt0/vFqA9UJYdBqYM3476R
	 WP339AW4NO+o+HrlSw8iwH/eF/fQ9MYptHIO4vZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/198] HID: apple: fix up the F6 key on the Omoton KB066 keyboard
Date: Tue, 25 Mar 2025 08:20:07 -0400
Message-ID: <20250325122157.818543854@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alex Henrie <alexhenrie24@gmail.com>

[ Upstream commit 819083cb6eedcc8495cbf84845877bcc741b93b3 ]

The Omoton KB066 is an Apple A1255 keyboard clone (HID product code
05ac:022c). On both keyboards, the F6 key becomes Num Lock when the Fn
key is held. But unlike its Apple exemplar, when the Omoton's F6 key is
pressed without Fn, it sends the usage code 0xC0301 from the reserved
section of the consumer page instead of the standard F6 usage code
0x7003F from the keyboard page. The nonstandard code is translated to
KEY_UNKNOWN and becomes useless on Linux. The Omoton KB066 is a pretty
popular keyboard, judging from its 29,058 reviews on Amazon at time of
writing, so let's account for its quirk to make it more usable.

By the way, it would be nice if we could automatically set fnmode to 0
for Omoton keyboards because they handle the Fn key internally and the
kernel's Fn key handling creates undesirable side effects such as making
F1 and F2 always Brightness Up and Brightness Down in fnmode=1 (the
default) or always F1 and F2 in fnmode=2. Unfortunately I don't think
there's a way to identify Bluetooth keyboards more specifically than the
HID product code which is obviously inaccurate. Users of Omoton
keyboards will just have to set fnmode to 0 manually to get full Fn key
functionality.

Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index da8751601534f..86a5e09544c4a 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -497,6 +497,9 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		}
 	}
 
+	if (usage->hid == 0xc0301) /* Omoton KB066 quirk */
+		code = KEY_F6;
+
 	if (usage->code != code) {
 		input_event_with_scancode(input, usage->type, code, usage->hid, value);
 
-- 
2.39.5



