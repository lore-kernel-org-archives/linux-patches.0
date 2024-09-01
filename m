Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BFB208A7;
	Sun,  1 Sep 2024 16:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209696; cv=none; b=TfOmcs5zJZhLU7G89363qsurBnE0e2rewRu6Bz6XWIi6EtqcN35R3+Mf39n8jsmltt6bDbFQSplYmQZ0TsSOyNS3Fpgd/8VeWkJGyVAJX0A8/kKBAt50bNKqj6pNdp1fG8TQMQ6SthqSxVwejz5PCTRQROmPyCoS3i1fyetldIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209696; c=relaxed/simple;
	bh=o4UQBlij8buWl4/1gmOLBCP1qX5INPglgMSKZXFhqr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tji8CDO1BRgHh4KRuMD1sB+aDyEQlOdl2Eke7uJAY6x0iap8P4ID/33NfE9GChU+Qv34q+FISLvfZImqxfiV3cy877C9sd+EDSnjoDF4wfIx7nF65lZjDhzG2yYA+BU7EHw7tIvqKqmSMSbxjrdoLHzSspN8TF6uL1cedJiP0+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9cHDcq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9cHDcq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B28EC4CEC3;
	Sun,  1 Sep 2024 16:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209696;
	bh=o4UQBlij8buWl4/1gmOLBCP1qX5INPglgMSKZXFhqr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9cHDcq8DalCYYebRNpYL10ws246TagtRDXo58c9qBwBKtXJ/RITGjjAohXQ6shZP
	 GJ+c574q9PtzdER830fAzxrEDl4mIBWY+jJXbpaPtcRMjTA4l5qvcMrmQaDOlvVRPH
	 PLyKbmQfpjWG+6TJ+bAV31uKWkRk6GmdaNEYnfl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 116/151] ALSA: timer: Relax start tick time check for slave timer elements
Date: Sun,  1 Sep 2024 18:17:56 +0200
Message-ID: <20240901160818.473248237@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


