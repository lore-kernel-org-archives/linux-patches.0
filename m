Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7FD361977;
	Sat, 12 Sep 2026 19:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240743; cv=none; b=FpkKKsz1Y0FjerA8Sb6bTNXMzpyOyH2iSYGcvW8rzTorPAjHN1HWrT5ZRbr7TFNfnc1++orJFn2au1zsS6rDUILjHsP3qO3pQCJq9ln7vdtvW8I4kLLvfRZ5d2Pm8/67KMB6S2d6bRA/MJ/3seOysMWY/k2EUW7V5NL45CVGJL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240743; c=relaxed/simple;
	bh=2+52G4Ri34oOT30HFgZZY4+1+NVR/PrPALDVmqWAgow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h30CmMSd9T5/zS6+ryRh74Jls9ZNmFr7uxKjNZcIvKKB02tFT/ANRxJpfg3QQgBMHTSsQTIqOIzcrqSuz4go45KLAWPO4leX5GAdv8ARSV6L2kRLICaFNTzvVmoKQQirWay2jB08aDlbR+2FUKk+WYurk7W6SjUvNt2omYjvKsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw8dXNob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw8dXNob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A1A1F000FF;
	Sat, 12 Sep 2026 19:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240741;
	bh=m4Q88b5TQw6z5Yj5ZkBdi+aJ7TqAq2x6WaDO4TM0St8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qw8dXNobdrfdqUyYmHYlu5JmSgBWWlZyCy21Yfgx0Snd4TkPh6wGbTBSALs5efjs2
	 TVQgYI3yRzXX7UyUOi0uIoHVv0lm65V8R6v4DklrM1nJST/BdMlnt5f8I2qGofXuDj
	 nAKUldZbyoq+wyMVp0gJkkimEJvvQSmL8DzAdKMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 930/935] ALSA: control: Fix unannotated kfree() cleanup
Date: Sat, 12 Sep 2026 09:06:00 +0200
Message-ID: <20260912065548.153604218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 14d811467f6592aa0e685730e66b5f9123287468 ]

The recent conversion to the automatic kfree() forgot to mark a
variable with __free(kfree), leading to memory leaks.  Fix it.

Fixes: 1052d9882269 ("ALSA: control: Use automatic cleanup of kfree()")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/r/c1e2ef3c-164f-4840-9b1c-f7ca07ca422a@alu.unizg.hr
Message-ID: <20240320062722.31325-1-tiwai@suse.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 59f8533b54036..bce311cd5326b 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1115,12 +1115,12 @@ static int snd_ctl_elem_read(struct snd_card *card,
 static int snd_ctl_elem_read_user(struct snd_card *card,
 				  struct snd_ctl_elem_value __user *_control)
 {
-	struct snd_ctl_elem_value *control;
+	struct snd_ctl_elem_value *control __free(kfree) = NULL;
 	int result;
 
 	control = memdup_user(_control, sizeof(*control));
 	if (IS_ERR(control))
-		return PTR_ERR(control);
+		return PTR_ERR(no_free_ptr(control));
 
 	result = snd_ctl_elem_read(card, control);
 	if (result < 0)
-- 
2.53.0



