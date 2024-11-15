Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DFD185924;
	Fri, 15 Nov 2024 06:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653853; cv=none; b=YCu25XE+7ScUSTSYKpNDt7ngH0+/+2X5/W2jaN0oS/Zcr4Doo/WixKxasES5hqpBT4QlbvE60n0GiJWi8fcH94nleAN+bfGZhfRKJanFIPMCAM/4p1n9vYEW+7In2TD89g+cmQexZWJBvQPK5QLyc5DZTcHqwlLYlLPGoaLxFRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653853; c=relaxed/simple;
	bh=BfftGcSfMX6L8Xp+29zU91X5MIEGQz5HJsNlOOVqtqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJs1bFGeXrBx1a+t4pWabpz2YpnsHlCl5IYMLs+ekMRdOYXjFwLui5X35ODxCi95nBZ0t3apUkNV/RmEeI85jw9FQarfHRJdCMGRgJ79B2w5Cbt7oAmMHbcHnv2MptByfcGHjV6cokHXclF2ngXV9iM9kDbIMqjdDpA+aER23XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWDTvKSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWDTvKSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B0C4CECF;
	Fri, 15 Nov 2024 06:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653853;
	bh=BfftGcSfMX6L8Xp+29zU91X5MIEGQz5HJsNlOOVqtqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWDTvKSvXC5iHD4U4uuapdujEQrxVofez0pqN5lflIA+zq1M9eaMVyUO5NoRDeVSL
	 8jnjjrGH3RMWYC3kwfGIC5eW8z09faTHy3MiQhT6frqCafzcC4lRNiPf+9yudIYrct
	 t38qKq8dF1t5KIYT6/bxAxW/Q6iO8F7aCdkaoRC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/82] ALSA: firewire-lib: fix return value on fail in amdtp_tscm_init()
Date: Fri, 15 Nov 2024 07:38:04 +0100
Message-ID: <20241115063726.543189224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit 8abbf1f01d6a2ef9f911f793e30f7382154b5a3a ]

If amdtp_stream_init() fails in amdtp_tscm_init(), the latter returns zero,
though it's supposed to return error code, which is checked inside
init_stream() in file tascam-stream.c.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 47faeea25ef3 ("ALSA: firewire-tascam: add data block processing layer")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241101185517.1819-1-m.masimov@maxima.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/tascam/amdtp-tascam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/tascam/amdtp-tascam.c b/sound/firewire/tascam/amdtp-tascam.c
index f823a2ab3544b..8ffc065b77f95 100644
--- a/sound/firewire/tascam/amdtp-tascam.c
+++ b/sound/firewire/tascam/amdtp-tascam.c
@@ -244,7 +244,7 @@ int amdtp_tscm_init(struct amdtp_stream *s, struct fw_unit *unit,
 			CIP_NONBLOCKING | CIP_SKIP_DBC_ZERO_CHECK, fmt,
 			process_ctx_payloads, sizeof(struct amdtp_tscm));
 	if (err < 0)
-		return 0;
+		return err;
 
 	if (dir == AMDTP_OUT_STREAM) {
 		// Use fixed value for FDF field.
-- 
2.43.0



