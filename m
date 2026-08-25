Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9E5407CEF;
	Tue, 25 Aug 2026 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664564; cv=none; b=usoly1IQNaTIww6Jk020Qzx/s9lGOqnULTrVc7gW/N2gG9pvB+06Na4IoCQ3VRW8CiG/I8sIfzoNYuaZ+Wr7W9y5oYvpO4RncsvNey6une3usgIpj7OXIcbGUosD1QgJEH2/moKY5ECiLwiNngnQFvtRKMAJDyMW9gaUiQwo4oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664564; c=relaxed/simple;
	bh=6MOv6ON3ECcb6YBNFajzu+6zkojXNicu/JtkQlEtONA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlgUzW3tuK4Fvrw53EdrWvxG6CfwloBH2/xuBI43Ihip3A4zgVqk8ONP8jh/ff5EXIDD7NwMj7+Tm09BvkYBnvGYENspN0Tr/MkbJApVwhGVA8xtEeo91QqkyRcQ29vGzDm0VzMc2dM94i45ZMUKfX1nSmk0ikZd3Xua+Oik7C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Com/rC0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Com/rC0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8841F000E9;
	Tue, 25 Aug 2026 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664562;
	bh=mRIHyY05pOb86ybIKuWFFXi5yVhcfKpJXIgVpjkEsls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Com/rC0NMsT17BBgYF6od6f6lY1f3axB418UsfKc/mNpof0O7XMTKSNR+CYwGrfJe
	 yFXvEm5iCbjssGIje5odk6SV1PYm+KM0vR19FypWJUvlXQW5c5HHA55QVNxwWxYYvr
	 fuLg1sj7T6C2hxCrQkyhcu8MYsheieGQl/tRNr6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.2 13/82] futex: Fix race on the initial mm->futex.phash.ref allocation
Date: Tue, 25 Aug 2026 15:25:00 +0200
Message-ID: <20260825132542.045890620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit bde0238083647381d4747355c5a19115a3422b96 upstream.

futex_hash_allocate() allocates mm->futex.phash.ref without any locking.
Commit d9b05321e21e ("futex: Move futex_hash_free() back to __mmput()")
moved the allocation here and assumed that the process has just a single
thread at this point.

Commit ee9dce44362b ("futex: Drop CLONE_THREAD requirement for private
default hash alloc") widened need_futex_hash_allocate_default() to cover
any CLONE_VM clone, but left out vfork because the parent is suspended and
cannot race.

That no longer holds once vfork is nested. If a vfork child calls vfork
again and is then killed with SIGKILL, the parent is released from its
vfork wait and runs concurrently with the grandchild in the same mm.
Neither of them went through futex_hash_allocate_default().

When both call prctl(PR_FUTEX_HASH, PR_FUTEX_HASH_SET_SLOTS) at the same
time, each one sees mm->futex.phash.ref as NULL and stores its own percpu
counter. Only the last store survives. The counter stored first is no
longer reachable from the mm, so the references on it are not seen by
__futex_ref_atomic_end(). A private hash that still has references is then
considered dead and freed, and a task that still holds one of its buckets
writes into freed memory in futex_q_lock().

Store the counter once with cmpxchg() and let the loser free_percpu() its
own. The initial reference has to be taken before the store, otherwise
another task can install a private hash while the counter is still 0.

Fixes: d9b05321e21e ("futex: Move futex_hash_free() back to __mmput()")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ansrpP4ImE1MaBY9@v4bel
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/core.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1866,14 +1866,18 @@ static int futex_hash_allocate(unsigned
 	}
 
 	if (!mm->futex.phash.ref) {
+		unsigned int __percpu *ref = alloc_percpu(unsigned int);
+
+		if (!ref)
+			return -ENOMEM;
+
 		/*
-		 * This will always be allocated by the first thread and
-		 * therefore requires no locking.
+		 * Tasks sharing the mm can run this concurrently, so take the
+		 * initial reference before publishing the counter.
 		 */
-		mm->futex.phash.ref = alloc_percpu(unsigned int);
-		if (!mm->futex.phash.ref)
-			return -ENOMEM;
-		this_cpu_inc(*mm->futex.phash.ref); /* 0 -> 1 */
+		this_cpu_inc(*ref); /* 0 -> 1 */
+		if (cmpxchg(&mm->futex.phash.ref, NULL, ref))
+			free_percpu(ref);
 	}
 
 	fph = kvzalloc(struct_size(fph, queues, hash_slots),


