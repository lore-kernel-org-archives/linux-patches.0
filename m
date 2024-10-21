Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE2B1E5701;
	Mon, 21 Oct 2024 10:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506522; cv=none; b=FiTQ8tJZZzzWf1GQ6QUlIFfPMTuFcRicq0K/SMFy4CglTiAR5T+iFXE+bABMQ0g7+qy+WN0qWf52JqAgZKApTJ9CePcu4jChGxOGjMA5mJ0SSuTlr5IQdZTsXaCOE/saExubo39Jv/CImpKB1fIVnHFt7YFBd4hqVRgAIGy0XWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506522; c=relaxed/simple;
	bh=uy/zI5J3v7mxPz/X9wh3slcuOQ0ag47NZPSZQM8zHww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biMgbt+xcTeXNYZbHaVF6qC9SS7jY5isfkNCPPvdJ69qgQki5refvUZ46llmj+CHvI+Q1RcyqkjosKhAfCtlHy96B1Xpnh7tPYppVW1ISSWSHKP7ntsJEjgZqMN6WeBWy8yBuZHd5Dx1oat0OaNxZ5emjbozLCMtTxuJEOMWSA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1c6WHxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1c6WHxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B77C4CEC3;
	Mon, 21 Oct 2024 10:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506521;
	bh=uy/zI5J3v7mxPz/X9wh3slcuOQ0ag47NZPSZQM8zHww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1c6WHxBAZ/8AdX5qLUuda4XaptebefAeSn0IDOtrJvMZPvca7E2Sd1rEdYDAGSvx
	 ds8MHD9OXDgJGChFeIPfm3wMtzLKHNkJ2VVURrseCTz1pfqSO7Q5xlA7WOEGsrM3NH
	 2bltEHeM7J9YL9rphs8t6j57gkDno/kLZOqkePis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 031/135] mm/damon/tests/sysfs-kunit.h: fix memory leak in damon_sysfs_test_add_targets()
Date: Mon, 21 Oct 2024 12:23:07 +0200
Message-ID: <20241021102300.552631851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 2d6a1c835685de3b0c8e8dc871f60f4ef92ab01a upstream.

The sysfs_target->regions allocated in damon_sysfs_regions_alloc() is not
freed in damon_sysfs_test_add_targets(), which cause the following memory
leak, free it to fix it.

	unreferenced object 0xffffff80c2a8db80 (size 96):
	  comm "kunit_try_catch", pid 187, jiffies 4294894363
	  hex dump (first 32 bytes):
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	  backtrace (crc 0):
	    [<0000000001e3714d>] kmemleak_alloc+0x34/0x40
	    [<000000008e6835c1>] __kmalloc_cache_noprof+0x26c/0x2f4
	    [<000000001286d9f8>] damon_sysfs_test_add_targets+0x1cc/0x738
	    [<0000000032ef8f77>] kunit_try_run_case+0x13c/0x3ac
	    [<00000000f3edea23>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000adf936cf>] kthread+0x2e8/0x374
	    [<0000000041bb1628>] ret_from_fork+0x10/0x20

Link: https://lkml.kernel.org/r/20241010125323.3127187-1-ruanjinjie@huawei.com
Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-test.h |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-test.h
+++ b/mm/damon/sysfs-test.h
@@ -67,6 +67,7 @@ static void damon_sysfs_test_add_targets
 	damon_destroy_ctx(ctx);
 	kfree(sysfs_targets->targets_arr);
 	kfree(sysfs_targets);
+	kfree(sysfs_target->regions);
 	kfree(sysfs_target);
 }
 


