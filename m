Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22181BC073;
	Tue, 27 Aug 2024 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771742; cv=none; b=s3S1oW39CAstnCRMGdasd/iSuLzufSPOzmED/K72R9j+gAwDeNmRQqbmmZSCyTcDod6QP4nSNCesLcyyNn5ljE4ma2m6ly5ZnobO2ggfIFXFRFDabq09MlPKwKrTXkOVz7wBoEiGM5Q+DYR+ehVS/4Kr4DN+VoS/bI0bncoq4Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771742; c=relaxed/simple;
	bh=Sy4c7bYR+NwiZ523EEx1qkkOdGvQHR1XHKHZzY2fLEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUtQjmIs6R09MegZ5NN1Gx3/nby+v2Le9QUAVf6tjJTXX5Qfo78jeO1nWg2JcIBTFY1Qol8I+5G7rOM0ZDjg/1I6ZVrGDY/EE70+CQM5yXjE0YKkyHerXVXEg7VnK1jk8APgaEaE/jnpU1BDj6IDEkVRDPIQJL9j1drru9l+iwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQRSU+89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQRSU+89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6986C4AF50;
	Tue, 27 Aug 2024 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771742;
	bh=Sy4c7bYR+NwiZ523EEx1qkkOdGvQHR1XHKHZzY2fLEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQRSU+89Pirdq8aczw9Ez4++2h8lcW+UgJQA9xsHjurjD9+/wemUN6gCaMMt54kbB
	 WzS99dfkrE3hLF4XhTk+ZXAMWzeucx5QnquGQXfOIn99E7i4cD6skAf8BzUiFwnoO1
	 d2T9O98h4MFDDn4Ebcc6PsXPvKrNr6kR6PzLvrXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+0122fa359a69694395d5@syzkaller.appspotmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	George Kennedy <george.kennedy@oracle.com>
Subject: [PATCH 6.10 273/273] Input: MT - limit max slots
Date: Tue, 27 Aug 2024 16:39:57 +0200
Message-ID: <20240827143843.786282031@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


