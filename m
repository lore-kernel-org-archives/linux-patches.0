Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B93243CEE7;
	Thu, 30 Jul 2026 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421725; cv=none; b=LVGkmE9RF1smJP+8P35GuhOhi8c/lOhh0ObZJjkitsda8Qg1srIKefFfLcjossXvPY6Iu+AxU574sIsK7J4hvV70T577I9fEkcgVGCRPkFxJZHxxA/+6RKFymvvNf5SpNjtZ+3aN5UpbnmgRiOGrF24BrfM98lQ500FKmTlpEz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421725; c=relaxed/simple;
	bh=nBusDMeotju5SZ/8eEVm8JuNsOC/RNyoB4IOck8oFsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2CvDZVEr3tp5NkRgERu8VQROZbmKRnKTk7eq9ENRFYwjutZtn7GYgvlug3R2u+bKTSABW9JpbyRsIORW8/9X7oLZejTvC9StiPERZrXEvJ99F4Az07M+AMPU7pqnpeRttFlAFFeywR7g4odd/fnmBIB5Csxa0TmYBpRZiPJuSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh38j/Nu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh38j/Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596D31F00A3E;
	Thu, 30 Jul 2026 14:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421723;
	bh=lK3Ey00ht3SZ+Q6DrUFJpph749/d5QLtKGorvveHf+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gh38j/NuWYlV4p/l5BEnGdStxxpsyA66SNxtENOlJAIi2fc8JyFlS/XUWlPX0xQ9p
	 avri7aOoo6k/DTpJutKOgFuNO9XiS+v4NeTyIYnwBnOH1Fwu4RkiHYwCfWcP5QzZqQ
	 krVOEpL4igXdTGCmO2Ivc6V1t8PG2krIjKTOqsgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 200/744] ALSA: hda: cs35l41: validate and free ACPI mute object
Date: Thu, 30 Jul 2026 16:07:53 +0200
Message-ID: <20260730141448.531111067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 64a5bd895fd1e6..237059ef22f5c7 100644
--- a/sound/hda/codecs/side-codecs/cs35l41_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda.c
@@ -1434,10 +1434,19 @@ static int cs35l41_get_acpi_mute_state(struct cs35l41_hda *cs35l41, acpi_handle
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



