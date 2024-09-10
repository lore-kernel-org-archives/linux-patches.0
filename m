Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A360172BAE;
	Tue, 10 Sep 2024 09:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962017; cv=none; b=EY/Lim/fH20GUIAufnc3PrPiUwem8Zi87ecRaPVN7BNtwPPyfcSBOdeEwW21aY1+AE12Q+QCpV4jmvcF6+TP27HLkQU4YEBEF1oFG/x+IWPkoLwsxkjRyuqt0NQiLr6jg9be2YO7qOk0/ef3LDLdBsKphva8+ra4fYZauAJUBEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962017; c=relaxed/simple;
	bh=KaUw+dl28h+2ev9CicteCRu/ORwDixr2eFYJeevWVtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pw5zpW7ypELpJM/pSsyM1ktjfgFhNoiQO8GbKkxTxtysPpwok8AFgy5Vfhfm/+cm9v8k5jcMcAPopk8JN8pZIvDiD+Rv1igVncL9a3WT+vW1QpAMPzfFTl7TMSYY1qb2bm1VSmFuGqftGAcdbyyw5qxuR+TGgYEzwaU3e0TN1xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1hOIQFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1hOIQFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953A8C4CEC6;
	Tue, 10 Sep 2024 09:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962017;
	bh=KaUw+dl28h+2ev9CicteCRu/ORwDixr2eFYJeevWVtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1hOIQFn/aPXrc1Q1f6GvB2j+5vGS6u8JT9So+L0frpRWLcCOklUbCJG/f6FYIbxZ
	 5pNHMXoN/U7IYPJ4lj3zEjFLIHLcKjjOvbLY2xWx5bXrpAU/J4VKOkPVz/+MOxO3rP
	 uANvhIu1RMqbFQf3bUUDvcNtN3u0bZmVBMCfVJi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot <syzbot+0122fa359a69694395d5@syzkaller.appspotmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 267/375] Input: uinput - reject requests with unreasonable number of slots
Date: Tue, 10 Sep 2024 11:31:04 +0200
Message-ID: <20240910092631.522501510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
index d98212d55108..2c973f15cab7 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -417,6 +417,20 @@ static int uinput_validate_absinfo(struct input_dev *dev, unsigned int code,
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



