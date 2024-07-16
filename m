Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5891DDCE;
	Tue, 16 Jul 2024 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146075; cv=none; b=hUWfk8QdFqfRvP0B+FzAPRC7RVzqsxh/kiismjF3NMUOx4OJ9j5TQVLc/h3rXTcFUh7kXYKq7+cBdRUYCskFHD0NkicC6GmuYzN5zQtiEesaGMKKyJJRFk8VOfiOASCIYEEcNmlTXmUJda92ejlUSXDxUliK8aaCn+g9YTO5G9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146075; c=relaxed/simple;
	bh=AG+Dwe11F2VXLpTqqAlDxBU/IEE0fE4SKmnk2iV7eUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/cvEgEOT679NB28AFmtrsWW7a1Gv8SQT2h8Ky2Q06GG9i1WvTlcsWmvbTIZXp2E8waeJK65bGz74Dfd0fV4Pc2v61h7hzccn0EMlgekEk4jzX5nWnArVNPNtiy6NOJAXdt58b1MQt8DkAFYBTcf4M9G62IAelnmdvms82A0OTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJLWARtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJLWARtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A79CC116B1;
	Tue, 16 Jul 2024 16:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146075;
	bh=AG+Dwe11F2VXLpTqqAlDxBU/IEE0fE4SKmnk2iV7eUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJLWARtHj0ho+Dqg2F903zjISEXfg/b8pvi82/mO9rSu020sMZ9D4py9yzsVjUYRl
	 GwwVEpVmtiFCpaERqqRES5McRSycrmcjAozlTErluRpCicLNQXH3gWpY4iQI+hPEzB
	 XjGXU8SNdNgIJuSjVCW29COdFwez9NRbbGBV+O2I=
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
Subject: [PATCH 5.15 049/144] mm: optimize the redundant loop of mm_update_owner_next()
Date: Tue, 16 Jul 2024 17:31:58 +0200
Message-ID: <20240716152754.431079037@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -432,6 +432,8 @@ retry:
 	 * Search through everything else, we should not get here often.
 	 */
 	for_each_process(g) {
+		if (atomic_read(&mm->mm_users) <= 1)
+			break;
 		if (g->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(g, c) {


