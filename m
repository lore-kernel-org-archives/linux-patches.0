Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027428;
	b=gZ+t6ip3cnAS2+W+mevQhPIq6nnTJxrumD155KYmVHxzIMfe3djBAnlbn1EOKgWZoOCr
	 P80dvnAH7/EPHt+n5lYd8DsFRah340r9WnA9chf71Rqfn4YZfaryLiTdVqNG4fBd+ysK3
	 tGBCM0BBAzTpEpK2jJfQWCRUBx7BS/Ar3egc33y1KFM+9Gw5+3zGa30Ag2ESS5wDKbXPc
	 7SrbSxFC7l6Hj6/FODfzy8QP3HMwxAFSOvwIRNYd+gmzk1tzVaNZyO0hqvHhfpEuZtHjf
	 WzKwbd+ccKHu1xbTRewvo1EGdXxK5HAhK89u1j4JIrqbNImc6LLu6aL/N3U/orYe9Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T4l6nUicII9Rjx0NR9akmYx3C+Dad4cObR2BbsgsSK8=;
	b=Wdk35443LTb/PWUkdoQo0AtakYfjppbgbcCxN4takwlbKA4RZbzqB/b0bzUgEOeY+1x0
	 XuwhX1VydAiCN8d9JC0mp8LbCMQPMg61XhS3u75Be3j8i488foGPmcwhzeRTPTZ3W9/jv
	 5mC3PwL+lh3EVqmM+vFlMpPODd9pk2gX9trv6yHNsaKKtGxyEd5tdlAOwON3yOu2PeqTn
	 D6im46k1sT4vcFq0mPak/cETajTXh6yUGS+P4yLtv9rLiMjf5dluy2GrYC89k9Caik2RY
	 LQMJW2YyI6ISOfd2G2yEm7SNeCNKSlj9cHrGLZhf8jPjmd93Bz8IWaGJkJ+HpgFez6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yfM0Ee3e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8343060A2602;
	Wed, 18 Nov 2026 18:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yfM0Ee3e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49CC1F000C7;
	Wed, 18 Nov 2026 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027428;
	bh=T4l6nUicII9Rjx0NR9akmYx3C+Dad4cObR2BbsgsSK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yfM0Ee3eL9Vau3BrGqrJ8VTVFLW8Q5/g7gHEASc5p2GFFGywFvkjD9+Qj+zV0cNZj
	 +/Zwc1hGaHlfG4OWGkuiNhnFyGmX8O9EE/Ut3nMk8zh2DE1WVes1KFpEk/PntwJDq8
	 +etbo7ZQFDh8YV46SOVUh9Ff9sBRPpvudt+55duY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1787/2151] ALSA: aloop: Keep the timer source alive until card release
Date: Wed, 18 Nov 2026 15:58:42 +0100
Message-ID: <20261118150226.917101818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 762ef425cf0ac9c4b9e9e61e0da0950e16e6fbea ]

The timer_source string must remain valid while PCM opens can select
and parse it. loopback_set_timer_source() allocates the string with
parent-device devres, which can release it while the card is still
registered.

A successful nonempty proc replacement after snd_card_register() adds
the string allocation after trigger_card_free. Unbinding the platform
device while snd_aloop remains loaded releases devres in reverse order.
An open for an unused cable can run after the string is freed and before
the card-free action disconnects the card:

  Device unbind                      PCM open
  devres_release_all()
    free replacement string
                                     snd_pcm_open()
                                       snd_card_file_add()
                                       loopback_open()
                                         loopback_snd_timer_open()
                                           loopback_parse_timer_id()
    trigger_card_free()
      snd_card_free()
        snd_card_disconnect()

The parser can then read freed memory. KASAN has reported a one-byte
use-after-free read in strchr() from loopback_snd_timer_open(). The
cable_lock mutex serializes explicit replacements with opens, but
implicit devres release does not take it. The card and module references
held by PCM open do not retain this separate devres allocation.

Use kstrdup() and release the current string from card->private_free.
PCM admission already retains the card until each file is removed, and
card disconnect drains proc callbacks before final card release. This
keeps the string alive across admitted PCM opens and preserves the
cable_lock serialization of replacements. Install the callback before
the initial allocation so probe failures also release the string.

Fixes: b072e65aadd6 ("ALSA: aloop: Allocate resources with device-managed APIs")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM
Link: https://patch.msgid.link/pm-pmb-71a33a26d68356e3ade7-v1-108d86919c5c92fe1ea8@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 24a5fbc1c288f..93ac63edfb975 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1786,13 +1786,10 @@ static int loopback_cable_proc_new(struct loopback *loopback, int cidx)
 static void loopback_set_timer_source(struct loopback *loopback,
 				      const char *value)
 {
-	if (loopback->timer_source) {
-		devm_kfree(loopback->card->dev, loopback->timer_source);
-		loopback->timer_source = NULL;
-	}
+	kfree(loopback->timer_source);
+	loopback->timer_source = NULL;
 	if (value && *value)
-		loopback->timer_source = devm_kstrdup(loopback->card->dev,
-						      value, GFP_KERNEL);
+		loopback->timer_source = kstrdup(value, GFP_KERNEL);
 }
 
 static void print_timer_source_info(struct snd_info_entry *entry,
@@ -1823,6 +1820,13 @@ static int loopback_timer_source_proc_new(struct loopback *loopback)
 				    change_timer_source_info);
 }
 
+static void loopback_private_free(struct snd_card *card)
+{
+	struct loopback *loopback = card->private_data;
+
+	kfree(loopback->timer_source);
+}
+
 static int loopback_probe(struct platform_device *devptr)
 {
 	struct snd_card *card;
@@ -1848,6 +1852,7 @@ static int loopback_probe(struct platform_device *devptr)
 		pcm_substreams[dev] = MAX_PCM_SUBSTREAMS;
 	
 	loopback->card = card;
+	card->private_free = loopback_private_free;
 	loopback_set_timer_source(loopback, timer_source[dev]);
 
 	mutex_init(&loopback->cable_lock);
-- 
2.53.0



