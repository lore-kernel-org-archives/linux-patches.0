Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B6C25E446;
	Tue, 11 Mar 2025 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705599; cv=none; b=AXqJ+a/KJt9fi5U+1h7olGfbyyZyC/ANyzW4HEw9y7x6MHileNJr4PuFS7HMbBh228//IuJFonYMTUJE+gyVxb3jWkrL71UYKNl0jpRhR0e8izFHWbJUx+MUdSWtEAY0YMYaOOXOXk3AW+JRjP/+3UvvTs3RQB8yE4cUHPTWKGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705599; c=relaxed/simple;
	bh=aQvNJNI4doWF1nT+EMUy8HOdy3sIx9qi1cWhWM4p9wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clXM82L7HTqT8rUmdHm+m1CTXklg4WsOvQHSG9updPKR3VC6mSUpev4guwYnwfPE7oOG8nOUmfd45zl6I7nusxq0oZa0Smn9sHJfSLx7JMtUQE302WLe6VoknSahqkpjJMVpBRKnNpcBuY5NTNzbq0sTsQKRR0d9IV2p5mjOfJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtwCPlm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtwCPlm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B661C4CEE9;
	Tue, 11 Mar 2025 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705599;
	bh=aQvNJNI4doWF1nT+EMUy8HOdy3sIx9qi1cWhWM4p9wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtwCPlm6x7T+tU7H5cU4ZY91N6RgurADEcaLqe+1flhdLsco/B7AKMfzHHPdYDBB/
	 KF+TYO12K8wDl56AACrSDsJ0RToGkL5H+UMYnLvcbncKJ83DiAO2pJrBaDs1FaA6NH
	 0ZcE5fI1oz8U+kvZcv8vdFMYWNhBuk9OFnnSQ4os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7536f77535e5210a5c76@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/328] tomoyo: dont emit warning in tomoyo_write_control()
Date: Tue, 11 Mar 2025 15:57:41 +0100
Message-ID: <20250311145718.502333578@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1b467381986f7..360cf2960f349 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2674,7 +2674,7 @@ ssize_t tomoyo_write_control(struct tomoyo_io_buffer *head,
 
 		if (head->w.avail >= head->writebuf_size - 1) {
 			const int len = head->writebuf_size * 2;
-			char *cp = kzalloc(len, GFP_NOFS);
+			char *cp = kzalloc(len, GFP_NOFS | __GFP_NOWARN);
 
 			if (!cp) {
 				error = -ENOMEM;
-- 
2.39.5



