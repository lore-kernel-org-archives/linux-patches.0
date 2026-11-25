Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622565;
	b=e8JijigxYRfkAYRxFkU1KfYH4fKOa9298N8aGrhOslES2hr/v2uZSml657B91Aem2XW+
	 f084hUeyxJxzplzjqTpF+ZJyqkR/pTQpemJqzfZnKhPiOGzXIJkNIVL6LEGlDUJiWc/qt
	 eMdw4lE7YXLdu2I8vs7br0RUW4Mn2ny5VVmcKCs8K5/5LpL+te+BDeMf4rsck0NYtx+AC
	 biL+poJIBIzhNkCf6TOsBTRgRe7hOpOhfaCBJrKjhXdCSx4vc9HS0lTAYTFZv0LSt8Xa9
	 TGqDQoESFViO9SBbd1Eer3OO/WRg3iGFwfW2yEgbYbgEJDGEh/3Im1FmmS+xUg7AkaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mvXVbmZJ0v+SxmdB4p5/uRUHjCd56cKFsFzWQm2OWzM=;
	b=U780Pv+c37MDlAWCmFbvATIjqaFz9bmN6aGhT7h16z0slUdU5h0fthKBWRzZ7ht3M+or
	 xqHkMSFP8s27d7U2vMyVkVuUJU7DeolpDnAVdRPKRAiqNujd2qVQZDlXvuGLZkji3sQLp
	 zWZnRbjBPzfR45Y/B4a0n7lrSzwo0Jhy6Fp3z6lbjkyXehQK+ROGw1LYdUe15wcGDgvGB
	 I6po8bARC5x6DT/DEclVf0yAOv2UEwX40kKYI7+MB1Q9y8N55bgArreE6uA2QMwNblIfb
	 InMuCheaaVwYMuXs4i9h/oSjdSpVEv9kxcQS9rOPTO//PkUf/Fk3SuDEPNPih251Bug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K48j+OFU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56935606A326;
	Wed, 25 Nov 2026 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K48j+OFU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9202B1F000C4;
	Wed, 25 Nov 2026 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622565;
	bh=mvXVbmZJ0v+SxmdB4p5/uRUHjCd56cKFsFzWQm2OWzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K48j+OFUug6lp+cJc4CSa0hb+72yNb80W6Or7SHf/ntlP4wW0wBtZDgrexJ3l7bu+
	 pwJCQCFV2FH2470UswbaXJqezxBGPiEmem+ps573NwIvLtg0XtW/Ta7UcZWEI6k7eS
	 S2CGy4qG6x0lX5lMhEWWlDhkL1nWhSF3ByeriV5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 577/990] ALSA: aloop: Avoid a bad mixure of guard() and goto
Date: Wed, 25 Nov 2026 15:32:24 +0100
Message-ID: <20261125143835.607857059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f7faf5d9b5668919cae84a6247f8f7b4e2c0227c ]

The rewrite of aloop driver code using guard() leaded to a mixture of
guard() and some goto; although it currently works, it isn't really a
good match.

For avoiding the bad match, just move the code using goto into a
function and wrap it with guard().

Fixes: ebd9b6c91d4e ("ALSA: aloop: Use guard() for mutex locks")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172533.14667-6-tiwai@suse.de
[ sashal: Kept the existing kzalloc(sizeof(*dpcm), GFP_KERNEL) call in the context instead of upstream's kzalloc_obj(*dpcm), since the file still uses plain kzalloc. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 93ac63edfb975..c11648f431096 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1276,7 +1276,7 @@ static const struct loopback_ops loopback_snd_timer_ops = {
 	.dpcm_info = loopback_snd_timer_dpcm_info,
 };
 
-static int loopback_open(struct snd_pcm_substream *substream)
+static int __loopback_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct loopback *loopback = substream->private_data;
@@ -1285,7 +1285,6 @@ static int loopback_open(struct snd_pcm_substream *substream)
 	int err = 0;
 	int dev = get_cable_index(substream);
 
-	guard(mutex)(&loopback->cable_lock);
 	dpcm = kzalloc(sizeof(*dpcm), GFP_KERNEL);
 	if (!dpcm)
 		return -ENOMEM;
@@ -1375,6 +1374,14 @@ static int loopback_open(struct snd_pcm_substream *substream)
 	return err;
 }
 
+static int loopback_open(struct snd_pcm_substream *substream)
+{
+	struct loopback *loopback = substream->private_data;
+
+	guard(mutex)(&loopback->cable_lock);
+	return __loopback_open(substream);
+}
+
 static int loopback_close(struct snd_pcm_substream *substream)
 {
 	struct loopback *loopback = substream->private_data;
-- 
2.53.0



