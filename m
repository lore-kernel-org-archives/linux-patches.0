Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994BB3BBEB;
	Fri, 15 Nov 2024 06:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652783; cv=none; b=IV58TTIUTj5mLXGUbPhe3QhTBzcq96d3EvP1Zwp2YtW2WfyMrQEO8QLTox9lgS9uK0APFnqixmNGLsYMGah984dLcydjE/RWV5gwyJd/5m68snrzUAq683lLXGinw8XG5/bmhh3yUlj7MNjQijE7yUOFR44WSxJl7RPb3O+xQ/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652783; c=relaxed/simple;
	bh=/BxEGFN9Qqirb+uLuVg15bd2DRN6MSCCBiuJC939JAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4/hD1LOqZoN8DEJRvW99cY3pRN0SNxnQeR9ajnj0vru3oyNoDQHBdad5NPIg2rhzAvPiqK9wqEdCeBp2IXw1DzvRef0PRJ0IY8vjQ9flPQcc42plLTnLm1NQhZ+erx0OBjwK7cDWUTTbfKvEzHu4SQFfIPKVG9py1acnDwAQAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqZxDU1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqZxDU1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5230C4CED0;
	Fri, 15 Nov 2024 06:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652783;
	bh=/BxEGFN9Qqirb+uLuVg15bd2DRN6MSCCBiuJC939JAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqZxDU1Uj3+Qtui7RKpPg2SrHDNduVZtoxMXdO5/GJ+wF3v1k0Po/j6JDkU3p+UC9
	 sZIm/ir+zGBDJX2GWDIgpiRiUIimueN7pxn6nbXTzqHB9GRXKROjoqRljh0vykE88p
	 6+4nfXmoHgokR+SPyHZqbmnZpukhGmqP3yU6Malg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/52] ALSA: firewire-lib: fix return value on fail in amdtp_tscm_init()
Date: Fri, 15 Nov 2024 07:37:27 +0100
Message-ID: <20241115063723.369606903@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ab482423c1654..726cf659133b2 100644
--- a/sound/firewire/tascam/amdtp-tascam.c
+++ b/sound/firewire/tascam/amdtp-tascam.c
@@ -172,7 +172,7 @@ int amdtp_tscm_init(struct amdtp_stream *s, struct fw_unit *unit,
 				CIP_NONBLOCKING | CIP_SKIP_DBC_ZERO_CHECK, fmt,
 				process_data_blocks, sizeof(struct amdtp_tscm));
 	if (err < 0)
-		return 0;
+		return err;
 
 	/* Use fixed value for FDF field. */
 	s->fdf = 0x00;
-- 
2.43.0



