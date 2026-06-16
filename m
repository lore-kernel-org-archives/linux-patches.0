Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7F43C05C;
	Tue, 16 Jun 2026 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623088; cv=none; b=UtwG6o7W+b2KpCpbwX97Hcp482UNMnJKe2W2WDrecfCh7xSXl7vO8cP9pta7Q7KAC1QnC2srf7qy2KIWorw/i8u5EdZhkGUT6dUBnYiBI9chYGIQPThX/Q3F9SOpOyYftadH4pZFJF4g0dFQJuAnaFNwPfk2YSKT4QKbZQhMx2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623088; c=relaxed/simple;
	bh=fWKa77hZX/WF0ZTt2bFOCprS03PEve76MidEnmPw264=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqBbEl5ovRSUCi7xcOqRwxkucavd0EebPrz/hjfn89oelvvMIe95LTx3HQ9CPiTorklDBL1vAGTWQOO5VrhXSL5CUrsYbtzlDytvMr0BaII+6MJZRgZKlvGVJgpNIfiyilIxWwGQwBlmKeJ8RRGlFp4bAiLxBYyXYeDg3GEupm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oEIZWh5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oEIZWh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CCB1F00A3D;
	Tue, 16 Jun 2026 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623087;
	bh=N8/1QBy8Tldo+SBFtE9G0JaAqkhbB2wCgh28NHHYhG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1oEIZWh507UldYHYEbYodraUmyl+raxr0PXUUhap9QFspVzS3hA290UpshNf6Dyb0
	 lLiFdKk8zGfbEQzirI1eZhsfv/R+rZNcii6oFMR7RTBCRzrVX0cB4Q6VTVnfrNXc1e
	 nck22O2SI7d1ao4CCIFvNYjMxJYBINgknYeJpEG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 086/378] ALSA: seq: dummy: fix UMP event stack overread
Date: Tue, 16 Jun 2026 20:25:17 +0530
Message-ID: <20260616145114.774819900@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 2b5ff4db5d7aa5b981d966df02e687f79ad7b311 ]

The dummy sequencer port forwards events by copying an incoming
struct snd_seq_event into a stack temporary, rewriting source and
destination, and dispatching the temporary to subscribers. That legacy
event storage is smaller than struct snd_seq_ump_event.

When a UMP event reaches the dummy client, the copy leaves the UMP flag
set but only provides legacy-sized stack storage. The subscriber
delivery path then uses snd_seq_event_packet_size() and copies a
UMP-sized packet from that stack object, reading past the end of the
temporary.

Use the existing union __snd_seq_event storage and copy the packet size
reported for the incoming event before rewriting the common routing
fields. This preserves the full UMP packet for UMP events while keeping
legacy event handling unchanged.

Fixes: 32cb23a0f911 ("ALSA: seq: dummy: Allow UMP conversion")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20260605080204.32045-1-kylebot@openai.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_dummy.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/sound/core/seq/seq_dummy.c b/sound/core/seq/seq_dummy.c
index af45f328ae9901..8abe80985daddb 100644
--- a/sound/core/seq/seq_dummy.c
+++ b/sound/core/seq/seq_dummy.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <sound/core.h>
 #include "seq_clientmgr.h"
+#include "seq_memory.h"
 #include <sound/initval.h>
 #include <sound/asoundef.h>
 
@@ -81,19 +82,21 @@ dummy_input(struct snd_seq_event *ev, int direct, void *private_data,
 	    int atomic, int hop)
 {
 	struct snd_seq_dummy_port *p;
-	struct snd_seq_event tmpev;
+	union __snd_seq_event tmpev;
+	size_t size;
 
 	p = private_data;
 	if (ev->source.client == SNDRV_SEQ_CLIENT_SYSTEM ||
 	    ev->type == SNDRV_SEQ_EVENT_KERNEL_ERROR)
 		return 0; /* ignore system messages */
-	tmpev = *ev;
+	size = snd_seq_event_packet_size(ev);
+	memcpy(&tmpev, ev, size);
 	if (p->duplex)
-		tmpev.source.port = p->connect;
+		tmpev.legacy.source.port = p->connect;
 	else
-		tmpev.source.port = p->port;
-	tmpev.dest.client = SNDRV_SEQ_ADDRESS_SUBSCRIBERS;
-	return snd_seq_kernel_client_dispatch(p->client, &tmpev, atomic, hop);
+		tmpev.legacy.source.port = p->port;
+	tmpev.legacy.dest.client = SNDRV_SEQ_ADDRESS_SUBSCRIBERS;
+	return snd_seq_kernel_client_dispatch(p->client, &tmpev.legacy, atomic, hop);
 }
 
 /*
-- 
2.53.0



