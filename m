Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8E8364AB;
	Sun,  1 Sep 2024 16:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207761; cv=none; b=bako17QRaxVSJND6GcMUi/oWwdxZ2SvOpPCAXh99mQX1DFpDGofciNgXGBCyF1BwskT2i9syg/0FtJZGFgX+iKvvtNhMI4F8dA2HVjZ08XxHuJkEbD0R8AG1DGMl6TqaCY18u3mUaFIIYEdd9bCUPhl2XUQR6DOCLIxkh5s2aDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207761; c=relaxed/simple;
	bh=vnk6qnZ8hz9iFsJiAc2HktbOSMc4UPSYt9+J9JuIphY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxiBbQut1LQSxy+7aplKpBB3lsVW+7hJjwDKHbCzey+qhUr2jGrF84Y9NbTKpjt1EQs5YHii7ntKH5LH0RG+vvEenrd5F8s5W+5UawNjeNaNTnD8U7WLOTE4JegDh7LZIpWxgr/a+dCe6Ri+kTvrsiX7apsJz9+Y69ynvBR4QhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBFaypGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBFaypGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B57CC4CEC3;
	Sun,  1 Sep 2024 16:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207761;
	bh=vnk6qnZ8hz9iFsJiAc2HktbOSMc4UPSYt9+J9JuIphY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBFaypGoJg3tnx+7L9G4IL1xp5T9KajqNVRlPAoBoaXW/8f6Qqvi3mwDv7Tt8IRN2
	 vUstJborNK7Vb2FSthZXzHEGnEI9ccVaGq5zB7Bnshq3NCkWt3wfc0i0Zy+ryxSD3n
	 v4u5kFo6LtUOxyu6VPLL2E5+zbOM/4JRDuS7n7Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+0122fa359a69694395d5@syzkaller.appspotmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	George Kennedy <george.kennedy@oracle.com>
Subject: [PATCH 4.19 70/98] Input: MT - limit max slots
Date: Sun,  1 Sep 2024 18:16:40 +0200
Message-ID: <20240901160806.337361697@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -48,6 +48,9 @@ int input_mt_init_slots(struct input_dev
 		return 0;
 	if (mt)
 		return mt->num_slots != num_slots ? -EINVAL : 0;
+	/* Arbitrary limit for avoiding too large memory allocation. */
+	if (num_slots > 1024)
+		return -EINVAL;
 
 	mt = kzalloc(struct_size(mt, slots, num_slots), GFP_KERNEL);
 	if (!mt)


