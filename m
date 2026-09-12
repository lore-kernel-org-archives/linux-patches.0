Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F353421EFB;
	Sat, 12 Sep 2026 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220496; cv=none; b=kJCH1HINUVmltdq3D9rWtuPaWoC1ayqZI8PvQTKDzvjLKohbMpnRetDhrEFFtg3x2dY4m9KqFaW+wLLA67EDAL6tiMd8TdZ12+g7/yUhRkaYQtJp3EN6Uurz4Pkec2XFt/OL/1ujIF1hZQWR3arDvIm10AXVz2cZhCPyqk+i17Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220496; c=relaxed/simple;
	bh=lA9M6n+Omy3X2AmGogcYydzr1rSAw1Wt/LYroLa22ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6YolApNH/bodtGPMIBxdhyQUBvqY6FOqtAkrcDL9Lu10F7cItjW/Vbxr9akiby6jm9X5T9JEsRM+8toiDnZgui3tXalbkESfkjSMte++vnPWsGxeIn19VCo5xRLre3knHKJ8BHoCXz0bfeMbdA/b8t2JhBs2kjVnvzpCEWBJxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5aNjmg5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5aNjmg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388E41F0089A;
	Sat, 12 Sep 2026 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220495;
	bh=Wq+qh45L/YJZO6F9vEDxj8F2kHObxNjNS2mxCbtb71k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5aNjmg59W0qd2Fb4Qk1OWRtX/LLLRrGEp9XFZXk9aZfu1VVqTgdxj6EY7pHbycun
	 Mg6ZBxmPp6Tj0FC52izDTOIDeH+MsSxIIJnWmBm9Kof+wLxv1wR1uONk5OvwtW9pIT
	 ypZkjSs8gpjrUu/5GKTqsobzt1uPB6p51WMlC+bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0189/1424] ALSA: ump: Fix corrupted data bytes at MIDI 1.0 SysEx to UMP conversion
Date: Sat, 12 Sep 2026 08:43:41 +0200
Message-ID: <20260912065611.520308579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
 sound/core/ump_convert.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/core/ump_convert.c b/sound/core/ump_convert.c
index 0fe13d031656..85cc67de6330 100644
--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -258,6 +258,7 @@ static int cvt_legacy_sysex_to_ump(struct ump_cvt_to_ump *cvt,
 	else
 		status = UMP_SYSEX_STATUS_CONTINUE;
 	*data = ump_compose(UMP_MSG_TYPE_DATA, group, status, cvt->len);
+	data[1] = 0;
 	offset = 8;
 	for (i = 0; i < cvt->len; i++) {
 		*data |= cvt->buf[i] << offset;
-- 
2.55.0



