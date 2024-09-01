Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F7A1C68C;
	Sun,  1 Sep 2024 16:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208995; cv=none; b=NODc9yvLpkmPUaxOeL8ZgqmqJ0Zqnw3G5dWx7wADTf7pt5x1jDEomdd76SIL7tqgoewbAmodjPdhjuWwqUV01SxWtBJ/Vu6RakshK8pe/Ml1ODOKvKdselMEaLY+RMr6y0voVUof//0kU7mD/DvHRWRJ8/Kp5U7cp/KxrRM1GcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208995; c=relaxed/simple;
	bh=2RdkWsPnLQj0uSxS0QHCchFxpsmyTWl66U2KrZc/86k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liQbIyYf2tZQIyQdhAsV34CllXWlUi98QnEvBiQh8uAm33c/h+/zUvS2zHwjaEg/qDC2cbl2WuQOKhJM/doZ2HdRU9zaNXAxvLFHHbT8axf/lkXVfuxqpvSa3JK8A7SNDpFBNMi6GX+UA/pdA1vE/NIpDOfBgoQgg8TfcXl8XhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ibb9jQXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ibb9jQXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4434C4CEC3;
	Sun,  1 Sep 2024 16:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208995;
	bh=2RdkWsPnLQj0uSxS0QHCchFxpsmyTWl66U2KrZc/86k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ibb9jQXHUcU2+VVLz8xS+hXf+gcvHqJwvZpV/a+ryYa+5IfMVB5FMvxMfZZ7uAM3r
	 LjIEXP3Xk+FDavqzKF0Ta0VnW08TFQrg7zRm6zRxD7gQVtfSq9+BibZIPgUjUdNXFo
	 3XcPKgolQHkUbil3b0MVgm5s9zOCN2eO4hu/XUN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 103/134] ALSA: timer: Relax start tick time check for slave timer elements
Date: Sun,  1 Sep 2024 18:17:29 +0200
Message-ID: <20240901160813.965385670@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ccbfcac05866ebe6eb3bc6d07b51d4ed4fcde436 upstream.

The recent addition of a sanity check for a too low start tick time
seems breaking some applications that uses aloop with a certain slave
timer setup.  They may have the initial resolution 0, hence it's
treated as if it were a too low value.

Relax and skip the check for the slave timer instance for addressing
the regression.

Fixes: 4a63bd179fa8 ("ALSA: timer: Set lower bound of start tick time")
Cc: <stable@vger.kernel.org>
Link: https://github.com/raspberrypi/linux/issues/6294
Link: https://patch.msgid.link/20240810084833.10939-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -527,7 +527,7 @@ static int snd_timer_start1(struct snd_t
 	/* check the actual time for the start tick;
 	 * bail out as error if it's way too low (< 100us)
 	 */
-	if (start) {
+	if (start && !(timer->hw.flags & SNDRV_TIMER_HW_SLAVE)) {
 		if ((u64)snd_timer_hw_resolution(timer) * ticks < 100000) {
 			result = -EINVAL;
 			goto unlock;


