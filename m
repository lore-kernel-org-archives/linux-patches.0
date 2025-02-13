Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C1413D8A4;
	Thu, 13 Feb 2025 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457387; cv=none; b=rwtmJPK1KfdbHATn51PFCGnfngfH5UZABsDku9vvWl58YjXPW7TQ2wNSVa2N0tjYHdP7LJcS1nRM1SCtqBr32gPY/oRenkcpZD9BcFkYw3elUJShfm8AfB49PRMR0m8KtNd3HcaUDMhrjMdJ9yjcd5L6LCMNMGtAqDowZ22wUHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457387; c=relaxed/simple;
	bh=LGk7Maajl+/jCZiE15E5o3IcgIVyWtgV7ndaklg/rKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAlyWZ9OppJq0H35S8G6RXvuf3gt1s6lGQocqd7IYMg8JA0eh8NEkaQHpDudlyLvGGDFHWXhRMC+zKn0HET4X51F0uzxu4FnGMJy8phXBmwWQeboqKSpmrMBjHhUkMsaQnE7DRh6v8pzxvx0t6bt4wNSJKt/rBw8AYhips8HcWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXZHXKcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXZHXKcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A51C4CED1;
	Thu, 13 Feb 2025 14:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457386;
	bh=LGk7Maajl+/jCZiE15E5o3IcgIVyWtgV7ndaklg/rKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXZHXKcGRfofK7RZI4ZGvjrfvpmCiYx8+nUDv83wWza/sowjjxlXaRPNVfk+R9iGM
	 nuzwKzE2CBNELn0PRTU+OeeSpuCKdZ/GnjDz+xS5ZeSgB6i/BwYGH3fyCt5l+23Leo
	 A12hhswvKsZ/TWQSIN3KgGktdVyaMG2NfU+cQSd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7536f77535e5210a5c76@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/422] tomoyo: dont emit warning in tomoyo_write_control()
Date: Thu, 13 Feb 2025 15:23:22 +0100
Message-ID: <20250213142438.608856943@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5c7b059a332aa..972664962e8f6 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2665,7 +2665,7 @@ ssize_t tomoyo_write_control(struct tomoyo_io_buffer *head,
 
 		if (head->w.avail >= head->writebuf_size - 1) {
 			const int len = head->writebuf_size * 2;
-			char *cp = kzalloc(len, GFP_NOFS);
+			char *cp = kzalloc(len, GFP_NOFS | __GFP_NOWARN);
 
 			if (!cp) {
 				error = -ENOMEM;
-- 
2.39.5



