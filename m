Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042113;
	b=d7vjBBHCxEDFuz1gC6UF9PrLtJjOn7BYhsW0L7+l52fWwf+XLD51bNMk897CKQVL93aW
	 spJyxtdMZca+EjPxf+RI8OFl1/uW2w34QqB1I029LB7djoEKAgA11cegs9q2n8MjcR3SI
	 YV6CQvcaCeQHZ1MlNY6Ijsq0eSX0gcP53YH9n9RcLORS7vASLpS8WZT4PLET/+ZNwpjvi
	 mq8lAVZjuFBviYkYzagwZu+H71tIoLuVAsHrbHCq1dYJ0PiF0QjxqgUR0svmebT37g8j9
	 pMfZdQ+8tXb3DAZ59bK2Gi5N62jrALRaa1LD9buN+yrbteeOhUlCiF4Sivs3QpbW0fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x6DvThuFwxJ0iiQxTbjG1V7PkMUJP4DQpc2ZJtXDCYM=;
	b=sonC+aWfCy7k6CIsjJYYroVPehEB3SLHCTyrfGBexUu3mCIQH3C+n6gwN/DraFHYlCdg
	 01SSVMu1v1c8hH8z65iuCrKL1WT4Skp8JdNOoncDqDEQQTqlnm5l/B6rHrtMDfIzKY4wy
	 KbUxvVP5wA21tHRpah74zsYAl91U9sDVSwDACDk0XlRJn/INIEW6gQUCp+N3uRuMRZ4em
	 Vz3JK45sH/EB6y9w+8sFIkqopFg/wqsm2cGoNuZuy0Jiy3BIbIQJFkslrNb9Zt6n1OfFh
	 JUK6d3sdkWcsMVaBTjyav+WT98/oEHwZZQGleEYnwjiYezkIFZQp5DS7bm0jO5sxEdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Td1cvzVy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DDD606A320;
	Wed, 18 Nov 2026 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Td1cvzVy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C18F1F000C4;
	Wed, 18 Nov 2026 22:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042113;
	bh=x6DvThuFwxJ0iiQxTbjG1V7PkMUJP4DQpc2ZJtXDCYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Td1cvzVyJ6suP1OiBTNCvsuoMZkgEIufZO6bUnOyT1SLVoICFF2yM1h5nlaa9ZZQL
	 O+MfKrzaxq1edDryVPoWFfaFK6+2fW0emNo1Rbaz7e+rRBmdedW4Sqaz/8xJOrfoqn
	 CVrvfE/LmfyBGNNzPRwELdnQpvMTJEWfcogu7jpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3053/3318] ALSA: aloop: Keep the timer source alive until card release
Date: Wed, 18 Nov 2026 16:01:15 +0100
Message-ID: <20261118150451.740613655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b14c7a7e90f67..0602b81275262 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1716,13 +1716,10 @@ static int loopback_cable_proc_new(struct loopback *loopback, int cidx)
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
@@ -1755,6 +1752,13 @@ static int loopback_timer_source_proc_new(struct loopback *loopback)
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
@@ -1780,6 +1784,7 @@ static int loopback_probe(struct platform_device *devptr)
 		pcm_substreams[dev] = MAX_PCM_SUBSTREAMS;
 	
 	loopback->card = card;
+	card->private_free = loopback_private_free;
 	loopback_set_timer_source(loopback, timer_source[dev]);
 
 	mutex_init(&loopback->cable_lock);
-- 
2.53.0



