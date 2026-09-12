Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C1D2BDC0E;
	Sat, 12 Sep 2026 11:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212419; cv=none; b=b0fcbUPDp29v8+ZnKzZVOWfyGoGTVvRuOPlws3xWIo6U1Grk48NKANIP0EaH9K2iFZVUD2pXMzjWAktkRd4h4bd47jrj+UDWmiAT/UsLdrE88H06+w8PdDm4KoBllmNULfiTY7Uzx8mMkrB48dtYUyEsTJ0BKn6e8BMyD2NfluA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212419; c=relaxed/simple;
	bh=AVr0N0aY9b5eYDynArh0uJtfLiLARhjeZ47SsNqowNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2JgTr8li38I7oL0hx1gULicHCbqnhItoVf30Yqz24axE1z7xRujSxzO4SJGCKW6Ebe3uJvBdw1lVKbcUBWkqKbsFqG5l9L+oCYhuFtnvlF+5OFFEZCHm/ZJ7+YMt6jqaBCe0MiqeqsWvXCSTW9+0O5BF0R83Ggma3qF4ovLAjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggN1RWUV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggN1RWUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BB31F000FF;
	Sat, 12 Sep 2026 11:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212416;
	bh=iSfZdMGYA6+MWr3YfcKgFvQGGEV4tDwBiBzrf/ZolAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggN1RWUVPrIwoYtuKuhzJ/ad9Q7YSl3ubLRdKsVHWPiNX8xKqPwA9mZl9unXFP8Sg
	 5mU4IEaeEiMxA42P9A5AYTXfDwddO/TRne97IP+8WoXdfttdW2P9kzFQAahCN6CKaQ
	 OeOq7xLI++Vv/vgGJSG109Gy0Y7mICX6S1hKMC/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+87c7c2d63c44e41c77a3@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1433/1518] libceph: validate banner payload length
Date: Sat, 12 Sep 2026 09:00:02 +0200
Message-ID: <20260912065655.970197045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit f374967fcdf04001c9b66df1c19106fa83cd91f7 ]

When parsing the Ceph messenger v2 protocol banner, the `payload_len` field
is decoded from the banner prefix. If a client sends a banner with a
`payload_len` of 0, the kernel sets up a 0-length socket read. This
violates an invariant in the state machine, triggering a warning in
`populate_in_iter()`:

------------[ cut here ]------------
!iov_iter_count(&con->v2.in_iter)
WARNING: net/ceph/messenger_v2.c:3129 at populate_in_iter
net/ceph/messenger_v2.c:3129 [inline], CPU#1: kworker/1:3/5070
WARNING: net/ceph/messenger_v2.c:3129 at ceph_con_v2_try_read+0x6634/0x6810
net/ceph/messenger_v2.c:3159, CPU#1: kworker/1:3/5070
...
Call Trace:
 <TASK>
 ceph_con_workfn+0x1f5/0x14a0 net/ceph/messenger.c:1575
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

According to the msgr2 protocol specification, the banner payload is
expected to contain at least two 64-bit integers (`server_feat` and
`server_req_feat`). Therefore, `payload_len` must be at least 16 bytes.

Fix this by adding a check in `process_banner_prefix()` to reject a
`payload_len` smaller than 16 bytes. This prevents the 0-length read and
correctly aborts the connection with a protocol error.

Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc and secure modes)")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+87c7c2d63c44e41c77a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=87c7c2d63c44e41c77a3
Link: https://syzkaller.appspot.com/ai_job?id=c8ca3d63-717a-4933-89ec-f3d761b8690d
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/messenger_v2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 5c7435fc6483f..4bb238eb8606e 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2144,6 +2144,11 @@ static int process_banner_prefix(struct ceph_connection *con)
 	payload_len = ceph_decode_16(&p);
 	dout("%s con %p payload_len %d\n", __func__, con, payload_len);
 
+	if (payload_len < sizeof(u64) + sizeof(u64)) {
+		con->error_msg = "protocol error, bad banner payload len";
+		return -EINVAL;
+	}
+
 	return prepare_read_banner_payload(con, payload_len);
 }
 
-- 
2.53.0



