Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5247143C67;
	Thu, 13 Jun 2024 12:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280156; cv=none; b=FaP8IWZ3TavPEoBbYeA/1qSXkNQElR4ZPPLxXNDESmpfRqFMHcdUVKf8+0RanDAie0teHnv7Of7QBqYcoz/YzRnIjMV0gCoQj949cNP8Jd9KD2pZ1VsGQYc738I8kt/K0H05W+hcGVPg304lL4tMAIKI4Ladz4mcj3UZXZPTJxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280156; c=relaxed/simple;
	bh=Lvuj3vJbKWqD57qZw09OKK+5OlwQiEstQ+VGXLUdTtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evEkm6pvx8AMX0iezcMvndyTeeGz00aLMOgSyrQxzZVn6dg6UWYpbdQO/nfOFhBa9l8q+o33G8Z5slcEEHAbQUwGExGAI/JXnI8BhwyPOuPCrQGd4Vr+to9Oqirhk0k+fJtkK0C7EAHiv2I3XnF3KLqqgLGubwCMMJmZnx7MJrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TynUTW8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TynUTW8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D544C2BBFC;
	Thu, 13 Jun 2024 12:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280156;
	bh=Lvuj3vJbKWqD57qZw09OKK+5OlwQiEstQ+VGXLUdTtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TynUTW8XVihqZJ752PlvaS5aZoY/BI4MNUiqAUGqagBxfvaujMKenb/6f8R+6fVoG
	 5rRJNHpAnTOu97seVTnH6cCU22YlAbt69MLyU+OD6xYApoT6+vV7dNCza0oa3BZFUS
	 qjzttGag5SmyFj2+uUeG6jL8tSSns9QUYrdeZuFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+43120c2af6ca2938cc38@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 162/202] ALSA: timer: Set lower bound of start tick time
Date: Thu, 13 Jun 2024 13:34:20 +0200
Message-ID: <20240613113234.002485572@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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
@@ -524,6 +524,16 @@ static int snd_timer_start1(struct snd_t
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


