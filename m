Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA01C26AC1;
	Sun,  1 Sep 2024 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210487; cv=none; b=OG9ztSqTvsvm9h19p1SlpkSCTomKKXrGXlqvQnKqmux7eHdsNtVuHBPitIAPJDNeFMzKRoxDPQD76s9Hiqr1otsFoVzLabQkyNSvC4hXv3LVmZL9ZaY9pZ/BbgAth4KcoI1FnuBtazApyqhVPWmeUOnm+I9nJn+6LtCvuLR4VR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210487; c=relaxed/simple;
	bh=6xd9/f2kJ5d421KmeX+Fa5bSqUFOiTjP7YAqfI5k/IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gx0kxfe0dVMg7hf2wZyVIqEcRew2xvE2TsKDeIpn1Z3EFa3StxhWn7zXlqqfqFmQtwQCsWQSNBO8ntcQwu/ivGzVK/PLG/BrodWzv3bYVIxrdLGdQUuo9ubW1eLOIjf3HfWHa/foqzBdy6BvPaxUX5AeHUaCALqWKSTEFontmP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdaf2YIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdaf2YIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9D6C4CEC3;
	Sun,  1 Sep 2024 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210487;
	bh=6xd9/f2kJ5d421KmeX+Fa5bSqUFOiTjP7YAqfI5k/IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdaf2YIvrzKoM59vYrQl7CwrMoFwtxvJ1kI0HQ9AayKwWRIUERBiUxM0sWVbV/hWH
	 miRxm5H6I3/itsJO2bwBlHUlxMhGKz7sWInE17u0boyif4SKJt6K1KL2DG1wNkPEUN
	 ytS/sJ4PzYCBu9FDyf2Wc+VMn7UuldBUb7oTvRh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+0122fa359a69694395d5@syzkaller.appspotmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	George Kennedy <george.kennedy@oracle.com>
Subject: [PATCH 5.15 173/215] Input: MT - limit max slots
Date: Sun,  1 Sep 2024 18:18:05 +0200
Message-ID: <20240901160829.902527733@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -45,6 +45,9 @@ int input_mt_init_slots(struct input_dev
 		return 0;
 	if (mt)
 		return mt->num_slots != num_slots ? -EINVAL : 0;
+	/* Arbitrary limit for avoiding too large memory allocation. */
+	if (num_slots > 1024)
+		return -EINVAL;
 
 	mt = kzalloc(struct_size(mt, slots, num_slots), GFP_KERNEL);
 	if (!mt)


