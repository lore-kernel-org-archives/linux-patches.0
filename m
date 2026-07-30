Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4273941D625;
	Thu, 30 Jul 2026 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423857; cv=none; b=VtNZcRaLM+jZxCM1HrWHn6QX6R8PF7dLWMbv6CYyEuVyMy/iyn6mhPSuVcSiZZ2HMq3oL58E6jN8YlZTxYM3nopJFEVh4wmA5Wz0aLF1fB57I4YZ0rk9dSe6Q97W17LGjNOFXWbpkhpq00vWGHSknJDV8xuIAaD9zjhexB9ardw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423857; c=relaxed/simple;
	bh=ivGcsHc8F/weyFXWnSzyeh0s2Acb10GjEcMo/FrdgUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx08c7MfEJFdiJVjVM8ro4EtkerwhuiKnkQdM5CPNoYUBctMM5H1LCT72EWRYdFK/BIGw9OAqzIxrdsCzQMJ1ZvfX6SZDJiAwo0VMBPyX1D+SOiDtEJEWOHDpqwpAZDCkMyWgYTXObRV/imM6LpngKT1vC0UrEknJz0S9mZqhDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlE6mbhh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlE6mbhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DB31F000E9;
	Thu, 30 Jul 2026 15:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423856;
	bh=YksPQzfI+KNLijx9AtsiImP6y/duT7g6EVB8CBUixz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlE6mbhhhuXVjo6oRBaZbMi44ILFZV/EpDPrvqjnhVsQbS+934kxz00pqcvHsxJn+
	 Kycd5X71iLuH976TK/H0e3Cz1gojeKMkAkRwj3gL76VGKS8lUBf5PCy9u1mkZbjmd9
	 bZYA4BP0cotOWoYWhqBie3LJsbDiyV1tHUu/qZ40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/675] ALSA: hda: cs35l41: validate and free ACPI mute object
Date: Thu, 30 Jul 2026 16:08:40 +0200
Message-ID: <20260730141449.181850780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 3b597d24dc0455ae926f1053f97c2725038fc3cd ]

cs35l41_get_acpi_mute_state() evaluates a _DSM method to get the ACPI
mute state and reads the first byte from the returned object.

However, the returned ACPI object is owned by the caller and is never
freed after use, so each successful query leaks the _DSM result object.

The code also assumes that the returned object is a buffer with at least
one byte. A malformed firmware response can return a different object
type or an empty buffer, and the direct ret->buffer.pointer dereference
can then access an invalid pointer.

Use the typed _DSM helper, validate that the returned buffer contains at
least one byte, and free the ACPI object after reading it.

Fixes: 447106e92a0c ("ALSA: hda: cs35l41: Support mute notifications for CS35L41 HDA")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260708113625.752913-1-lgs201920130244@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l41_hda.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l41_hda.c b/sound/hda/codecs/side-codecs/cs35l41_hda.c
index 438a19bd979bfe..de2fd6471f0598 100644
--- a/sound/hda/codecs/side-codecs/cs35l41_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda.c
@@ -1437,10 +1437,19 @@ static int cs35l41_get_acpi_mute_state(struct cs35l41_hda *cs35l41, acpi_handle
 	guid_parse(CS35L41_UUID, &guid);
 
 	if (cs35l41_dsm_supported(handle, CS35L41_DSM_GET_MUTE)) {
-		ret = acpi_evaluate_dsm(handle, &guid, 0, CS35L41_DSM_GET_MUTE, NULL);
+		ret = acpi_evaluate_dsm_typed(handle, &guid, 0,
+			      CS35L41_DSM_GET_MUTE, NULL,
+			      ACPI_TYPE_BUFFER);
+
 		if (!ret)
 			return -EINVAL;
+		if (!ret->buffer.length || !ret->buffer.pointer) {
+			ACPI_FREE(ret);
+			return -EINVAL;
+		}
+
 		mute = *ret->buffer.pointer;
+		ACPI_FREE(ret);
 		dev_dbg(cs35l41->dev, "CS35L41_DSM_GET_MUTE: %d\n", mute);
 	}
 
-- 
2.53.0



