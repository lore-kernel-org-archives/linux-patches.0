Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74C62DC321;
	Sat, 12 Sep 2026 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226517; cv=none; b=clyblO2t8NNuEDSdj8MZ+aCGxpcsNK3IvOlvl5Fh/Uvkic3mq0Iq+B7QVngi0RujLC+TBYKuxgtl8OMrpmNIXdLc3YxctHKbG8p0rF8WbWH1U+d66BAycUYib3Zjq47Xh4GHhzw/xQxe7dEwkrv1o5VUWwDMsSgp1VBPg+3dSbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226517; c=relaxed/simple;
	bh=AlT+DzvSRr7mmya+qyN5d8nPgkXgNNYXlxf0e7S0Kwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3T2OP65+dA86A2yZJjVa+fDwMO6AMKow5Ri3DZH8PLovO0K1akL5JPN7qVETMxViR0yua7UeGC5480Ylfv0uJWPZdY9EBEMxt33wmmMHm89fpxGEb7W5DEma/dP/uX54qoW5OK9bc7+j/YYylbGS2faVTT1I/ffmuRFDgf6IRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lT8cYJUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lT8cYJUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE48D1F000FF;
	Sat, 12 Sep 2026 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226515;
	bh=ECOzkcWMlLtH3AOFm3nhfL0xb9zLU503dnbBPW9HEuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lT8cYJUJ8JgnpcErGiDqJk3VxcCjMFDU2XM6nf35Ii+UPma09rPPfRrWJLdcN665L
	 z00qrJKjeGOf7w/EdTqnNgvny9bx8TjZkOqfup3/jBhKQH7AGS1Hr4a2InAkLSeSsr
	 GzGXcb17sFSuHRxnM1FgyX5/R478OD7WLHYZC92E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1419/1424] ALSA: control: Fix unannotated kfree() cleanup
Date: Sat, 12 Sep 2026 09:04:11 +0200
Message-ID: <20260912065639.037383617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3eca2ff89ab42..784867f29f0b0 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1275,12 +1275,12 @@ static int snd_ctl_elem_read(struct snd_card *card,
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



