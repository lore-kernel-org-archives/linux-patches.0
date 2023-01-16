Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D99C46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F347C433EF;
	Mon, 16 Jan 2023 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886572;
	bh=L5ZrilAx5jf6RcAS90Y8P9B0ybULVQKJV3TNiqw/meM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5Asd0oQe+M5DJUH3uv+F4/vVBow8lkmTKG8oJMsprc6FbwEMgo7/i5wHgL3tpZJc
	 UPv7VDGzupJICDIC5B11ReiNifE1kaDIxIOPAxiI8Ated9RfNyWq+2Jjh6Jo2AQADV
	 QbYqFtsCoune0Zm6srDfc+QYuC/4d5f5JeegFFLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fce48a3dd3368645bd6c@syzkaller.appspotmail.com,
	Lin Ma <linma@zju.edu.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 452/658] media: dvbdev: fix refcnt bug
Date: Mon, 16 Jan 2023 16:49:00 +0100
Message-Id: <20230116154930.164685780@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

commit 3a664569b71b0a52be5ffb9fb87cc4f83d29bd71 upstream.

Previous commit initialize the dvbdev->ref before the template copy,
which will overwrite the reference and cause refcnt bug.

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc6-next-20221128-syzkaller #0
...
RIP: 0010:refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
RSP: 0000:ffffc900000678d0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88813ff58000 RSI: ffffffff81660e7c RDI: fffff5200000cf0c
RBP: ffff888022a45010 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000c48e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:199 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 kref_get include/linux/kref.h:45 [inline]
 dvb_device_get drivers/media/dvb-core/dvbdev.c:585 [inline]
 dvb_register_device+0xe83/0x16e0 drivers/media/dvb-core/dvbdev.c:517
...

Just place the kref_init at correct position.

Reported-by: syzbot+fce48a3dd3368645bd6c@syzkaller.appspotmail.com
Fixes: 0fc044b2b5e2 ("media: dvbdev: adopts refcnt to avoid UAF")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvbdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -490,8 +490,8 @@ int dvb_register_device(struct dvb_adapt
 		return -ENOMEM;
 	}
 
-	kref_init(&dvbdev->ref);
 	memcpy(dvbdev, template, sizeof(struct dvb_device));
+	kref_init(&dvbdev->ref);
 	dvbdev->type = type;
 	dvbdev->id = id;
 	dvbdev->adapter = adap;


