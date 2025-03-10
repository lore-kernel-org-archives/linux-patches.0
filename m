Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A0522AE7C;
	Mon, 10 Mar 2025 17:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629204; cv=none; b=M+FrVRzsZOJDSFU8Xgy2rhV6XQAJSspBZdhGrTJGQmVLe6LmCMed5UGrzz3fASwO7PMt1ffssXXC1+3eppL7d0o1Yl1RwCvZaNC1hKYDqsDt6+ZuBKibfEP6Pnqngh4nRcS4lpUjx8gqKkJ3yx/xYInvT4ErioBlbkHdoHFE40I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629204; c=relaxed/simple;
	bh=RNnl2Htd8e1R0xc0euRAb7sRGdkle1nNwoHj+8VepGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4IJJojuJckLfwqHeGdih7IxKMSIR4cq+mZ9k97ltGlx9d/gI0dsWsp5BYlQ/EYbGdywlL+zSzqer0TjjO0w/F+qVvxI9KDMI6vzryo2KOT73752o30pUJXmd/Djuo0npl72UOPbwQRmnRG5xVRb1WfUYQGn6E8ubzcfkpjwClo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuuLP61c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuuLP61c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF97CC4CEE5;
	Mon, 10 Mar 2025 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629204;
	bh=RNnl2Htd8e1R0xc0euRAb7sRGdkle1nNwoHj+8VepGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuuLP61cCapv3bgeXxXm/rLDjzdtLUqhxs4nHyA3+FkjZgc5y/KoifTTx2vuc46tT
	 OlIQMQnUfc+B1NsutJwOVe7JKvKxiv81KeS3+Ec+QeVbYoGH0U8z0TOgK6zNUDWLJx
	 4xLM1xxqQQqSBSgZKVRihc2F3GC73J3W19yZuEyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7536f77535e5210a5c76@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/620] tomoyo: dont emit warning in tomoyo_write_control()
Date: Mon, 10 Mar 2025 18:00:58 +0100
Message-ID: <20250310170553.992476596@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3df7546fc03b8f004eee0b9e3256369f7d096685 ]

syzbot is reporting too large allocation warning at tomoyo_write_control(),
for one can write a very very long line without new line character. To fix
this warning, I use __GFP_NOWARN rather than checking for KMALLOC_MAX_SIZE,
for practically a valid line should be always shorter than 32KB where the
"too small to fail" memory-allocation rule applies.

One might try to write a valid line that is longer than 32KB, but such
request will likely fail with -ENOMEM. Therefore, I feel that separately
returning -EINVAL when a line is longer than KMALLOC_MAX_SIZE is redundant.
There is no need to distinguish over-32KB and over-KMALLOC_MAX_SIZE.

Reported-by: syzbot+7536f77535e5210a5c76@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7536f77535e5210a5c76
Reported-by: Leo Stone <leocstone@gmail.com>
Closes: https://lkml.kernel.org/r/20241216021459.178759-2-leocstone@gmail.com
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/tomoyo/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 9a66e5826f25a..cb8184122b920 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2673,7 +2673,7 @@ ssize_t tomoyo_write_control(struct tomoyo_io_buffer *head,
 
 		if (head->w.avail >= head->writebuf_size - 1) {
 			const int len = head->writebuf_size * 2;
-			char *cp = kzalloc(len, GFP_NOFS);
+			char *cp = kzalloc(len, GFP_NOFS | __GFP_NOWARN);
 
 			if (!cp) {
 				error = -ENOMEM;
-- 
2.39.5



