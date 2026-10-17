Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5E63AA9F3;
	Sat, 17 Oct 2026 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256611; cv=none; b=MTl9nyLAIHQBpsjCsYgJtspZc7Ux9E0CagVxd4aMCZ9bMheq7ExvCoav/iIDI/UddRo6HCbDkDBHuU7wEcOnOOvO8wHWP6wC8/geOmQmrTH9vgEu6hblNjEn4PpRJSvmNCJ1ofUZKKbwEhTDB/mvh/HZlSRJc2Gf5P2SFBjs72w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256611; c=relaxed/simple;
	bh=2Ysxwr049nskoe/xqE2zLuoNPh02c/PvWRL2k4Hn5mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVVjBIxTY4Uu2A8osoZS2dMxRBZAcwU2+xq/OlOpGVTK717n89VxixGymr2tTNJA0XpTrie4ArIDpj/ZOl2MWnzuWysr/jK5os7ZH2BD5lwdhBAUW6p+0k81P9VaBNe2dcDJ7zzmbS0Dv4m7jasVNRl02lR1qYDV1noZQxLAUFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3UQTZom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3UQTZom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D351C1F000C4;
	Sat, 17 Oct 2026 17:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256610;
	bh=ELNUpab/mqVPKxo8E1Emyef5qNVQBK7ScC7MSGEswYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3UQTZomKrBv+QtsX5SWO7g0qF2JRbXkt7Tv4TljheXmnC4mMyw4iOrEgZZ3xHvFz
	 wkfbyg+Yf0ar4l9Kqj2g5RKKYnBjXTGpESjkSMIA+6D4JJno2aNZh2IKzy4G1e1zOI
	 DyaqhXGGPCZKT6PB/rO8YXHwNgYUUJ4Ye6T9Toi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Bruno Produit <bruno.produit@trailofbits.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0291/1674] ALSA: seq: Serialize compat port-info ioctls
Date: Sat, 17 Oct 2026 17:42:43 +0200
Message-ID: <20261017160438.582557531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 95b2e0361c88753afa030c10698be0a1a5b67650 upstream.

The native sequencer ioctl path serializes handler calls with
client->ioctl_mutex, but the translated port-info compat path invokes the
same handlers through snd_seq_kernel_client_ctl() without taking that
mutex.

This lets concurrent compat CREATE_PORT requests pass the port-count
check before any request reaches the serialized insertion. The computed
integer port index can then exceed the address field range and wrap to an
existing index. Subsequent subscriber teardown can resolve the duplicate
address to the wrong port and access a freed subscriber.

Take ioctl_mutex while dispatching converted port-info requests, matching
the native ioctl path. All translated port-info commands share this
helper, so their accesses to the client port state are serialized as
well.

Fixes: b3defb791b26 ("ALSA: seq: Make ioctls race-free")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Bruno Produit <bruno.produit@trailofbits.com>
Link: https://patch.msgid.link/20260917105643.90102-1-bruno.produit@trailofbits.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_compat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -44,7 +44,9 @@ static int snd_seq_call_port_info_ioctl(
 		goto error;
 	data->kernel = NULL;
 
-	err = snd_seq_kernel_client_ctl(client->number, cmd, data);
+	scoped_guard(mutex, &client->ioctl_mutex) {
+		err = snd_seq_kernel_client_ctl(client->number, cmd, data);
+	}
 	if (err < 0)
 		goto error;
 


