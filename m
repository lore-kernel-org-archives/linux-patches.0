Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE7714265E;
	Thu, 13 Jun 2024 11:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279008; cv=none; b=ri52WzhFudXLaoIicj6306ifDIfqxx52u6VRORY/bBnHZ0TYm6Ff6Son3aRiRijhkS0XKqsyO/wq1U27iCoQmCOx2kO4ZukGscXaWkg/Y3RWvXiq8MlK/NBymP5inccZLJSoXO9e28rETVjJCIwdOofuk4gEW7murkRjgMDddLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279008; c=relaxed/simple;
	bh=153jXKE9Yydfb7ioXSTK2Zfi94C6YUgXIuoYg8g+6BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqehLIMcnmxCIZUKUclqbEamkkDeRazYrEZFxA1syfZONteMh65L/N9/dVSNidm9+lyQHeOl7a93UoYNIv8HqlQmbSZOw11E4CJRqPdOKKD8+8rIW9pj/q8E2FHrl4BIK4RO8EG22G7MMVgA0A6VagbEHHo7Kcg0iLhMUtza4T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQzwPsPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQzwPsPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104CAC2BBFC;
	Thu, 13 Jun 2024 11:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279008;
	bh=153jXKE9Yydfb7ioXSTK2Zfi94C6YUgXIuoYg8g+6BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQzwPsPG5pr6HnjBnyh3j2njykNFk0vFwa4+NSNvMUcuGzn43+2kELeLy7KrXzaOf
	 XiTUKDZJ2Jhz2bvE4Zp/Qg2XwBDL3DV3CrJIYJX+Te7bAIAxdDg9xk9rc2KjnyOkft
	 T7BleT2PK+pKuQhm6NGTqDo5zYcb126S2/Lo4Vy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+43120c2af6ca2938cc38@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 143/213] ALSA: timer: Set lower bound of start tick time
Date: Thu, 13 Jun 2024 13:33:11 +0200
Message-ID: <20240613113233.508453521@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4a63bd179fa8d3fcc44a0d9d71d941ddd62f0c4e upstream.

Currently ALSA timer doesn't have the lower limit of the start tick
time, and it allows a very small size, e.g. 1 tick with 1ns resolution
for hrtimer.  Such a situation may lead to an unexpected RCU stall,
where  the callback repeatedly queuing the expire update, as reported
by fuzzer.

This patch introduces a sanity check of the timer start tick time, so
that the system returns an error when a too small start size is set.
As of this patch, the lower limit is hard-coded to 100us, which is
small enough but can still work somehow.

Reported-by: syzbot+43120c2af6ca2938cc38@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/000000000000fa00a1061740ab6d@google.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240514182745.4015-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ backport note: the error handling is changed, as the original commit
  is based on the recent cleanup with guard() in commit beb45974dd49
  -- tiwai ]
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -529,6 +529,16 @@ static int snd_timer_start1(struct snd_t
 		goto unlock;
 	}
 
+	/* check the actual time for the start tick;
+	 * bail out as error if it's way too low (< 100us)
+	 */
+	if (start) {
+		if ((u64)snd_timer_hw_resolution(timer) * ticks < 100000) {
+			result = -EINVAL;
+			goto unlock;
+		}
+	}
+
 	if (start)
 		timeri->ticks = timeri->cticks = ticks;
 	else if (!timeri->cticks)


