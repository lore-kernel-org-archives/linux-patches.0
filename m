Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1352A2DC77F;
	Wed, 28 Jan 2026 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614754; cv=none; b=uF+z6x9XQTTUJSxx5vabYiSm2f1nOtrZ+h/Sl17Tr4TpyFzE0px+uGhgl5cwQQLo1sv2HyFLNl3tbUrMFBfdhxqLeJSmiWDhTmTAdr8xdSqGCXojJI87uhkqXMDLJHMZ7E23rmJZAl1jo9gIx47JBLRu9+cTZDkUJPNDnIneIEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614754; c=relaxed/simple;
	bh=tjA+2dE87MOGAkz0mADc4XXfNH1VV3/VYH1+HaocH9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fn1Gp09QzuydETGPvVamaeuE6jFVhAnpGLCuK/vq6kjFvn8/hh8ivP6zQmn88V0yiu0PkrcPExQew0Jwsw7TWj9NIf1lBgWaPk+pJXopvNejFmDhBiXdFf2/C1FY+/39LsiM5oGPvPGiMlXof14iW///SDTYSntg08HB4G1YGvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1lunQ5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1lunQ5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330B0C4CEF1;
	Wed, 28 Jan 2026 15:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614753;
	bh=tjA+2dE87MOGAkz0mADc4XXfNH1VV3/VYH1+HaocH9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1lunQ5fVVdw+++svyQoBug5YQNELiDVZKzYqgurmiyqjUznB3L4PQkoi68+PBeMa
	 /BQSr7h8CDSfVvNSSND4giQGQXXxeQKqgBFsb9DyvyoXAK0fyEXYqbwVVo/BK1KAHp
	 TJtJRflVsGPR6I7eA6++NE3r4QeTMNjXyfAsf42I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/254] ALSA: scarlett2: Fix buffer overflow in config retrieval
Date: Wed, 28 Jan 2026 16:23:27 +0100
Message-ID: <20260128145353.101247089@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


