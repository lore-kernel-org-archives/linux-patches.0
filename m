Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A973815E1;
	Fri,  4 Sep 2026 06:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501946; cv=none; b=RZ0CKoJeZPXx0vxYGBlYNpazXh9hLE7bkybJL/HaXB3mOKq9f9WR26B9DO/tGGJswEUK6ANujYFlxVYYWCUgSXhFZ+Jxe83In4WpCsHOQQ+rgIIK96d4/0NtePL1p6fmTIuyXd1tO6OLw0CZwYNWiP6HduVnhqrkKZDrPK9lREg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501946; c=relaxed/simple;
	bh=Nq8q9g+3ON9Z/lSdW+93H+Lcx7YVVwGYGSAO+OpevpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDdcmNMtMWO7E2BmyCcBIT+BMVvMmziK6Sgb1Bnwnq/+TDGkKMSj7CWpuoymJjaA4eG5ukfvZ7iRzP2pv2g4eh7I7muxztQf1IFEvHJo30pz4pJkFWeqz98BfGEXT5v5HDzmT2gjA/CUmqiEzIq7cvW/0syNbpMZPpKcwyTRCOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShhFJxtA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShhFJxtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689361F00A3D;
	Fri,  4 Sep 2026 06:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501944;
	bh=UOAkHFN6IEjGyKWspEdlWE+1Yo/2aUhRZr0k45MYMVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShhFJxtAoNNhAhALAu2Nxg5zZ/R36zVHhea+XQ2tAHeDI0NGAjfovIywiHf26pI7e
	 iiXVMPeX2IbRtkIUx4MIzfmRiWWbrnHNpUwXmRkyDcwKjiq4QoFOAwleBRZAKF/50f
	 KZ8yjR4+cJMDylb7spGN2WUnYzidQjeM15mQfpfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Bradley Morgan <brads@mainlining.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 034/403] tracing/user_events: Clear copied tracing state before fork duplication
Date: Fri,  4 Sep 2026 06:57:17 +0200
Message-ID: <20260904045735.589498156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 390f6bd8583d177029d9df4bea6667509e55a765 upstream.

dup_task_struct() copies user_event_mm from the parent into the child,
without grabbing a reference to it. user_event_mm_dup() should
replace it, but it leaves that copied pointer unmodified if
user_event_mm_alloc() fails.

When the child exits, user_event_mm_remove() decrements a reference
the child never owned, which ultimately frees user_event_mm, while
the parent still as a stale pointer to it. This creates a UAF, which
KASAN reports as:

    BUG: KASAN: slab-use-after-free in
    current_user_event_mm+0x51/0x1d0 Write of size 4 at addr
    ffff888005010d30 by task init/44

    Call Trace:
     <TASK>
     kasan_report+0xce/0x100
     kasan_check_range+0x10f/0x1e0
     current_user_event_mm+0x51/0x1d0
     user_events_ioctl+0x82e/0x15c0
     __x64_sys_ioctl+0x139/0x1c0
     do_syscall_64+0xce/0x450
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Allocated by task 44:
     __kasan_kmalloc+0x8f/0xa0
     __kmalloc_cache_noprof+0x180/0x3a0
     user_event_mm_alloc+0x3c/0x1f0
     current_user_event_mm+0x88/0x1d0

    Freed by task 42:
     __kasan_slab_free+0x43/0x70
     kfree+0x13a/0x390
     process_one_work+0x696/0xf90
     worker_thread+0x420/0xba0

The fix simply clears the copied pointer before any possible failure.
In case of failure, the child then has nothing to free.

Cc: stable@vger.kernel.org
Fixes: 7235759084a4 ("tracing/user_events: Use remote writes for event enablement")
Link: https://patch.msgid.link/20260827184321.2964601-2-Jeremy.Jean@oss.cyber.gouv.fr
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_user.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -868,6 +868,9 @@ void user_event_mm_dup(struct task_struc
 	struct user_event_mm *mm = user_event_mm_alloc(t);
 	struct user_event_enabler *enabler;
 
+	/* On failure, do not free parent's copy */
+	t->user_event_mm = NULL;
+
 	if (!mm)
 		return;
 


