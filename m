Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78B88F58;
	Mon,  4 Mar 2024 21:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588339; cv=none; b=Tm4qOiWaJQ0duJni91dooQdDKmjKQTu11SXMhrIpFoiF8Cui1pq4Tg5sJnQSXj0LMmrf5+Jjwd+/ZnlNHfbh2OW3CMxoTEcb6JueejIrR8tUZ9aAFCe5bZMWYH7bMKCrbmt3A5dGY2w+KK4jzAwHF2pTQw8oZdPmDJcwnHXKVro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588339; c=relaxed/simple;
	bh=RhIZoUJYThtrfGeTNG1aZgqsuQT8JkLl4Swf3Jpr0KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USxssyl+Q/q39x2GKY2IGkUlZlOB6z0+bFkMGd4PWT46EV+GQocMdhy8GS0hRHMpz11jzlQKjxhk8iR0j9oY4NhWfpPBXxkBCp2sj613U3k/3BKzoj4f95vFyxOmvq01VM1FRLWW+bhdoqyHPuNuRoelK+AnFP5Fc/+op8dhtQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgP3Uj0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgP3Uj0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EE6C433F1;
	Mon,  4 Mar 2024 21:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588339;
	bh=RhIZoUJYThtrfGeTNG1aZgqsuQT8JkLl4Swf3Jpr0KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgP3Uj0w1It4VXamiRvbbPGgS/g5D+ZWTgIa2HytbDkz40DUlvLBmmw2KqRIkSIN6
	 gsXGsUnEvNsNJg116WWvsEve85bfxf5TPr5jlaQFdAhWlqGC4ZUxERw3e8yqUp52FH
	 IBCuji2zDlF9w8NyXF0CEstVfUz3Pa08hqlOXfGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 069/143] ALSA: firewire-lib: fix to check cycle continuity
Date: Mon,  4 Mar 2024 21:23:09 +0000
Message-ID: <20240304211552.132317999@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 77ce96543b03f437c6b45f286d8110db2b6622a3 upstream.

The local helper function to compare the given pair of cycle count
evaluates them. If the left value is less than the right value, the
function returns negative value.

If the safe cycle is less than the current cycle, it is the case of
cycle lost. However, it is not currently handled properly.

This commit fixes the bug.

Cc: <stable@vger.kernel.org>
Fixes: 705794c53b00 ("ALSA: firewire-lib: check cycle continuity")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20240218033026.72577-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -951,7 +951,7 @@ static int generate_tx_packet_descs(stru
 				// to the reason.
 				unsigned int safe_cycle = increment_ohci_cycle_count(next_cycle,
 								IR_JUMBO_PAYLOAD_MAX_SKIP_CYCLES);
-				lost = (compare_ohci_cycle_count(safe_cycle, cycle) > 0);
+				lost = (compare_ohci_cycle_count(safe_cycle, cycle) < 0);
 			}
 			if (lost) {
 				dev_err(&s->unit->device, "Detect discontinuity of cycle: %d %d\n",


