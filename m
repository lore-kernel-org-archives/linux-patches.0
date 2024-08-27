Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B331CE703;
	Tue, 27 Aug 2024 15:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772793; cv=none; b=JVGKdGIUbEfoEWzoWjpN3DMQBlJsXDTKLcGYRb8Z78o+JoWGULCqnd0vwfOoI0SlXo+sJrr7GRQX/tOoihIfOLKShw6MQvuYCXnKl+uQ/ANzPHfy9nMEsE5x4DowVxyAI41/c3nMohmuGIN6wY/BcC9ALL6V35zWdqrBKgNFO+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772793; c=relaxed/simple;
	bh=YvBQiEO1w6D90K1dE4Qq1o7pKV5GPzysW7aWF/JNejE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvV+NmP+kNiU+t23Fhcbvu9nrLldlvxoRXDIxEcQaRWCRJd3BJpbodpW21J37SoP8aAEGTi7T/IWIPcjXuWeZ3QJQcoNl7JHHbmV9Q/8JlAq+bUVLRnkT5rHjFfh9+BR0Tgi8kwl4B08eTTeXz+uZm6cr87bR9j0tHcJnU6wm74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GH7Ljgej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GH7Ljgej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7E2C61050;
	Tue, 27 Aug 2024 15:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772792;
	bh=YvBQiEO1w6D90K1dE4Qq1o7pKV5GPzysW7aWF/JNejE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GH7Ljgej+TeJW9nVVgIk9AbM7Pe3wJPNBmcGZmkrFdmXPagEMjkxZrHdy2i3/mEug
	 kY021aHCh+/4zAk2ugkK6KfL/S2WKMfEaFSD6ASPphIZX2fCoBq2efOZtA+M4Hq5m3
	 +50BoBXmDhmH1ZyJ/vLiKEqSjCloIRJZK/9BQfnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+0122fa359a69694395d5@syzkaller.appspotmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	George Kennedy <george.kennedy@oracle.com>
Subject: [PATCH 6.1 321/321] Input: MT - limit max slots
Date: Tue, 27 Aug 2024 16:40:29 +0200
Message-ID: <20240827143850.478100588@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


