Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004213EF0A2;
	Tue, 31 Mar 2026 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974488; cv=none; b=PHiJwGP2P1sPl9oQRSfxbTGc0Mpr8SD3t5rNpQ/vi1YlNM/26zE23fgVitybo7m+qrHeFw8a9XpJslDDaEIeJ/Js0sV3MJ2OIs6LD6FiC1gN0l5sr6Sp+v/oaA8nDlYAkcjqrc74lru8szE13Hflfso7eusN+7rLChcTkL1qb4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974488; c=relaxed/simple;
	bh=H72ViErjvt1Ovd4taD6XI7lwzgpwEmkBudPZlZ3lM7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLAkKD05iJqroeZFnppts49a38ZekgiZjgxeZN1sXG2/+KKaEjTBo2FAR9oIZtwRvttwQl4uWbBAO3polIDdFDrUtLPCgU9A29XXP2YjKD4MGBECcM3O2ZhaEmNDKidyQ1nH7qBaLCYXFU06GFql8Gu8i7G6jF3chW/3ckrVutM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4S8tMuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4S8tMuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B26DC19423;
	Tue, 31 Mar 2026 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974487;
	bh=H72ViErjvt1Ovd4taD6XI7lwzgpwEmkBudPZlZ3lM7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4S8tMuo9PxoFtmLyXwMhrR32gAumUDf6oADMn4pyU8oU1HrbHgrP4H1OKCRE1yxj
	 kxQ+nBMfXC6f4m8a6Ft2fFoAMLoLYTk/Xlm7Sw07rKCMsn3lqyGbfsljBVb4LuuAT3
	 sIiyOlDft72NwgmKZ07bcdY2Hl9Bk+KLntZ0+Rm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 103/175] ALSA: firewire-lib: fix uninitialized local variable
Date: Tue, 31 Mar 2026 18:21:27 +0200
Message-ID: <20260331161733.561962057@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Nepomnyashih <sdl@nppct.ru>

commit bb120ad57def62e3f23e3d999c5fbed11f610993 upstream.

Similar to commit d8dc8720468a ("ALSA: firewire-lib: fix uninitialized
local variable"), the local variable `curr_cycle_time` in
process_rx_packets() is declared without initialization.

When the tracepoint event is not probed, the variable may appear to be
used without being initialized. In practice the value is only relevant
when the tracepoint is enabled, however initializing it avoids potential
use of an uninitialized value and improves code safety.

Initialize `curr_cycle_time` to zero.

Fixes: fef4e61b0b76 ("ALSA: firewire-lib: extend tracepoints event including CYCLE_TIME of 1394 OHCI")
Cc: stable@vger.kernel.org
Signed-off-by: Alexey Nepomnyashih <sdl@nppct.ru>
Link: https://patch.msgid.link/20260316191824.83249-1-sdl@nppct.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -1156,7 +1156,7 @@ static void process_rx_packets(struct fw
 	struct pkt_desc *desc = s->packet_descs_cursor;
 	unsigned int pkt_header_length;
 	unsigned int packets;
-	u32 curr_cycle_time;
+	u32 curr_cycle_time = 0;
 	bool need_hw_irq;
 	int i;
 


