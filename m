Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAFE1C825C;
	Tue, 27 Aug 2024 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770772; cv=none; b=T58B4Ik5/EOEGlF8lIalVqKj5v73PaDHY4hy+sQ6aT3PuglyRq+Ve7uXjc/oJLA5Kh1XQzOxM9Yw7vDQtBQBINBEXcefkaYV2/jQ7WgV2uA8cAiQ7GQXj6+sqIro9ZWCRUwZqu53gloIrUj3gT4xwfjNA74JAcEN7ju4xhgkaPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770772; c=relaxed/simple;
	bh=IJtXsM2gpLd12V8w+WT0gpMwBA2Nr6sKcqfQzpNSNNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNfg3bsuYOOvn1r4oT1uDv8Cd1ga2a9+SwsDpiZsPhnpFRL+K2zVinx5Us1HHYcsUr/Ox3aeZyWGSqTuuEz4gNFqKsVdQ2QCvubBaV6CWP0zqyPlBFxiUwQMTjMCmVMcleL1yB4AtMyBpZRqrDLqnfc6O+F4VceYtDJGK2nhRNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOfnBGlE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOfnBGlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE7CC61044;
	Tue, 27 Aug 2024 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770771;
	bh=IJtXsM2gpLd12V8w+WT0gpMwBA2Nr6sKcqfQzpNSNNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOfnBGlEpXwW+6u5+W2cqEZw+5nvO3RrE9wbmL1ABnHZaGqY2pjlB8krmsUaOivKf
	 sq1JRuXCuYJrlnxIaLnV7v3G+Bb3OEVLa5JwzyO8BkLAXNagR2fjRuoO+JmH5ksc7o
	 2Xm5YGMfH8y6RqJw+lwgzBuLowGDyjtPNqcH/W1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 330/341] ALSA: timer: Relax start tick time check for slave timer elements
Date: Tue, 27 Aug 2024 16:39:21 +0200
Message-ID: <20240827143855.953207946@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


