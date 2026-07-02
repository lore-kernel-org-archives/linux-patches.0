Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B50318EC5;
	Thu,  2 Jul 2026 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010882; cv=none; b=D6TNy9Ph+T/W9UYD8YjivasKZ7LIzWXnCc/ZCExcSSuIBO7BL/ElthHyDeNXRHG3HbKAo6YprsDB11tMOZmv16rV6tsXe56II1cQw+KzsF8ppGOJoSS8mKZ0ZBLnAml/+eBRxOVdRmXKHwghqYEXNGLXS7GxvzoThBU1Qh98HTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010882; c=relaxed/simple;
	bh=aBhc1qHb1dUqcmrm0vS82wD3IQU6HbKWYyRsxkJq41A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmQtGJEnoDP1HGOc0h7KccNIobPDPT3t6Tvfe7KVW1nVJQyJVybHLXXOIaHP2IgY7KewJVsVLVvYzKmhi/2Sq9NAF9urkbWnFkS9l9eMgozG8DtU9i8Oixd4ceoS2p93GdEKSYbPOBiyE7XjbhpS55lTi7Q2HDliEYkKDQO2Q5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ouj/vn/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ouj/vn/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085941F000E9;
	Thu,  2 Jul 2026 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010881;
	bh=tuw6b5EwzOI3nlrSrVlqvIQWdPJNnwx61B5g4690eO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ouj/vn/tQIN3urXyVeM/HgYvnQGSOmAsyP+9M4aIHwcDwH/QC8Z5R/X1EDRdTB1WS
	 G4lOy4MO2grLTgkP+HzqOjV9rzRwPjmPM1cDB3IruA58hJNy2FGHJRTA84hmZ/CzAc
	 hXGnxT1pw3LF0fhy5IxOyFWvy5/QcdKvXzIMYqzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+814c351d094f4f1a1b86@syzkaller.appspotmail.com,
	Ruslan Valiyev <linuxoid@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 073/175] media: vidtv: fix NULL pointer dereference in vidtv_mux_push_si
Date: Thu,  2 Jul 2026 18:19:34 +0200
Message-ID: <20260702155117.329729723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruslan Valiyev <linuxoid@gmail.com>

commit 7d8bf3d8f91073f4db347ed3aa6302b56107499c upstream.

syzbot reported a general protection fault in
vidtv_psi_ts_psi_write_into [1].

vidtv_mux_get_pid_ctx() can return NULL, but vidtv_mux_push_si() does
not check for this before dereferencing the returned pointer to access
the continuity counter. This leads to a general protection fault when
accessing a near-NULL address.

The root cause is that vidtv_mux_pid_ctx_init() does not check the
return value of vidtv_mux_create_pid_ctx_once() for PMT section PIDs.
If the allocation fails, the PID context is never created, but init
returns success. The subsequent vidtv_mux_push_si() call then gets
NULL from vidtv_mux_get_pid_ctx() and crashes.

Fix both the root cause (add error check in vidtv_mux_pid_ctx_init
for PMT PIDs) and add defensive NULL checks in vidtv_mux_push_si for
all vidtv_mux_get_pid_ctx() calls.

[1]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
Workqueue: events vidtv_mux_tick
RIP: 0010:vidtv_psi_ts_psi_write_into+0x54a/0xbc0 drivers/media/test-drivers/vidtv/vidtv_psi.c:197
Call Trace:
 <TASK>
 vidtv_psi_table_header_write_into drivers/media/test-drivers/vidtv/vidtv_psi.c:799 [inline]
 vidtv_psi_pmt_write_into+0x3b2/0xa70 drivers/media/test-drivers/vidtv/vidtv_psi.c:1231
 vidtv_mux_push_si+0x932/0xe80 drivers/media/test-drivers/vidtv/vidtv_mux.c:196
 vidtv_mux_tick+0xe9b/0x1480 drivers/media/test-drivers/vidtv/vidtv_mux.c:408

Fixes: f90cf6079bf67 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+814c351d094f4f1a1b86@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=814c351d094f4f1a1b86
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_mux.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/media/test-drivers/vidtv/vidtv_mux.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_mux.c
@@ -101,7 +101,8 @@ static int vidtv_mux_pid_ctx_init(struct
 	/* add a ctx for all PMT sections */
 	while (p) {
 		pid = vidtv_psi_get_pat_program_pid(p);
-		vidtv_mux_create_pid_ctx_once(m, pid);
+		if (!vidtv_mux_create_pid_ctx_once(m, pid))
+			goto free;
 		p = p->next;
 	}
 
@@ -170,6 +171,9 @@ static u32 vidtv_mux_push_si(struct vidt
 	nit_ctx = vidtv_mux_get_pid_ctx(m, VIDTV_NIT_PID);
 	eit_ctx = vidtv_mux_get_pid_ctx(m, VIDTV_EIT_PID);
 
+	if (!pat_ctx || !sdt_ctx || !nit_ctx || !eit_ctx)
+		return 0;
+
 	pat_args.offset             = m->mux_buf_offset;
 	pat_args.continuity_counter = &pat_ctx->cc;
 
@@ -186,6 +190,8 @@ static u32 vidtv_mux_push_si(struct vidt
 		}
 
 		pmt_ctx = vidtv_mux_get_pid_ctx(m, pmt_pid);
+		if (!pmt_ctx)
+			continue;
 
 		pmt_args.offset             = m->mux_buf_offset;
 		pmt_args.pmt                = m->si.pmt_secs[i];


