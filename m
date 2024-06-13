Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7334B144D2F;
	Thu, 13 Jun 2024 12:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280641; cv=none; b=f93g+jFOkw/gPr9ZOr42MQs/uNzx1L4mQAcGL8iM+oR8rl27JeA9yxEvejB08QZJFguwTsXpqkyFagRTvOtzHRtPe0vvyRLV4ONrOVuFdUGmb6YppzwrijwWwjo4QgAxNZOoOzk05FdbOC8rdZy269QEWc/RWh0XoaRP5ADdea4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280641; c=relaxed/simple;
	bh=aWJ1Xt4BgJcaBZ+uQfnubCpyzti4p06Zdkl4fLSbm5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGiB9PvXzVfdBnvhMZxIGDP74iyBHQtQiV+tWbcunne/FOuvN2w8+mAOZ3n5UzBQmlPsjLROEWbKKHiTAfsxC7XDkbpDLL+kW1pfQcd35hr8T1puFc0ZGV6GSnHwgie3NyDSCokqeivIbaciwjkGQOFf/j1eQsKXJLgtqec07TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqrDICIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqrDICIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7B4C2BBFC;
	Thu, 13 Jun 2024 12:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280641;
	bh=aWJ1Xt4BgJcaBZ+uQfnubCpyzti4p06Zdkl4fLSbm5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqrDICIwKPDkB8Z/7fR4t4/0cQbcEtv9vyEq4I/KfHhMZ/jp4EHHztKolHJOksEj2
	 7b3yLTRiThZRUfzKUBPnUfK8f8zDIRdYQ1djg3hFn130YVoeHlL/bz4gogIz3do0tb
	 U0QqUJLXy9yDSrEqGMAmn7dh2D3IoJZIikVFf++U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 123/137] ALSA: ump: Dont accept an invalid UMP protocol number
Date: Thu, 13 Jun 2024 13:35:03 +0200
Message-ID: <20240613113228.071738032@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ac0d71ee534e67c7e53439e8e9cb45ed40731660 upstream.

When a UMP Stream Configuration message is received, the driver tries
to switch the protocol, but there was no sanity check of the protocol,
hence it can pass an invalid value.  Add the check and bail out if a
wrong value is passed.

Fixes: a79807683781 ("ALSA: ump: Add helper to change MIDI protocol")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240529164723.18309-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -685,10 +685,17 @@ static void seq_notify_protocol(struct s
  */
 int snd_ump_switch_protocol(struct snd_ump_endpoint *ump, unsigned int protocol)
 {
+	unsigned int type;
+
 	protocol &= ump->info.protocol_caps;
 	if (protocol == ump->info.protocol)
 		return 0;
 
+	type = protocol & SNDRV_UMP_EP_INFO_PROTO_MIDI_MASK;
+	if (type != SNDRV_UMP_EP_INFO_PROTO_MIDI1 &&
+	    type != SNDRV_UMP_EP_INFO_PROTO_MIDI2)
+		return 0;
+
 	ump->info.protocol = protocol;
 	ump_dbg(ump, "New protocol = %x (caps = %x)\n",
 		protocol, ump->info.protocol_caps);


