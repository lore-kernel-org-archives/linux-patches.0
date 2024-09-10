Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF95919068E;
	Tue, 10 Sep 2024 10:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962621; cv=none; b=IDqaonNs7apU2TGjrm6jDor/7A1emr49zKRlT68kXqvQGVPhD4lrBDsjt7wRNAh24NgDd22lGrT8qc3VKNZ37zJFokbvtX4SwSt0iQpY0DREJ7dph9E7apiB6K/hW84IDqtCeLgyN8yLvmw1Mx1zXkuUn+6y8ql80OM3TUDHTyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962621; c=relaxed/simple;
	bh=pofCuU6zGKWcoypWaCQnd81QBrR9BW8Mtn3wbhGxOF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nx0aWZUn8JsEkGkln2Cf7pU40reW0+NYCJ15h4QW2u1BWR8KYTzjdevnB5OBDvPgT5ZA5YuMm9Ec2K/ZLBeJLVtL/wjK2XeuQWHha3LTsnXtJjOW2KSmuJd7nbiNLXPNNo5r9i7Crvw47TxlnP+rD9rMBb+M2lDtIqze9Im1GIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FT7mhRLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FT7mhRLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB48C4CEC6;
	Tue, 10 Sep 2024 10:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962621;
	bh=pofCuU6zGKWcoypWaCQnd81QBrR9BW8Mtn3wbhGxOF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FT7mhRLmThKtTJNflX1aZncx8JPFANMwB7A0OLzXtbAtZlQORz39IY0vDTVqP6bOl
	 pC7bx2ikl+h2isp38E3uSWDv7/N6poKVqKRUE/nIsFRZ7H/8cH7jHn5GpU33JPP4Oe
	 G5XM/jyKpXiSGxnz8SNMno4ccIHlwXMxn1PypAjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot <syzbot+0122fa359a69694395d5@syzkaller.appspotmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/121] Input: uinput - reject requests with unreasonable number of slots
Date: Tue, 10 Sep 2024 11:32:43 +0200
Message-ID: <20240910092550.046347384@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 206f533a0a7c683982af473079c4111f4a0f9f5e ]

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

When exercising uinput interface syzkaller may try setting up device
with a really large number of slots, which causes memory allocation
failure in input_mt_init_slots(). While this allocation failure is
handled properly and request is rejected, it results in syzkaller
reports. Additionally, such request may put undue burden on the
system which will try to free a lot of memory for a bogus request.

Fix it by limiting allowed number of slots to 100. This can easily
be extended if we see devices that can track more than 100 contacts.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+0122fa359a69694395d5@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=0122fa359a69694395d5
Link: https://lore.kernel.org/r/Zqgi7NYEbpRsJfa2@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/uinput.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 002654ec7040..e707da0b1fe2 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -416,6 +416,20 @@ static int uinput_validate_absinfo(struct input_dev *dev, unsigned int code,
 		return -EINVAL;
 	}
 
+	/*
+	 * Limit number of contacts to a reasonable value (100). This
+	 * ensures that we need less than 2 pages for struct input_mt
+	 * (we are not using in-kernel slot assignment so not going to
+	 * allocate memory for the "red" table), and we should have no
+	 * trouble getting this much memory.
+	 */
+	if (code == ABS_MT_SLOT && max > 99) {
+		printk(KERN_DEBUG
+		       "%s: unreasonably large number of slots requested: %d\n",
+		       UINPUT_NAME, max);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.43.0



