Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53A71D6AA;
	Wed, 28 Jan 2026 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615993; cv=none; b=rFw7H8roqf/bE5uo/vC0O+/w3XRMlg3IV8kqJf7WY/XUWKThDxnTXZZTRpArCPuz5OYTGSmMKBZZX6ErZmtYfgxI8uSPpggiGBtk8FNStPdVTjCnIXB8I/e0fByagYXowqgk49wa6NOpvP/WG1MF1zBDnvZICpsPztkmQp7araw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615993; c=relaxed/simple;
	bh=cs5inTYcZ3ecUvzwf/n8HqrBvY4oNRFHh1GxKucC3AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3wgAeeVEkBvZlanA/I6t0qboBEcnFbGqPtU0XyZEXpEghnmfS9rtl3yLc3825WKPaWYzIV74XFo8jngb5eHdlGsehmUt/knz3ILKcccK14g1v+hkE69u22G67LO7sWcSz3lTLb738hcemutW0dwr6vh+TqMA4SIIeaOrdu3Wzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G39aousu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G39aousu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B25C4CEF1;
	Wed, 28 Jan 2026 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615993;
	bh=cs5inTYcZ3ecUvzwf/n8HqrBvY4oNRFHh1GxKucC3AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G39aousu1VNiQqFW1r/9OD9wKULS6jj4i5cYcpIIywog3JiRw1u35ufgydsLeHVGM
	 1+fHd8CE9TsC2OZNarBTa+gd1WQXMRSCl7CbVX8oo8ea814DOY5ej9X/er2WBKRo6A
	 AeQJ7ca/yXcCs70EafYQTTYdpiIRnt/kNCjZTwGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 168/227] ALSA: scarlett2: Fix buffer overflow in config retrieval
Date: Wed, 28 Jan 2026 16:23:33 +0100
Message-ID: <20260128145350.497322893@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2533,13 +2533,13 @@ static int scarlett2_usb_get_config(
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


