Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD7A1A76A1;
	Tue, 30 Jul 2024 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360254; cv=none; b=jTiBhOwLCVoGpYakDTuYkaXtnJdbh04H3BEq+9NvcoVJmzRPPIpVXYHdZuQGnCSIO2ZutjaTEQOPyGd3YEwMjPIUkPDi6PwWKGTff5C834WEWgWMF6uxpBtLT+PzTdGcjWmOFUDBFHu6Sj71QbuWJkLxA0ZM2bMdRh4Y/58OoGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360254; c=relaxed/simple;
	bh=otc//EzlFX8+42G8+SsZnwWM6L7I6MReebqofhGw8MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRpaJp2FD/NePc0aJspeDDvEOSR+T+SgkZGvZKh6f5lQaTglUaccOPpwKc+7b9qvB6fnujpeTp4UuOxbGi7PeQwiatt7bVvAZH32B5n9oxw4wTHQFvfbhT0JNBpULBOQq8iYY5/2Sk4DhlM5WeM9kogQd0XRyTMQqS/sTs7jtgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swFUsDLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swFUsDLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40BBC32782;
	Tue, 30 Jul 2024 17:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360254;
	bh=otc//EzlFX8+42G8+SsZnwWM6L7I6MReebqofhGw8MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swFUsDLi2fjCc7TQ6d4Wb8RgXTsmyhv3uj6SgvwH1gQxAnmHqRh52+N04HUU+AQfi
	 rbqYQWdfrZZBMI3KVjW0cnspOzmQlZbebHxSOEsiqJgvaCsiWh+tzNkVm/QDDbVpPt
	 tJfo8zXEQyLH3KBUrwj/0szkmpjcsjEdXncGn/Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edmund Raile <edmund.raile@proton.me>,
	Takashi Iwai <tiwai@suse.de>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.10 626/809] ALSA: firewire-lib: fix wrong value as length of header for CIP_NO_HEADER case
Date: Tue, 30 Jul 2024 17:48:22 +0200
Message-ID: <20240730151749.568404162@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit c1839501fe3e67d98635f159dba8b170d08f6521 upstream.

In a commit 1d717123bb1a ("ALSA: firewire-lib: Avoid
-Wflex-array-member-not-at-end warning"), DEFINE_FLEX() macro was used to
handle variable length of array for header field in struct fw_iso_packet
structure. The usage of macro has a side effect that the designated
initializer assigns the count of array to the given field. Therefore
CIP_HEADER_QUADLETS (=2) is assigned to struct fw_iso_packet.header,
while the original designated initializer assigns zero to all fields.

With CIP_NO_HEADER flag, the change causes invalid length of header in
isochronous packet for 1394 OHCI IT context. This bug affects all of
devices supported by ALSA fireface driver; RME Fireface 400, 800, UCX, UFX,
and 802.

This commit fixes the bug by replacing it with the alternative version of
macro which corresponds no initializer.

Cc: stable@vger.kernel.org
Fixes: 1d717123bb1a ("ALSA: firewire-lib: Avoid -Wflex-array-member-not-at-end warning")
Reported-by: Edmund Raile <edmund.raile@proton.me>
Closes: https://lore.kernel.org/r/rrufondjeynlkx2lniot26ablsltnynfaq2gnqvbiso7ds32il@qk4r6xps7jh2/
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240725155640.128442-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/firewire/amdtp-stream.c b/sound/firewire/amdtp-stream.c
index d35d0a420ee0..1a163bbcabd7 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -1180,8 +1180,7 @@ static void process_rx_packets(struct fw_iso_context *context, u32 tstamp, size_
 		(void)fw_card_read_cycle_time(fw_parent_device(s->unit)->card, &curr_cycle_time);
 
 	for (i = 0; i < packets; ++i) {
-		DEFINE_FLEX(struct fw_iso_packet, template, header,
-			    header_length, CIP_HEADER_QUADLETS);
+		DEFINE_RAW_FLEX(struct fw_iso_packet, template, header, CIP_HEADER_QUADLETS);
 		bool sched_irq = false;
 
 		build_it_pkt_header(s, desc->cycle, template, pkt_header_length,
-- 
2.45.2



