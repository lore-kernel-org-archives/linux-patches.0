Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0290E2FB085;
	Wed, 28 Jan 2026 15:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615218; cv=none; b=kXx5IrCLcJj3yINvvrsTdAPbybmKVaKc2u6wv7C6ZEPIuLtm7JpoCSlBjjbM4Ks29EJmfLm/z2E7SZaiFNyVkpeD1lN3gDxKD/YGORd9us1xC0LCoXYP6D/BqkeLFMgETKJBvunMYZURhp1J0lDAQKcJlCrePSVPF9yJU3jKSJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615218; c=relaxed/simple;
	bh=bIEnHj8p9HOeERQpzYVY8TG7ZQfakaRdQzc3Y9eIvf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA6mQh1pDjyXbL7zZ94ieTOtD4nAXzazy80Xvdc163zlNrWfa3Ov0ouL/IJFeCJ0b/kyc+MTOitpF5CkUtttZHRLCc0WfBIA6h5Vf+f1AjpBMTdK2fjJptrbs+iUNY7giLOceDmJu/DjCQX5gE02rhG4y7gC8gXMRTskkGL3UAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yunJA3LE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yunJA3LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B559C4CEF1;
	Wed, 28 Jan 2026 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615217;
	bh=bIEnHj8p9HOeERQpzYVY8TG7ZQfakaRdQzc3Y9eIvf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yunJA3LEfkNlO6BQjvdxy0LfulaUA5FJXSbq9cY6FKn8pIV1XsUvyjUwP0FItWZ4F
	 bY6jsu95KbyJDPgigkYQAo7vOQEz+WwNjZhOzHwQhp70nNFzGXJdrTExKq07haGcjc
	 OslddVO1p51NY6IhTiVSGp3iOsI+PWtNIUWbwpvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 112/169] ALSA: scarlett2: Fix buffer overflow in config retrieval
Date: Wed, 28 Jan 2026 16:23:15 +0100
Message-ID: <20260128145338.036200800@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

commit 6f5c69f72e50d51be3a8c028ae7eda42c82902cb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -2496,13 +2496,13 @@ static int scarlett2_usb_get_config(
 		err = scarlett2_usb_get(mixer, config_item->offset, buf, size);
 		if (err < 0)
 			return err;
-		if (size == 2) {
+		if (config_item->size == 16) {
 			u16 *buf_16 = buf;
 
 			for (i = 0; i < count; i++, buf_16++)
 				*buf_16 = le16_to_cpu(*(__le16 *)buf_16);
-		} else if (size == 4) {
-			u32 *buf_32 = buf;
+		} else if (config_item->size == 32) {
+			u32 *buf_32 = (u32 *)buf;
 
 			for (i = 0; i < count; i++, buf_32++)
 				*buf_32 = le32_to_cpu(*(__le32 *)buf_32);


