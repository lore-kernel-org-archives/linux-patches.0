Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB35926AC1;
	Sun,  1 Sep 2024 17:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210507; cv=none; b=nC+pt32vCzH3x8eHPr0Wcd51BKqDmmWTekCSzUp67dfY3PPVMchXfirGRKB9uJW5tPrgFLx1+wBWHKmZ0JuTBAdfsg0EeQjUVvpt+FdEO9L8eyZGGeCDa2/XXn71BmPI0Eg4SomSXTFy3P4CFNHQGLe0p+rXNcvd1o+rZKtAkEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210507; c=relaxed/simple;
	bh=67SrPtkfRMiW1Z3YbI5qLhzOY87VvPZ1J2lP1IAL6Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqbNGF3lpTn7MEkWlmEymqR/4QQuyXzAiRiwzvaqBRU9xCs3+uTlPb9d5RBBdeDS94slYDY3Z3+qjlVjUog5ho5L2GqQZbf6w+pEq+3Y95+gQj9ccxwyJdo4w8WE9wzt1qng7YOYqGBzJ+yJR0ji6JYY31RCe3MB662vjXz0MN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WM5sZsEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WM5sZsEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DEEC4CEC3;
	Sun,  1 Sep 2024 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210507;
	bh=67SrPtkfRMiW1Z3YbI5qLhzOY87VvPZ1J2lP1IAL6Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WM5sZsEkhLtlE/McjjdZx0bBH/czH/hZIXA8lutiW6EkgGJbyxlBlY6tchnKihfzT
	 deB8Rov52Cs1ODubxxaKDrBwlIdBQ6GsYBRDVYBJHEALavq/29rdKj0PtEZJO/fy1X
	 4N+swxHdtVDNc1m2gqxztm/FxeCDGXjZEEdSo6cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 169/215] ALSA: timer: Relax start tick time check for slave timer elements
Date: Sun,  1 Sep 2024 18:18:01 +0200
Message-ID: <20240901160829.750536831@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -556,7 +556,7 @@ static int snd_timer_start1(struct snd_t
 	/* check the actual time for the start tick;
 	 * bail out as error if it's way too low (< 100us)
 	 */
-	if (start) {
+	if (start && !(timer->hw.flags & SNDRV_TIMER_HW_SLAVE)) {
 		if ((u64)snd_timer_hw_resolution(timer) * ticks < 100000) {
 			result = -EINVAL;
 			goto unlock;


