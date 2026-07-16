Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C7F28505E;
	Thu, 16 Jul 2026 14:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211780; cv=none; b=OGXRsJxnAiRiGQ8IOM/iO3LOC06TYAQpSdgdpU2za/KpXYmYj/Q95HIJ+ehdjkrva1+BjpcKbk3q5i1yWlzDngxFbjJ1Y5OwAaCZZeJEUKUrVgIm+2S62wD/wJimg8jcs3yiXxr6o6+X79Q7aWaTe5EFYtymAEqjp38WE+yGf10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211780; c=relaxed/simple;
	bh=wKnAfw4hmXab4CTymxQyEi728ujXmspyzSoPoguGO9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrbGf61mOZNDML5v3wC/taHtr4vUEbHA39jZyBQAT+d4KDM4BZbyZCkeidnLi+4WIY37GDIwEKHtZzpyvPBI4iTCdieQpSPQQjNoFkLfcX4YV9W6joXUmPCvUScWbHnId4rNWRfreOQkUlyGuEK9kXnVwOhUcfNc7OkfFzfSoMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bN8CEo22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bN8CEo22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3181F000E9;
	Thu, 16 Jul 2026 14:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211779;
	bh=c/LMhffAZ6taVfKebxIndwsZZZX/jBQkSMB28+a0ths=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bN8CEo22uMqjMuUhVeZxpEPecQl5aZliDPsWhyY1GhRY7mecxIx/imXHO1bzMvHMy
	 PEvJai961lRchHCI8JiwYZSYn4EtpPPOjVIh7SeBJOTqIslgjwzLMgQDuNXbYjHK+T
	 0GEAKpAb9e4nzS2xA1vbCFEc7mmnxBl0aa+MM31w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 077/349] ALSA: firewire: isight: bound the sample count to the packet payload
Date: Thu, 16 Jul 2026 15:30:11 +0200
Message-ID: <20260716133035.042973693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 29b9667982e4df2ed7744f86b1144f8bb58eb698 upstream.

isight_packet() takes the frame count from the device iso packet and
checks it only against the device claimed iso length.

	count = be32_to_cpu(payload->sample_count);
	if (likely(count <= (length - 16) / 4))
		isight_samples(isight, payload->samples, count);

length is the iso header data_length. It can be up to 0xffff. So the
gate allows a count up to about 16379. isight_samples() then copies
count frames out of payload->samples into the PCM DMA buffer.

payload->samples holds only 2 * MAX_FRAMES_PER_PACKET values. The
device multiplexes two samples per frame. A count past
MAX_FRAMES_PER_PACKET reads past the payload. A count past the buffer
size writes past runtime->dma_area. The smallest PCM buffer is larger
than MAX_FRAMES_PER_PACKET. Bounding the count to MAX_FRAMES_PER_PACKET
keeps both the read and the write in range.

A malicious or faulty Apple iSight on the FireWire bus reaches this
during a normal capture.

Add the MAX_FRAMES_PER_PACKET bound to the gate.

Fixes: 3a691b28a0ca ("ALSA: add Apple iSight microphone driver")
Suggested-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/178205454729.1900991.7807310178296762772@maoyixie.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/isight.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/firewire/isight.c
+++ b/sound/firewire/isight.c
@@ -179,7 +179,8 @@ static void isight_packet(struct fw_iso_
 	if (likely(length >= 16 &&
 		   payload->signature == cpu_to_be32(0x73676874/*"sght"*/))) {
 		count = be32_to_cpu(payload->sample_count);
-		if (likely(count <= (length - 16) / 4)) {
+		if (likely(count <= (length - 16) / 4 &&
+			   count <= MAX_FRAMES_PER_PACKET)) {
 			total = be32_to_cpu(payload->sample_total);
 			if (unlikely(total != isight->total_samples)) {
 				if (!isight->first_packet)


