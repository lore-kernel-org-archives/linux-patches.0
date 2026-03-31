Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7749B425CD4;
	Tue, 31 Mar 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976016; cv=none; b=e76DwI/kslPiM8G4SEyUectT12URJtRcVqNTDbBN2KMd3YUGVdPmyvBmnC/loBp2baymadowbhWLmaXx1Iz9nyQHZ7VHvofdPEl2ng1hul9FFeD4ds7TirWeSyYcXghM75rnqx9erRDsEIGyxMAaBLr9GLGYA4M+gHea1h92sTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976016; c=relaxed/simple;
	bh=yvbaHsDmn10NjtcscCB6WCvacf0aNmKKIDjzGFxEn54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwh3istF5qhjNT+HZ7Pojpjc6gheKmtilZiDi3zyU78TqADHkCSv33KHSzDKcsacCSMlpBjLi0yAxObP4bAsb9IWTYwKwZW3oB+2jRqCqu3alnE6jqg1woBg6bpLZwkJ465uJbMulTmnSRwtWFgdkDeNsF9t9wmmk6BOjIRuCm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4ECDNQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4ECDNQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6C9C19423;
	Tue, 31 Mar 2026 16:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976016;
	bh=yvbaHsDmn10NjtcscCB6WCvacf0aNmKKIDjzGFxEn54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4ECDNQUafanU+nGb0bctAhOKfVOhKC3JZf7KJtI0dVF//GvsA+81j8GG1y27PLMz
	 I+kggpHaddCfbDIFqZAOe/4eSTESw4wu+xurvYFOHv0GOpT13C5GuEXQwNLFR0m6ki
	 A7XSuAotW5xc4qc2yxY7XAhTuXEj1zLNHXazQBCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 142/244] ALSA: firewire-lib: fix uninitialized local variable
Date: Tue, 31 Mar 2026 18:21:32 +0200
Message-ID: <20260331161747.012583815@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
@@ -1179,7 +1179,7 @@ static void process_rx_packets(struct fw
 	struct pkt_desc *desc = s->packet_descs_cursor;
 	unsigned int pkt_header_length;
 	unsigned int packets;
-	u32 curr_cycle_time;
+	u32 curr_cycle_time = 0;
 	bool need_hw_irq;
 	int i;
 


