Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B11E41A517;
	Fri,  4 Sep 2026 05:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501261; cv=none; b=PR0WNjN9/TaEJJu5Ts0W5U/r3zFgzLuzpbsdF67Q3sdMUT/W85pDkgkTK3pyy7uHG62nyk7QSKGRp9Vd9SCyFzkoHZP3fsqRp5AhWpqTAysGgkuhnOSopUjwDAwuuxQLlIQapUu3Jk4z4kHCcR7YCYtECDN7Ntv18A0VwmlyNPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501261; c=relaxed/simple;
	bh=Od9PVakcf9CDzTBeIdCM6R6dIgFbJbO20E2aJuqEtyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx66R0Imu8VuLZlQQ5ExSala1ESxbAOJiOG0mUZjtR/GOWPLFHTqFho0Szaj//80qvUK5YlrnB+KwP/S99/owqriONDdL9/lBFSIVQyt20Mc0+05HzovkJXmcZX2GhOf/Y7F/1LMjzxoldkYFBvAt/qQKtN18tYRera1o/8Ious=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MSv4QfA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MSv4QfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDAD1F00A3D;
	Fri,  4 Sep 2026 05:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501260;
	bh=H0qWuULC2kg57ZYJeQIT5Tvj6d/Yb7FIBVvj5tjY1rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0MSv4QfAUElUkYXtC/N6MUXXR1GHOZys60LrWb9HTJaCIp2LWfNG575MZy8bY+tqb
	 8J+i5mR5xrN4GKQyi5+jI48oYTGzMoDWRx0Z47nM5FytrpHzwdyAvPPPFSPlh6497N
	 3brwGBZeuXdMQNQv62TU7c3OwoSRLvdt8U+Nzbmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 345/552] ALSA: ump: Fix corrupted data bytes at MIDI 1.0 SysEx to UMP conversion
Date: Fri,  4 Sep 2026 06:58:22 +0200
Message-ID: <20260904045758.075321325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit 8a906c0b4f1ba123a95c166f644d2383bf30a420 upstream.

The cvt_legacy_sysex_to_ump() initialises only the first word of the
output packet and ORs the data bytes into it.  The second word is left
alone, and the conversion context is kept across calls, so it still
carries the previous packet's bytes.  Those stale bits corrupt the new
data.  Any SysEx longer than six data bytes is affected.

A SysEx with the twelve data bytes 01..0c comes out as:

  30160102 03040506
  30260708 0b0e0f0e

The second packet declares six data bytes and four of them are wrong,
inside the declared length.

The sibling cvt_legacy_cmd_to_ump() already clears the second word.  Do
the same here.

Fixes: 0b5288f5fe63 ("ALSA: ump: Add legacy raw MIDI support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260808014554.3550153-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump_convert.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -258,6 +258,7 @@ static int cvt_legacy_sysex_to_ump(struc
 	else
 		status = UMP_SYSEX_STATUS_CONTINUE;
 	*data = ump_compose(UMP_MSG_TYPE_DATA, group, status, cvt->len);
+	data[1] = 0;
 	offset = 8;
 	for (i = 0; i < cvt->len; i++) {
 		*data |= cvt->buf[i] << offset;


