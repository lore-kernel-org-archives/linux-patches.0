Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3477200A3;
	Mon,  6 Jan 2025 15:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177947; cv=none; b=vGaFB3l2SXT5Cj6UQaA9CYwXzieN7zAJ1lMqGh+TZAO0k0YcXrsZyhJo0+mhqgvkpuzMsd2Ec/h5Kj2NBYQhAoP3qaTOSOsStc8NtcphAf//kxhgN85WZ1F1zQfF6JDNhQLQJhqdWyq2V3+GRD76GsrRy1XzIeUgl+arfk3nbkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177947; c=relaxed/simple;
	bh=GYstxlJ9kALKFrB9U9pPGwsyzENcrQIXic+Un5ykbdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICMJFV2q2G+OObkfKhlBtiWDylezvVzVRy84Hc57mtU9F86CNYGbQ6kDzhdvh7REh+IJ36SoYc4IRGEqe2J/+0jDceLZQOMLUNg11eSnXo9gBen/1ACKunHaYQWG1vHFVL5/GgPU9C615qOKQtUqfuNHLpwMjDUzobKX9UBOmtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qM+WjXv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qM+WjXv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDB2C4CED2;
	Mon,  6 Jan 2025 15:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177947;
	bh=GYstxlJ9kALKFrB9U9pPGwsyzENcrQIXic+Un5ykbdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qM+WjXv59eyCBCCoEknCrvp5jJTPm0RgRquAkPB5LwSnFWDjp+e1UeBPWNarO+84h
	 GQdacqBUrG1TEyr9wfPY4oCxswKYODFss70XyAnVD8A8OAZ/0SisfYM/HSrQtFVHBP
	 nb0seu3gII0z5AwrLY3mJY3dnwQDQiqkiv6bKD9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 110/156] Revert "ALSA: ump: Dont enumeration invalid groups for legacy rawmidi"
Date: Mon,  6 Jan 2025 16:16:36 +0100
Message-ID: <20250106151145.871036269@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Takashi Iwai <tiwai@suse.de>

commit abbff41b6932cde359589fd51f4024b7c85f366b upstream.

This reverts commit c2d188e137e77294323132a760a4608321a36a70.

Although it's fine to filter the invalid UMP groups at the first probe
time, this will become a problem when UMP groups are updated and
(re-)activated.  Then there is no way to re-add the substreams
properly for the legacy rawmidi, and the new active groups will be
still invisible.

So let's revert the change.  This will move back to showing the full
16 groups, but it's better than forever lost.

Link: https://patch.msgid.link/20241230114023.3787-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index fe4d39ae1159..9198bff4768c 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1244,7 +1244,7 @@ static int fill_legacy_mapping(struct snd_ump_endpoint *ump)
 
 	num = 0;
 	for (i = 0; i < SNDRV_UMP_MAX_GROUPS; i++)
-		if ((group_maps & (1U << i)) && ump->groups[i].valid)
+		if (group_maps & (1U << i))
 			ump->legacy_mapping[num++] = i;
 
 	return num;
-- 
2.47.1



