Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050336;
	b=MLnWwjns0vLIXoCf/GJpfrs0ywY1NvbzM9P4Rxb478rxc3X5/kGd2q+KAXqu9lh/TVkT
	 eusUraDRrCE3xFMkT24wbu5tolSB1YI+pct5yTHLQrZVLHR7o4zp/oA2H7o6CrhcwdgSf
	 /IB1/r0zwH4UoGwpIft2soY35wEvxgQlbyty4Pmy1UpPCvP/PkwaY0HuiSJCL2o0mN2ap
	 WLN52p0gMNcgp1Mh8+03f25aHZs+Mk+8uw1Yva+brHp/BrVRp4hNMkG6xOsuqgxwuy0Az
	 vdKMClVrkbt8lFH2Dx/TjakGzW3PQIvzvDFOL2eg5tCsxhxqadr1Q0kwQyo6MzN2UbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vNhI+8rN+9vGf6gmfVAdOx2YMCJFnsFMUHzSFRZvGAk=;
	b=4aO55N6bUKZD7tLWUllT7PF2x+iPg/PZnu/XZo7bkN9Cqf5FxmPkwp8OMMxrYm+kEsw5
	 rVYgmUl7Zs6vssQWwrCUhPK3EuHBKTDrHkjjR40djfOyU9PcqnhrW6BFTxBvVAANi8tDP
	 TtF+LLtgHtQgwE5BpbxVPNqEuRfPKZAZ+zKc/nQtVn4uhrB3X4sOJJ7LFwjtTsHVJ5tfz
	 2Oyc9KktlFtFnQqpz83sFeqtA/1MfggY+LKIBkm+BKFc/C7zMby4+L66NRPjCzrdciz8m
	 fJWcn1XhakccH4gjSqxFEr/Ej+Vj5J32+5WpXw8A5Z/u3tvRtpx0TY0ve1VjexVHjew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aknTV19N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87DF606A334;
	Thu, 19 Nov 2026 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aknTV19N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352AD1F000C4;
	Thu, 19 Nov 2026 01:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050336;
	bh=vNhI+8rN+9vGf6gmfVAdOx2YMCJFnsFMUHzSFRZvGAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aknTV19NJnAqO3N0iyECkcxXC5Pf5iqP0XbYKhAobvUiVXbK4n3XnpFl3S1tLofgI
	 Or5G5B+kywhlI1WcLGjAYrnZAFKd7M+rQNFk6EYcs064568I2Z96X+xTIaAPabfHks
	 KpZgy72piwM2zIgiZG9kUn1oyq79AsPiNKSl28ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2631/2857] ALSA: aloop: Keep the timer source alive until card release
Date: Wed, 18 Nov 2026 16:01:05 +0100
Message-ID: <20261118150336.323759725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



