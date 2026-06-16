Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A0336E46F;
	Tue, 16 Jun 2026 15:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622329; cv=none; b=BGL9DCMJGUbp/yzA+3MI8ypPxw2qXC6SAjhuKbiZPExxB1Ox+/V6W6+NJfi+kmIFAZ/HwMu+YWDe4zcyAvbK1uzEU7MVM7i5iXhk9mS2KZmWmgvETGF+ZWpfpJ4ZRoYcamoJIdsupYvfZDxPjklZ/aMjpcrAed1H7PowChntbBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622329; c=relaxed/simple;
	bh=/sgoGBQ83jJTEVWOqmB95R8Vr1DxsdRrB1N7DlMZVmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx0wXZpyZXDBxL5gTBR9dsukiit3hXP7xafPJOt/B0cQOHDolHNVUIrm7qWjxCgQLCOLqS2SVt4w+/ea6t7fqhG3MkaGxGdIc2G6raj0H/dJ4lOUUOtdCLQTzxcA+2eYUEtlOq5D/NOyYklh/LDp2cnepBH8/JP1sondg6YFaMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihsymsQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihsymsQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AD61F00A3A;
	Tue, 16 Jun 2026 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622328;
	bh=NRJ75pINHJxLr6Sl1FQzO4c3srqj/rK9TpWsu0Pxups=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihsymsQteZOBqYFOd/6MjpdnpmKfq0nBZPhmPH5zs0VLsqVe8dKjdblWxWA6bA1B4
	 Rs2ORKqfZCrWeXY5VQQFHtDxPhhVKJB1QjWZJ+VDl4D7KKMhcXqm6K0qTGnMItogFa
	 3pMZFbvm/tMoQ2ekBdOpjnLCHgCUQk40eED3Igco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <cyeaa@connect.ust.hk>,
	Takashi Iwai <tiwai@suse.de>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/342] ALSA: usb-audio: fix null pointer dereference on pointer cs_desc
Date: Tue, 16 Jun 2026 20:24:58 +0530
Message-ID: <20260616145048.461969387@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <cyeaa@connect.ust.hk>

commit b97053df0f04747c3c1e021ecbe99db675342954 upstream.

The pointer cs_desc return from snd_usb_find_clock_source could
be null, so there is a potential null pointer dereference issue.
Fix this by adding a null check before dereference.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Link: https://lore.kernel.org/r/20211024111736.11342-1-cyeaa@connect.ust.hk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Fixes: 1dc669fed61a ("ALSA: usb-audio: UAC2: support read-only freq control")
[ kovalev: bp to fix CVE-2021-47211; added Fixes tag; the null
  check was added into both UAC2 and UAC3 branches since the
  older kernel still has the clock source lookup split between
  snd_usb_find_clock_source() and snd_usb_find_clock_source_v3()
  (see upstream commit 9ec730052fa2); return -ENXIO instead of 0
  to match upstream behavior, where the caller reaches the clock
  validation path and returns -ENXIO ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/clock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 197a6b7d8ad6f9..8759e20c419ed5 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -646,11 +646,17 @@ static int set_sample_rate_v2v3(struct snd_usb_audio *chip, int iface,
 		struct uac3_clock_source_descriptor *cs_desc;
 
 		cs_desc = snd_usb_find_clock_source_v3(chip->ctrl_intf, clock);
+
+		if (!cs_desc)
+			return -ENXIO;
 		bmControls = le32_to_cpu(cs_desc->bmControls);
 	} else {
 		struct uac_clock_source_descriptor *cs_desc;
 
 		cs_desc = snd_usb_find_clock_source(chip->ctrl_intf, clock);
+
+		if (!cs_desc)
+			return -ENXIO;
 		bmControls = cs_desc->bmControls;
 	}
 
-- 
2.53.0



