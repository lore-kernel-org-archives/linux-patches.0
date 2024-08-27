Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1DB73466;
	Tue, 27 Aug 2024 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770812; cv=none; b=MeOGk+zuQLpP2vVMkOAW98PByH9TPLEp24vd3UtWkSyn/7vCtPIDWTtNvi8Fb6jFVKGi+/WvJ6OsR37QipQgbA5DV7B91wYMiDYinTj4pdlnCk+OpvIcBAux7bZQf+RFa9RsY41ZJmYd9XHPEKqZaGSKSEdlpbLOnwPSPY5A2U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770812; c=relaxed/simple;
	bh=gWrs3Wr1XlBHZ7HdbAkcg5EwxcIh2stTHGcmgJ/waY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6PzNnL48/Jv2HwaJAQXBDrDnVpXYQBgCUvIv6XVfwlV9FDdKLZTK+QIAIYqOhQyn8X0fx7Bi8xUq1tgVM91u2VA8xGjObi45lBtQvGn6hRH56gEo5gCOdU+DqpcuTcDZJKCr0GHgW4WTavvaIkg7pizvU9XDsrbevr0hwwjg+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mekW44LO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mekW44LO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68440C4AF1A;
	Tue, 27 Aug 2024 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770811;
	bh=gWrs3Wr1XlBHZ7HdbAkcg5EwxcIh2stTHGcmgJ/waY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mekW44LO5adC3Kygqrr+L27gtbD0U0TdVVxHU3ti1l+Z/T4pNrBO5RM/PHEsHD6ej
	 Poq1o5R6wzctg2aGC5XxwKGPlEN+4NWhqwALXglAblCPAq3yBbIh/byoJTay6A2rdy
	 3wveYyrJ9kW+/IUpYbZzu9/txvNXYMARRFKh/A98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+0122fa359a69694395d5@syzkaller.appspotmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	George Kennedy <george.kennedy@oracle.com>
Subject: [PATCH 6.6 341/341] Input: MT - limit max slots
Date: Tue, 27 Aug 2024 16:39:32 +0200
Message-ID: <20240827143856.370648876@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 99d3bf5f7377d42f8be60a6b9cb60fb0be34dceb upstream.

syzbot is reporting too large allocation at input_mt_init_slots(), for
num_slots is supplied from userspace using ioctl(UI_DEV_CREATE).

Since nobody knows possible max slots, this patch chose 1024.

Reported-by: syzbot <syzbot+0122fa359a69694395d5@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=0122fa359a69694395d5
Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/input-mt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -46,6 +46,9 @@ int input_mt_init_slots(struct input_dev
 		return 0;
 	if (mt)
 		return mt->num_slots != num_slots ? -EINVAL : 0;
+	/* Arbitrary limit for avoiding too large memory allocation. */
+	if (num_slots > 1024)
+		return -EINVAL;
 
 	mt = kzalloc(struct_size(mt, slots, num_slots), GFP_KERNEL);
 	if (!mt)


