Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE4815C85
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76A3C433C1;
	Mon,  5 Dec 2022 19:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269199;
	bh=hxTjkYnk9p962QRlugseK4F40rhS7ZJoMj2Di6pg2CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReWiibgI8Jp6xZxsZbPhjS2X1tI/vmdDU/6BcNwfEMdwdDz4L2wOXedRMqQ+0jltx
	 Sn6oHczKE7K/UGoX4cBhIikO2g4vdg1Ii+ffA40rXwlBp32KDEVC82ENEDnqq/O74f
	 EUwC1JJoyqRsyZB7H/4kXar9uJ9PuCmb01LoWfyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9b69b8d10ab4a7d88056@syzkaller.appspotmail.com,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/153] 9p/fd: fix issue of list_del corruption in p9_fd_cancel()
Date: Mon,  5 Dec 2022 20:09:06 +0100
Message-Id: <20221205190809.376170061@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 11c10956515b8ec44cf4f2a7b9d8bf8b9dc05ec4 ]

Syz reported the following issue:
kernel BUG at lib/list_debug.c:53!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:__list_del_entry_valid.cold+0x5c/0x72
Call Trace:
<TASK>
p9_fd_cancel+0xb1/0x270
p9_client_rpc+0x8ea/0xba0
p9_client_create+0x9c0/0xed0
v9fs_session_init+0x1e0/0x1620
v9fs_mount+0xba/0xb80
legacy_get_tree+0x103/0x200
vfs_get_tree+0x89/0x2d0
path_mount+0x4c0/0x1ac0
__x64_sys_mount+0x33b/0x430
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
</TASK>

The process is as follows:
Thread A:                       Thread B:
p9_poll_workfn()                p9_client_create()
...                                 ...
    p9_conn_cancel()                p9_fd_cancel()
        list_del()                      ...
        ...                             list_del()  //list_del
                                                      corruption
There is no lock protection when deleting list in p9_conn_cancel(). After
deleting list in Thread A, thread B will delete the same list again. It
will cause issue of list_del corruption.

Setting req->status to REQ_STATUS_ERROR under lock prevents other
cleanup paths from trying to manipulate req_list.
The other thread can safely check req->status because it still holds a
reference to req at this point.

Link: https://lkml.kernel.org/r/20221110122606.383352-1-shaozhengchao@huawei.com
Fixes: 52f1c45dde91 ("9p: trans_fd/p9_conn_cancel: drop client lock earlier")
Reported-by: syzbot+9b69b8d10ab4a7d88056@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
[Dominique: add description of the fix in commit message]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index b691871d9a02..5d6284adbac0 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -200,9 +200,11 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 
 	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 
 	spin_unlock(&m->client->lock);
-- 
2.35.1



