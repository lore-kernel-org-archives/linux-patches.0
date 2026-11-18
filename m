Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046935;
	b=t1U9I+bSBshvFUGkEVjzrDAO/AiZwi+AZ7mfBMSyi8MDjxMC8WbeRSqb6N2f4J9oDm/T
	 iO4X3qQiLEsTbv4qa262XCuFQJd9etYRtjT5Uml1HxbR/Yy3xD5rcAruaNS3gzgKlUey0
	 fbEzJtXvsb7Jp+KRAI39IqP04dgMo2ht7gm33A6HVf0gBm3lZoaeH77SDsEMt2soq00KY
	 Vw5ShvD46+9rqwpnvAUT6Cf/LdIvr/xd1q5N+VoAZCqOjynLr4VHqtSt5miEBK1Dq2WXo
	 RLeEErYYA7VlbxhfI5B9Lzhlx0mplyUpEZcjcXs6r9dFXPeTwM0AjRSJsmd20TrsITw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SVCP6LZSH0Mdno2k6n0CFCqGrhP91r9kuMvpBxRgFxU=;
	b=1bwhvDn0emby28lCxIQE3clRuc6fO9y1ApyDgy8toWkY1Skk4/HmJIMNbv02O/3Jvh/2
	 kaYB8YyRJLx6YXPAx3eZuA+cSJzzMTr05cTxyGQhxcOQ7NBUVLCW72HSVvwqH1w2hmr1W
	 o6HCmVMllo/wV/zm/cXaQ8ml6klkNN6Jp08rUvi2qrtFLwJMQch6c8FUfK2MFeHFB9MbV
	 LlslU9ctEM0Tp+ummFkKdgGsVA2L0UyDciJbhF7jDwmBjZMapIi2vQEM6/0E0WdoML3pT
	 QCl+BiBX7MdSUgUEVTzs+xiP7NgIFMBK78T8VOAElBSCaAvchC81QSbji/9krk4zFpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPlNzrUP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4D0606A325;
	Thu, 19 Nov 2026 00:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPlNzrUP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AEE1F000C5;
	Thu, 19 Nov 2026 00:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046935;
	bh=SVCP6LZSH0Mdno2k6n0CFCqGrhP91r9kuMvpBxRgFxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPlNzrUPpHjQhWeeS/CGS1rth32x2k0kfdZehZ4RmPUKHCIvlZMew+MhkUGQU7hFN
	 sMCL7xiDKl4lgIvFutplmhAxJUXzOndvi1Uxgj4jt9AVpaoYknmaIVYfg5RAy0V6F2
	 FJIm3RPbLmN5gXNnyBS2I/frWHU4g506i3WpH8f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1458/2857] ALSA: mpu401: shut down timer before freeing MPU
Date: Wed, 18 Nov 2026 15:41:32 +0100
Message-ID: <20261118150253.813048063@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 9332af5220d42341bb1446a62c545c0518e990ef ]

When an MPU401 interface has no usable IRQ, the driver polls raw-MIDI
input and output with a timer. During raw-MIDI teardown, the timer callback
can already be running when snd_mpu401_uart_remove_timer() clears the last
mode bit and calls timer_delete(). That API neither waits for a running
callback nor prevents it from rearming the timer, and free_irq() does not
synchronize timer callbacks. snd_mpu401_uart_free() can therefore release
mpu while the timer callback still uses it.

Initialize the timer once when the MPU object is created and only rearm it
while a timer mode is active. Shut it down synchronously after freeing the
IRQ so an in-flight callback completes before mpu and its resources are
released.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260927093809.681726-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: adjusted context for explicit spin_lock_irqsave()/spin_unlock_irqrestore() calls instead of lock guards ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/mpu401/mpu401_uart.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index f435b9b4ae241..e920a290ba1b6 100644
--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -161,14 +161,15 @@ static void snd_mpu401_uart_timer(struct timer_list *t)
 
 	spin_lock_irqsave(&mpu->timer_lock, flags);
 	/*mpu->mode |= MPU401_MODE_TIMER;*/
-	mod_timer(&mpu->timer,  1 + jiffies);
+	if (mpu->timer_invoked)
+		mod_timer(&mpu->timer,  1 + jiffies);
 	spin_unlock_irqrestore(&mpu->timer_lock, flags);
 	if (mpu->rmidi)
 		_snd_mpu401_uart_interrupt(mpu);
 }
 
 /*
- * initialize the timer callback if not programmed yet
+ * arm the timer if it is not already active
  */
 static void snd_mpu401_uart_add_timer (struct snd_mpu401 *mpu, int input)
 {
@@ -176,7 +177,6 @@ static void snd_mpu401_uart_add_timer (struct snd_mpu401 *mpu, int input)
 
 	spin_lock_irqsave (&mpu->timer_lock, flags);
 	if (mpu->timer_invoked == 0) {
-		timer_setup(&mpu->timer, snd_mpu401_uart_timer, 0);
 		mod_timer(&mpu->timer, 1 + jiffies);
 	} 
 	mpu->timer_invoked |= input ? MPU401_MODE_INPUT_TIMER :
@@ -490,6 +490,7 @@ static void snd_mpu401_uart_free(struct snd_rawmidi *rmidi)
 	struct snd_mpu401 *mpu = rmidi->private_data;
 	if (mpu->irq >= 0)
 		free_irq(mpu->irq, (void *) mpu);
+	timer_shutdown_sync(&mpu->timer);
 	release_and_free_resource(mpu->res);
 	kfree(mpu);
 }
@@ -544,6 +545,7 @@ int snd_mpu401_uart_new(struct snd_card *card, int device,
 	spin_lock_init(&mpu->input_lock);
 	spin_lock_init(&mpu->output_lock);
 	spin_lock_init(&mpu->timer_lock);
+	timer_setup(&mpu->timer, snd_mpu401_uart_timer, 0);
 	mpu->hardware = hardware;
 	mpu->irq = -1;
 	if (! (info_flags & MPU401_INFO_INTEGRATED)) {
-- 
2.53.0



