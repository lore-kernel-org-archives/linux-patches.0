Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ABD28853E;
	Wed,  4 Feb 2026 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217370; cv=none; b=W2t0uB0SkCXpa/7c6zpaj9JBIYuwQTIySivWfU6yaeg73bKOiZao/esoicNI/jVN8d+XWVyBTpfY4Pa7zdy/noytrKvfGex422ohHBMaOOGOfdhmcZQDKAW8+P32eRmesn0+U8dyPg+vcjOFuyXpM4aXwY0nGMzzw7opt+v4b9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217370; c=relaxed/simple;
	bh=DquUkTpWjVi7jbM9Zf69QazA2CGiESSuQVN+F90KtT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sm+ScOuvR0/OqbXagHYfWahH8gJpDstVsh9kHI0a0JQUHqeo8rQLNH7veRLU58LyojP+TlJIj9+tQtuKfmdDfYd1ZtAR74kzWCWJidTe9tvRHV8G8EYnkXzwawzd+2SJyA32+RdcitJvSDi0huff73pTCqYdnRJo7bedZibUZ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNTQFq+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNTQFq+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E536C4CEF7;
	Wed,  4 Feb 2026 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217370;
	bh=DquUkTpWjVi7jbM9Zf69QazA2CGiESSuQVN+F90KtT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNTQFq+rxJw+v+AN8kAjtWVQzHT2EtRPD3vNDxNLpcgsQYTdzVN0+3LdD57ZgHgfI
	 WF1phrLcXmDEst75aywoe9jzvCZwwYcDf160de5bA982emE6KzHOtc9k2sArLp4Aqp
	 5RnEWQkf4YRKMGk8qMVpwtfBIxRAJ4vptx/PLu3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/206] ALSA: scarlett2: Fix buffer overflow in config retrieval
Date: Wed,  4 Feb 2026 15:40:01 +0100
Message-ID: <20260204143904.331794827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 sound/usb/mixer_scarlett_gen2.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1194,11 +1194,16 @@ static int scarlett2_usb_get_config(
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


