Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1562C3254;
	Wed,  4 Feb 2026 15:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218296; cv=none; b=KHSqNoXFWbb2J7hn0AFDyo6m9xh6Hju8jgTokOhhCS1I1s7DDvmL0QG0mgBt568+fgM0VzXWqgiCaPPP/7dp9AJOhTreBIsKslbyk7VDODg97gXEebNCQ8rAl5iZ48LJqidqSxXHAhLxuLJ0TAykTrrOUrnzYz+aVnjtHkKDjwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218296; c=relaxed/simple;
	bh=YARGO4eLUQasnuLB7qdbR/Pk1OJteSo1S5FFYpbISVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMY7ituG7k5U1nHKWgDd26UHhrJURQzG1YvWz8xtkGIfAgmAkjTKVLxMGGjGt1hv6ry1qmjIEGCQRZdkblJgLtUjkVl6+iGuoOlVpjdKvwbcJRMBjKe25Ikc2uVucAqRQtVflt8d95k3FpmIW9REBTt9p3W4R9K2bhb7Ip0NgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guPTyfx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guPTyfx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DE1C116C6;
	Wed,  4 Feb 2026 15:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218296;
	bh=YARGO4eLUQasnuLB7qdbR/Pk1OJteSo1S5FFYpbISVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guPTyfx0atbC+J5bPOlcAgj9S1uYRSzEFeaRGR2YJHFipMTOILfE7BZziJ2cuCzfX
	 KDQZpaK7ZnTjBv8FZFW5lHCZEDtqktHTA1PVeKTEtSrHZspg+AObX4fcukHWq2Nw/8
	 PA3kU62f/tb1l2w/bfj/korZUeRWj5qDPGPNc7ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/280] ALSA: scarlett2: Fix buffer overflow in config retrieval
Date: Wed,  4 Feb 2026 15:40:09 +0100
Message-ID: <20260204143918.080987529@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit 6f5c69f72e50d51be3a8c028ae7eda42c82902cb ]

The scarlett2_usb_get_config() function has a logic error in the
endianness conversion code that can cause buffer overflows when
count > 1.

The code checks `if (size == 2)` where `size` is the total buffer size in
bytes, then loops `count` times treating each element as u16 (2 bytes).
This causes the loop to access `count * 2` bytes when the buffer only
has `size` bytes allocated.

Fix by checking the element size (config_item->size) instead of the
total buffer size. This ensures the endianness conversion matches the
actual element type.

Fixes: ac34df733d2d ("ALSA: usb-audio: scarlett2: Update get_config to do endian conversion")
Cc: stable@vger.kernel.org
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Link: https://patch.msgid.link/20260117012706.1715574-1-samasth.norway.ananda@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ add 32-bit handling block ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -1408,11 +1408,16 @@ static int scarlett2_usb_get_config(
 		err = scarlett2_usb_get(mixer, config_item->offset, buf, size);
 		if (err < 0)
 			return err;
-		if (size == 2) {
+		if (config_item->size == 16) {
 			u16 *buf_16 = buf;
 
 			for (i = 0; i < count; i++, buf_16++)
 				*buf_16 = le16_to_cpu(*(__le16 *)buf_16);
+		} else if (config_item->size == 32) {
+			u32 *buf_32 = (u32 *)buf;
+
+			for (i = 0; i < count; i++, buf_32++)
+				*buf_32 = le32_to_cpu(*(__le32 *)buf_32);
 		}
 		return 0;
 	}


