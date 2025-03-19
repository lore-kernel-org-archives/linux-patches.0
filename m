Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701CE1DED78;
	Wed, 19 Mar 2025 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395195; cv=none; b=ZOUOQJBKKoUKDtkQrQGV6mIoY8LDiH/2Pz0h/g8p6dCltrPbT5iLv5pr5r08yvGYpoux9vuuAF3jW5V5hwQhivOy1QVhTye0ni8yzs0w6GwcYCVqo60/YaRfiG8T8HWegl29cb8LdcNqzzd+IDvtVQ/ZIJhZ+UjyW9qWfUyj99A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395195; c=relaxed/simple;
	bh=HbvNzl3FQu/X1b3xW87I9dsbgEYuE86MIui3oWV8bZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F02lFl9rpDnXwfKWEazO58755NZUfYQp11xkvpwe8OM6YT12H/oMg3Mgme15VCy0twxY4vaGPV12cFU8xz7nGgKd/I7iqBK1xCLP/tttqDeIOBmnS8oZ/RQD7TunQuMWjSngPCvllgLsBCDQMLpMIqazrIHlkval0nhRMwQSgyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgRyqMR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgRyqMR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BFFC4CEE4;
	Wed, 19 Mar 2025 14:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395195;
	bh=HbvNzl3FQu/X1b3xW87I9dsbgEYuE86MIui3oWV8bZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgRyqMR3Ps/Kl5YGxediju6yBWGNx4Q6j9/lXzoZ0DC9m746uAjORDUboeF3jezY4
	 MOc3HpNxpjDrVa4aafjKGkvc4MWsEi2X1jg08YNxKvphBDtoSLfCbwjAJ0vFlub9tG
	 frY7cflNl9cY+Fpk2oE9DNWtK/fLK0iXwUkyK0YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/166] HID: apple: fix up the F6 key on the Omoton KB066 keyboard
Date: Wed, 19 Mar 2025 07:30:27 -0700
Message-ID: <20250319143021.514694111@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9ff40f3b98064..9f3480ef524c1 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -531,6 +531,9 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		}
 	}
 
+	if (usage->hid == 0xc0301) /* Omoton KB066 quirk */
+		code = KEY_F6;
+
 	if (usage->code != code) {
 		input_event_with_scancode(input, usage->type, code, usage->hid, value);
 
-- 
2.39.5



