Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1448F26B098;
	Thu, 13 Feb 2025 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460255; cv=none; b=PNSVKssTFUI7VC/9Mq95WcMZMF5bDPcf72+9H/6VPlPPaiCg6i4gX7IiUtw8kelw29pXLST4tFjIIRmnIqPow1LI10ShT+TqdoCS1TEhgOijMNo2xbmOzf1tptXk2RhUahEuyhawP450M8heDFywq07uYlyqr/QZAfDbuEFQX9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460255; c=relaxed/simple;
	bh=E3d9c+fbRsHMb0cB/TaZyv9bWnfQsIoKE5OjrJpdJ2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzifZEcKK8XMYX70WR19TugdiCPQZRHRwSJK+Phnjk+8RrGXwW4600PCOqI+t0naC5Aakm0kTVpruZM9Czo/Ye3NAnSpgY9v1uMs8yudLQXgIOQnax40TDtJZzPP01Y6ZYJMojDX7zmO/PLSpI+OD7WwOURFtTsYF18odUMgM3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIenR+qH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIenR+qH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758E4C4CED1;
	Thu, 13 Feb 2025 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460254;
	bh=E3d9c+fbRsHMb0cB/TaZyv9bWnfQsIoKE5OjrJpdJ2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIenR+qH4G2Ma+BzR3orh1UxCpDe/jyPmiQP1R/KVDas+KjOy2feUm1oC951/DUUz
	 QIlDE/i2Ut1L2BROsCvnehipsJG+IHTfmPowspgHSuJ4f76iFF0zNhxsEWVLt13Hby
	 GFg8x09vBFi8RYN1lcivxc/Eu1wbyffdqouHeKQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7536f77535e5210a5c76@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/273] tomoyo: dont emit warning in tomoyo_write_control()
Date: Thu, 13 Feb 2025 15:26:44 +0100
Message-ID: <20250213142408.625995672@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ea3140d510ecb..e58e265d16578 100644
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



