Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB01448ED;
	Tue, 16 Jul 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144322; cv=none; b=D9QZrD0+ZXLbNZbMGisObO2PZuIyatPRGVqxkRfilTHtTGrSU035OMKZjc1m8pqZQMIeeeEZCALVuv+12MNugRtCIYqHJEsUpGPsjNznp/mLavXwgAK/dVPjbU4WmeO3sn2T5FZjGD7ArbyV1APxLAYkTUx5ikHvOfpkJByboao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144322; c=relaxed/simple;
	bh=q4hwBc6nUg97PKlhHKCb8OBfwQJFrZKevTFYaWxYvbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDsNai2T44vaWkUumpWuGOdGhTazuNpCzQYGs/A+cLvONLDEJW+tnuXOP+bsC17D1pPTKaXlhXP4SBM/qp7opW1vKQ5xlbjzuCqnqmWAXxSKcJ83FoRjgpzwX4N8HSWCrEV94kb+BKwwQUINmhNT6b+mA7xT4TXtVZX4MgN3Gg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRqJ6hiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRqJ6hiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0BDC4AF0E;
	Tue, 16 Jul 2024 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144322;
	bh=q4hwBc6nUg97PKlhHKCb8OBfwQJFrZKevTFYaWxYvbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRqJ6hiRd6Bdtl35Z1YzR4v1yusvfcA98DuXKllXiS9QnGsQZ/ijPJz4YvnQFpuSt
	 JKcuS2/2T1pQ1rTRGehuswpdKpu13EUxMQ8Q6ipDxui4Ws7xW52EAmcYnQ+GhUEZJL
	 f0OV3i7yIE/Iy6iS2cdJoDQ24RRrEY2k1+WkxMt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Michal Hocko <mhocko@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Mateusz Guzik <mjguzik@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Tycho Andersen <tandersen@netflix.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 34/78] mm: optimize the redundant loop of mm_update_owner_next()
Date: Tue, 16 Jul 2024 17:31:06 +0200
Message-ID: <20240716152741.957232577@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinliang Zheng <alexjlzheng@tencent.com>

commit cf3f9a593dab87a032d2b6a6fb205e7f3de4f0a1 upstream.

When mm_update_owner_next() is racing with swapoff (try_to_unuse()) or
/proc or ptrace or page migration (get_task_mm()), it is impossible to
find an appropriate task_struct in the loop whose mm_struct is the same as
the target mm_struct.

If the above race condition is combined with the stress-ng-zombie and
stress-ng-dup tests, such a long loop can easily cause a Hard Lockup in
write_lock_irq() for tasklist_lock.

Recognize this situation in advance and exit early.

Link: https://lkml.kernel.org/r/20240620122123.3877432-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tycho Andersen <tandersen@netflix.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/exit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -433,6 +433,8 @@ retry:
 	 * Search through everything else, we should not get here often.
 	 */
 	for_each_process(g) {
+		if (atomic_read(&mm->mm_users) <= 1)
+			break;
 		if (g->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(g, c) {


