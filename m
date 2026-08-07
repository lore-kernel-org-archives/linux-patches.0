Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7254B0480;
	Fri,  7 Aug 2026 15:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115469; cv=none; b=c4tHwO1VDrxeQFqs/giXvoe+z9o3dAU2wIVzRBNbapKM9vrTTsMpcsGdiAGMBcxBfXYdQXVQYJihOtXdKX6ECouM816yTb6CnsJ67nNsRy6+jOUo092W8GaVwKEBXFQ5zcxYPosDVImBA0SGAJbhgmYseMdq2Yd2ukYXDHCS2yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115469; c=relaxed/simple;
	bh=P/r9e6pBpJ6kLbeGjWo28J5oQ6hRUbb5AQsbVg2TnvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+9KyhYpFqMWR9nKXslBvhKGzQVdzw4cxLoSIPyyafJp/qb61j2mx2uGTeWh0bpU871gqw4Dpw9Qku00LRC2w08ni6oy0Tr417Aw5Qyymw6TDsP35NEDUWM1Aa6caogN7p9HxDU4BMspBVoF/tS+krEQ38UUMWZzJGPM/4qylxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UG50pWYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UG50pWYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608C81F00A3D;
	Fri,  7 Aug 2026 15:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115467;
	bh=sqCfuxg3rZ0X+j3R+q0LPU6f6LQ+0ymyTFYyK3fjRv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UG50pWYnKJiWZ/tuzYur3+gmdv/P7tzF/MRaraOI3YITW5KtMFFuFgcd/Rdltv0qA
	 bd22aNdVrtLHwbmpsEzGeBdiTVlDdVD/ohnoXl/tqR7a6OKLX9B1KXzlL5pFF6wAJr
	 GXV7RbcLGfpywyKrVw+7EGHN8zbJHvRUpkfSk9LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.18 243/396] uprobes: Fix NULL pointer dereference in hprobe_expire()
Date: Fri,  7 Aug 2026 16:36:43 +0200
Message-ID: <20260807143429.494068598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit cc679d7a6303e84d769f2afcde1fc51c51f127cd upstream.

Forking a task that has a pending uretprobe can oops the kernel with a
NULL pointer dereference in the clone() path:

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  Oops: 0002 [#1] SMP NOPTI
  RIP: 0010:hprobe_expire
  CR2: 0000000000000018
  Call Trace:
   uprobe_copy_process
   copy_process
   kernel_clone
   __x64_sys_clone
   do_syscall_64
   entry_SYSCALL_64_after_hwframe

This was found on real hosts on Meta fleet.

I've got the impression that this is what is happening:

  CPU 1                          CPU 2 (traced task)
  -----                          -------------------
                                 hit uprobe, prepare_uretprobe():
                                   hprobe LEASED, refcount >= 1
  uprobe_unregister()
    put_uprobe(): refcount -> 0
                                 fork() -> dup_utask()
                                   hprobe_expire(hprobe, true)
                                     try_get_uprobe() -> NULL
                                     get_uprobe(NULL)   <-- Oops

Only take the extra reference when the uprobe is non-NULL; a NULL means
it is gone and is the correct value to return.

Fixes: dd1a7567784e ("uprobes: SRCU-protect uretprobe lifetime (with timeout)")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260729-uprobe-v1-1-61896b87c867@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -830,7 +830,7 @@ static struct uprobe *hprobe_expire(stru
 		if (try_cmpxchg(&hprobe->state, &hstate, uprobe ? HPROBE_STABLE : HPROBE_GONE)) {
 			/* We won the race, we are the ones to unlock SRCU */
 			__srcu_read_unlock(&uretprobes_srcu, hprobe->srcu_idx);
-			return get ? get_uprobe(uprobe) : uprobe;
+			return get && uprobe ? get_uprobe(uprobe) : uprobe;
 		}
 
 		/*


