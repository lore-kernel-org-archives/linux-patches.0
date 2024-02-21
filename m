Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF7769317;
	Wed, 21 Feb 2024 14:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525347; cv=none; b=t77YMArDI9H2rxvOkRk19oP7s35cG07pULtHDq5PlbMfiPXJPW/wCglS/XMFjBqkdd7h3j5eBOz6qYNvopOh3B7LbS6FjuMj0m9e8M1YgU1gcf0XxunSaRRdyKKIZdPlcS1SFN7S59mIePYe/6TTTKVhj2PP4BsV0EQjEKtRRH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525347; c=relaxed/simple;
	bh=0vFxMKzXTDrYteu3pxh18YA8nah9/EX93y2KuY2EQEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1VhjVcqmb0HUpqaJTJ14BgZ84h8H9DSQXWxc8tEx46RPR3C29Q2uM378QKuhSIfISfjDsOc9hPF8/hRXgTV/uRhFwIifpkHoBV/tzaIY4LJpjgEoajCWY6JhIOtvZqBfUko/Oj5krBK/ZMZHqes62gCU8YKQFbZi5mmPAGLSUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXzburwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXzburwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6BCC433F1;
	Wed, 21 Feb 2024 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525347;
	bh=0vFxMKzXTDrYteu3pxh18YA8nah9/EX93y2KuY2EQEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXzburwW9sKGW6DKMDKNrxyGQN3CMwFa6VITGbpbOr7g+o8skTINXynGdKy1xKz22
	 wAKTluOkjBf+o0hUDBEWf1rRm+if+Nb66uzEMEpjYdLynqGLnDrA8jN2aDvhf5Weoi
	 VJHWWF66T4nO5a2STTs59srFVOnPaWvD6EzyQrNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Potter <phil@philpotter.co.uk>,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/267] media: stk1160: Fixed high volume of stk1160_dbg messages
Date: Wed, 21 Feb 2024 14:07:48 +0100
Message-ID: <20240221125944.021576018@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit b3695e86d25aafbe175dd51f6aaf6f68d341d590 ]

The function stk1160_dbg gets called too many times, which causes
the output to get flooded with messages. Since stk1160_dbg uses
printk, it is now replaced with printk_ratelimited.

Suggested-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/stk1160/stk1160-video.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 202b084f65a2..4cf540d1b250 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -107,8 +107,7 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 
 	/*
 	 * TODO: These stk1160_dbg are very spammy!
-	 * We should 1) check why we are getting them
-	 * and 2) add ratelimit.
+	 * We should check why we are getting them.
 	 *
 	 * UPDATE: One of the reasons (the only one?) for getting these
 	 * is incorrect standard (mismatch between expected and configured).
@@ -151,7 +150,7 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 
 	/* Let the bug hunt begin! sanity checks! */
 	if (lencopy < 0) {
-		stk1160_dbg("copy skipped: negative lencopy\n");
+		printk_ratelimited(KERN_DEBUG "copy skipped: negative lencopy\n");
 		return;
 	}
 
-- 
2.43.0



