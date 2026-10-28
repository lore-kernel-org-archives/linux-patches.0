Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211197;
	b=3x6mG4WHjqfsrHIy6J0R4Ex3rW2FKwmNkFtRhnzC6M2r77p1ksE+JyeCMxEjSaB+JXQG
	 G0tC6POT3IxJPmV4VTSo4gE7ogtuuT20O98/EjS1v3NYtaJ04oZ24PqfjLxypTMpmetFG
	 U6yci4gWrt5SEkPeJni1bebcUi6/92kfR60I54v+l3s54RGX0nXA7S6C4ui7JbxlUwtx/
	 8Y59XDWXBj9SAJQp2cZutyw7+ziknei+j/N1QQU4mydzfSj04EZSq1tfrv5gsQ0GxSeXk
	 SnanFiPfvH72QtQzWtVA8QjAF0OKOwED9d0bHpuVboTivXfe/MMVRiVinfa/IwdEykQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YHLia65IDJp7BNHca5czSIf04+GxDQMAoB2n4ZZOnb0=;
	b=DH7Vca2GP/N6GMVc8UGvlTyYFETIsnEUZqIlbvni0NhlS1a26D2DtzvLvyOqA0ecnSga
	 VvVDb6SdS+4X056G27qw/Tz/b1dpnkQd1BH2KSkSY2Tp4NilDyDw6htLNUFrmYHf3utam
	 ngK41H1KC8fZKgyFvvI+nQFM5d9JQfO+DSkKI2FnOqwfdvifoNe0bdVXlj1KgGeHjt9GY
	 KonaDohMy8PAaDZits5FHpvMpC7xu4wTA2YabBPEKfHjtKWmjaolJejB9dne24A/DJ0K2
	 QOwI+Ic2u0bmiCzG7jxEe3iLnpZ7T6KGyo8rVyyPKvZkIOTNVSj7Jri6X6pvA3A6Pfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYMtQyHn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60600606A945;
	Wed, 28 Oct 2026 18:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYMtQyHn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26A51F01828;
	Wed, 28 Oct 2026 18:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211197;
	bh=YHLia65IDJp7BNHca5czSIf04+GxDQMAoB2n4ZZOnb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYMtQyHnlKU430Rzrh0J4FuvU/PDxjkIZn0s1dJeuhlSbRMl1NZc9pswhCSNvWeo4
	 jisfVuMdbRvgZq8feDY8oTo4RUsYiK6sHxOCalLBkufc6roXkobJhzK2zrM2Zmld63
	 CYdKYnaP7MeIpQ7cPRWGvGY11f57HzG7W+dT4Qs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Bruno Produit <bruno.produit@trailofbits.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/571] ALSA: seq: Serialize compat port-info ioctls
Date: Wed, 28 Oct 2026 17:57:20 +0100
Message-ID: <20261028170014.952974921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 95b2e0361c88753afa030c10698be0a1a5b67650 ]

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
[ sashal: Replaced scoped_guard() with explicit mutex_lock() and mutex_unlock() calls for GNU89 compatibility. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/seq/seq_compat.c b/sound/core/seq/seq_compat.c
index c0ce6236dc7f1..65c385f3ef894 100644
--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -44,7 +44,9 @@ static int snd_seq_call_port_info_ioctl(struct snd_seq_client *client, unsigned
 		goto error;
 	data->kernel = NULL;
 
+	mutex_lock(&client->ioctl_mutex);
 	err = snd_seq_kernel_client_ctl(client->number, cmd, data);
+	mutex_unlock(&client->ioctl_mutex);
 	if (err < 0)
 		goto error;
 
-- 
2.53.0



