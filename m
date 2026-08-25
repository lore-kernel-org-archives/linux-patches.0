Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A8D468C08;
	Tue, 25 Aug 2026 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665017; cv=none; b=MOPPYTNbCpyjxom/AP1t1P26Qz0iyjYJAW3K71zU6t6lkiAAP/OeAKElBg6kRtIouklLn72l6zX0BtkicJgbUyc9QaYsbPPkn1v/PCJYtMewklvSJQupHIicekOM2FU7ZvXYwq1f4jwnJ7OqfazHvOghoF1ckybhYqwb2Dfcvtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665017; c=relaxed/simple;
	bh=th6pjdx0fcBRvzN8vfm6FKXKrauQHllJH7RHFz+xfxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8q31EPpIFaNitYPmHZdfcfD1LWxnjjnxcD4DJx/U8cxHSReytC4Pg4klBQaFbkIW13WXUJLH0W72Msb4K2vl5TJZdHw21TZZoNwcR7wx4mgP6i1l4QSpNw7r7+ZyKRyQOI/KBdx3eYdwXxqKEV5XYfZknQihTV8iRMDgcX9Yvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+dxDDrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+dxDDrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCF01F000E9;
	Tue, 25 Aug 2026 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665016;
	bh=asBwyY89SnuozOjq5isrPDQhgnG4/n5M9kw+0LHmd6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+dxDDrMW+7h/lrELVwnzB5Pnu7WGHL9+UsqVa4KYDKHPJLJCG/ILzDYL2yXzGDB+
	 yA313iiKvO4/KnaWRXznEtCJKo/a+6z1yTcMHFVRyE2B5hcRhJN2LFDd5vHtRqwABt
	 R0fWqh+hq8+YY2CgHLmcaRx51tifMwBdM9PeilWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.1 080/101] futex: Fix race on the initial mm->futex.phash.ref allocation
Date: Tue, 25 Aug 2026 15:25:58 +0200
Message-ID: <20260825132545.100879094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1842,14 +1842,18 @@ static int futex_hash_allocate(unsigned
 	}
 
 	if (!mm->futex_ref) {
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
-		mm->futex_ref = alloc_percpu(unsigned int);
-		if (!mm->futex_ref)
-			return -ENOMEM;
-		this_cpu_inc(*mm->futex_ref); /* 0 -> 1 */
+		this_cpu_inc(*ref); /* 0 -> 1 */
+		if (cmpxchg(&mm->futex_ref, NULL, ref))
+			free_percpu(ref);
 	}
 
 	fph = kvzalloc(struct_size(fph, queues, hash_slots),


