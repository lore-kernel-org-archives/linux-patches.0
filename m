Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB764BEE54;
	Sat, 12 Sep 2026 07:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199485; cv=none; b=N6zIRyanC3Rx2aYCa1Hw6Ce+s74nvsQ3JkNDBC4M0xMNjFJJC0iqB9JdzlVe9KOzs+upl9ZvCXd2BBTfKUNJfsxtzmHP9y3dHQBOJLW5okHYIXJTNMQ2BKSOVRSnnbCcQddgV05mgnnfF14VAkjxmcBj2qxB1+xiXMqfTwEsyxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199485; c=relaxed/simple;
	bh=BeZz/BKHgpg47DZkEqkfR1QFyQng3/4oJRfCGQQ7wPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bDF0o3AbUNeroHmP/I+P1GWFAAYYk1tyNxlrwKCZ1knXcEPjtePPnyFPa1m+jlNG67eQbGTRWJqSqlgtYngCAi8WfKO1G3DNPe8DwiRl/5jd8UCBr2PBqLSTXfpoXMl2xuJP1qLDZUvC6jX4dRgxAWB1zE68WqIc9XXKvavneKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHKxHYi8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHKxHYi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08611F000FF;
	Sat, 12 Sep 2026 07:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199483;
	bh=tD9whrun+PkBj4mblGkIYlsmLb7jjvjmuOhfEwdlNZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHKxHYi8/2/CWDJl79WvaH/YH0OLwXRHmPU0++E1RJjl7d4zLpKLbGOs6jlDx/4Qz
	 3SgDwMw2EGCOD1Xrfvt3HTK0K4/6BLWCOdceWu+yKcM6pyNHy8PV8fQVl41h4iUCo4
	 2kKNA2JdcFxCszpfGG5ZLthvIwL69l9yOt7dARcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0551/1815] selftests/bpf: Silence maybe-uninitialized compiler warning in libarena
Date: Sat, 12 Sep 2026 08:38:21 +0200
Message-ID: <20260912065701.820571916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit 5763790965eb3414148720f030b20fd5ccc438ca ]

When compiling BPF selftests with -O2, GCC reports a maybe-uninitialized
warning in libarena code:

    In file included from /bpf-next/tools/testing/selftests/bpf/prog_tests/libarena_asan.c:11:
    In function ‘libarena_asan_init’,
        inlined from ‘run_test’ at /bpf-next/tools/testing/selftests/bpf/prog_tests/libarena_asan.c:59:8,
        inlined from ‘test_libarena_asan’ at /bpf-next/tools/testing/selftests/bpf/prog_tests/libarena_asan.c:91:2:
    /bpf-next/tools/testing/selftests/bpf/libarena/include/libarena/userspace.h:126:14: error: ‘globals_pages’ may be used uninitialized [-Werror=maybe-uninitialized]
      126 |         args = (struct asan_init_args){
          |         ~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
      127 |                 .arena_all_pages = arena_all_pages,
          |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      128 |                 .arena_globals_pages = globals_pages,
          |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      129 |         };
          |         ~
    /bpf-next/tools/testing/selftests/bpf/libarena/include/libarena/userspace.h: In function ‘test_libarena_asan’:
    /bpf-next/tools/testing/selftests/bpf/libarena/include/libarena/userspace.h:118:13: note: ‘globals_pages’ was declared here
      118 |         u64 globals_pages;
          |             ^~~~~~~~~~~~~

Silence the warning by initializing globals_pages to 0.

Fixes: cfc00618b9df ("selftests/bpf: Add ASAN support for libarena selftests")
Signed-off-by: Viktor Malik <vmalik@redhat.com>
Link: https://lore.kernel.org/bpf/9f77a5c05c3c731ab2655fd66716ab9de4478b15.1784112948.git.vmalik@redhat.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/libarena/include/libarena/userspace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/libarena/include/libarena/userspace.h b/tools/testing/selftests/bpf/libarena/include/libarena/userspace.h
index fc27a4bcf5d7e..b6676dd67bc09 100644
--- a/tools/testing/selftests/bpf/libarena/include/libarena/userspace.h
+++ b/tools/testing/selftests/bpf/libarena/include/libarena/userspace.h
@@ -115,7 +115,7 @@ static inline int libarena_asan_init(int arena_asan_init_fd,
 {
 	LIBBPF_OPTS(bpf_test_run_opts, opts);
 	struct asan_init_args args;
-	u64 globals_pages;
+	u64 globals_pages = 0;
 	int ret;
 
 	ret = libarena_get_globals_pages(arena_asan_init_fd,
-- 
2.53.0



