Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A901C831A;
	Wed, 19 Feb 2025 09:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956755; cv=none; b=bhTJ/Ojc59/ATtyDjEXCfhJzAZ8FTyhmZ6zGAyHu1TQ5jPaGNHZtuaF1OLmFM6lVoxhgGFNRAxT0GgGYAa42Nhdi7O5EkogbT3QQ2PTuBOaXbQUBJydmhTZrTLsb7RqzcNcYLUIcHRd7EapsysKyjPcVymSbG3djozdNy69f/HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956755; c=relaxed/simple;
	bh=stuYAaVOoYzhSOEbSOdZBuwR4QaYgZUDB5lkUR5HHRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2zpxFtuPw2FY2sUWw8NCIK8OvmzypuPsCAU4fMl93ID4LK7s9iDd4IGiEKeg8eooPYeH3ZsfZQVA468FX7QyalwObolnq419NDOyCU8thUcl6TFB5+24pGvZGXJUKzphfB+hXIehncfenoMFJt0a5G1kTF/1plFT1UzLStOKVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ieK5IwRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ieK5IwRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A449C4CED1;
	Wed, 19 Feb 2025 09:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956754;
	bh=stuYAaVOoYzhSOEbSOdZBuwR4QaYgZUDB5lkUR5HHRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ieK5IwRVPleY/GlZbYy85fUW2c3PvdZGmPDOkEPPVfVRlKG5iwMhSHQxEJkuzKVDi
	 /q6nfojAjv/MftXFIq+7hjhQNj3rLcXvj2kFhSRYK5GmemytxEzcmJGCKBaABYxDN8
	 dxrsMEk5gec072H/YMFPOw7JzcrNaemo5IabuOMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7536f77535e5210a5c76@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 289/578] tomoyo: dont emit warning in tomoyo_write_control()
Date: Wed, 19 Feb 2025 09:24:53 +0100
Message-ID: <20250219082704.381071349@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a7af085550b2d..5f1cdd0af115d 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2664,7 +2664,7 @@ ssize_t tomoyo_write_control(struct tomoyo_io_buffer *head,
 
 		if (head->w.avail >= head->writebuf_size - 1) {
 			const int len = head->writebuf_size * 2;
-			char *cp = kzalloc(len, GFP_NOFS);
+			char *cp = kzalloc(len, GFP_NOFS | __GFP_NOWARN);
 
 			if (!cp) {
 				error = -ENOMEM;
-- 
2.39.5



