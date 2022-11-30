Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD3779C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115DCC433D6;
	Wed, 30 Nov 2022 18:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834045;
	bh=7dHZJmFJG/j5evOZe0xzlY320tlTbBLwd/v+rdY3Fc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTkIEpY8WApxGerxnnvMBjaonKfIQH7jQJup7Ztba2DUjQA1wCNtSRe/SWhpoKQ5W
	 7LmEUwiw5oE51SyN5Z5QMHOXKl22ITb0t3UnU1E6u3LBwZgp3VUAGm4zn/1s1LvqwO
	 4yX32gsNbIPkoNIrv6xWRaE4ap4ZPOlINpahiBmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9b69b8d10ab4a7d88056@syzkaller.appspotmail.com,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 081/289] 9p/fd: fix issue of list_del corruption in p9_fd_cancel()
Date: Wed, 30 Nov 2022 19:21:06 +0100
Message-Id: <20221130180545.980920485@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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
index 0191f22d1ec3..8487321c1fc7 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -202,9 +202,11 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 
 	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 
 	spin_unlock(&m->req_lock);
-- 
2.35.1



