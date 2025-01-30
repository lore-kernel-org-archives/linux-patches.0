Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013C41E7C25;
	Thu, 30 Jan 2025 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246645; cv=none; b=o8F43fWdDcd8xJFbR1bkKAxmgmBJ3PYo/4WsCXibVkP8x4HAfdev+QTGCx/rjpwIRxA+9Wh7UQigXKbPZ2ivODQfgHVXsClbu8OA/lkeynsuhRp0XJgznc6mEYhbqDaojAYtHs43+t7rK0t5p6YWdeK1qaDVVqMYPd3GDeqleY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246645; c=relaxed/simple;
	bh=UJ+aj+mXbfMQDVGaNKlNDXjJ/FZ5mN5+Ka38Fd1QYzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fp2ZW5jHFpapXnb1K9SJoe33QC6CjWH903jxMTLkCVApsdfe1XnMwJQYCK9RbQZ5S6ZJdBs1PCBi6947UJ2SNmvBd7lF9CMxqJjIp8xY0ZFetbwH0hEVKefqdR9gquOSSMf04xS2gUCaAom0zEtXd5sk7BJXoU8KvkzlD3uW++Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+BH0Fhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+BH0Fhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81483C4CED2;
	Thu, 30 Jan 2025 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246644;
	bh=UJ+aj+mXbfMQDVGaNKlNDXjJ/FZ5mN5+Ka38Fd1QYzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+BH0FhmQ4t6Frk25OMndaXRYfi2zvznkpPV8kBb17kjWzxjgH+zXQCV23OZfEunz
	 tMJPY5SpKyP2Cpg/cRoB/rsDsmWrzu22uK/v1YX3o2v7PbPPONlXsLxCyDxBnULQdt
	 nUF15FZ8pq++R3OudcNaGSdXYEksliuAotBjwZOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krister Johansen <kjlx@templeofstupid.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.4 11/91] dm thin: make get_first_thin use rcu-safe list first function
Date: Thu, 30 Jan 2025 15:00:30 +0100
Message-ID: <20250130140134.120699220@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Krister Johansen <kjlx@templeofstupid.com>

commit 80f130bfad1dab93b95683fc39b87235682b8f72 upstream.

The documentation in rculist.h explains the absence of list_empty_rcu()
and cautions programmers against relying on a list_empty() ->
list_first() sequence in RCU safe code.  This is because each of these
functions performs its own READ_ONCE() of the list head.  This can lead
to a situation where the list_empty() sees a valid list entry, but the
subsequent list_first() sees a different view of list head state after a
modification.

In the case of dm-thin, this author had a production box crash from a GP
fault in the process_deferred_bios path.  This function saw a valid list
head in get_first_thin() but when it subsequently dereferenced that and
turned it into a thin_c, it got the inside of the struct pool, since the
list was now empty and referring to itself.  The kernel on which this
occurred printed both a warning about a refcount_t being saturated, and
a UBSAN error for an out-of-bounds cpuid access in the queued spinlock,
prior to the fault itself.  When the resulting kdump was examined, it
was possible to see another thread patiently waiting in thin_dtr's
synchronize_rcu.

The thin_dtr call managed to pull the thin_c out of the active thins
list (and have it be the last entry in the active_thins list) at just
the wrong moment which lead to this crash.

Fortunately, the fix here is straight forward.  Switch get_first_thin()
function to use list_first_or_null_rcu() which performs just a single
READ_ONCE() and returns NULL if the list is already empty.

This was run against the devicemapper test suite's thin-provisioning
suites for delete and suspend and no regressions were observed.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Fixes: b10ebd34ccca ("dm thin: fix rcu_read_lock being held in code that can sleep")
Cc: stable@vger.kernel.org
Acked-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2325,10 +2325,9 @@ static struct thin_c *get_first_thin(str
 	struct thin_c *tc = NULL;
 
 	rcu_read_lock();
-	if (!list_empty(&pool->active_thins)) {
-		tc = list_entry_rcu(pool->active_thins.next, struct thin_c, list);
+	tc = list_first_or_null_rcu(&pool->active_thins, struct thin_c, list);
+	if (tc)
 		thin_get(tc);
-	}
 	rcu_read_unlock();
 
 	return tc;


