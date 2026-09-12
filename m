Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E809E366052;
	Sat, 12 Sep 2026 12:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216040; cv=none; b=rZ+QioKQ2hBQ+Yo1pR95ttQSHd0eKlbDmr5CK/4aDC+jjoTL4rcgazze/5HE8akmnpykEPML4qMXNZ+7VMdKrT3w9COWpOcf3aWXp8zngJpkkkfsj1Ogy5Zi5AZ2bMMZJ2XPm6tU7uqcMc7rKz9v/q/nyzV+OhQlVd0d7PRNH3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216040; c=relaxed/simple;
	bh=NqQyew/sWrY61A605DQ3opifiDflarC1BVI73F0QvGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XGFlAt3WUjUF0H4ZrARMpDdeKmJaNtRlOysoaaWOVr+j3VTIFVVAbPX7nelu3gnxSAfr+GOLyYCpysBdUwGLulSJLW47ihPXlyg7Osyhk4mmjpB2sF/7wLxjSsl3Vxyh4RfWfp8+Dch3ZZWrWPGZPtl7+EzFbPOun8RiJtPuh7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKZt6+Ii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKZt6+Ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54C61F000FF;
	Sat, 12 Sep 2026 12:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216038;
	bh=EJUoY6MiIv5LbVyTzDnsBku9faDfJaZxi8j/oLcRN14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKZt6+IikltpUjW3aKkU0mNuaCGcof8iEZABBdGAd0aQZZuz8kvsnaH06zaJsyHk8
	 lkwxbBZzsA5jJPCwDjqd8+frmHBanZOGlio0xlWuAhwpgUE4QAk9WxejkkXeYk+846
	 hExwbzvrhi7aHA9ZnonjxxBjtE088uvMJsvdFRhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0612/1376] selftests/bpf: Silence array bounds warning in global_map_resize
Date: Sat, 12 Sep 2026 08:50:38 +0200
Message-ID: <20260912065621.181357237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit dcd164ec67f89e0db5ee025ee9e91280052eb737 ]

When compiling BPF selftests with -O2, GCC reports an array bounds
violation warning in global_map_resize test:

    In function ‘global_map_resize_bss_subtest’,
        inlined from ‘test_global_map_resize’ at /bpf-next/tools/testing/selftests/bpf/prog_tests/global_map_resize.c:228:3:
    /bpf-next/tools/testing/selftests/bpf/prog_tests/global_map_resize.c:64:33: error: array subscript 1 is above array bounds of ‘int[1]’ [-Werror=array-bounds=]
       64 |                 skel->bss->array[i] = 1;
          |                 ~~~~~~~~~~~~~~~~^~~
    In file included from /bpf-next/tools/testing/selftests/bpf/prog_tests/global_map_resize.c:6:
    ./test_global_map_resize.skel.h: In function ‘test_global_map_resize’:
    ./test_global_map_resize.skel.h:44:21: note: while referencing ‘array’
       44 |                 int array[1];
          |                     ^~~~~

This is a false positive because `array` (a BPF map) has been resized
from within the BPF program. GCC doesn't know that so let us silence the
warning by accessing the array via a plain pointer.

Fixes: 08b089567573 ("libbpf: Selftests for resizing datasec maps")
Signed-off-by: Viktor Malik <vmalik@redhat.com>
Link: https://lore.kernel.org/bpf/57765bc465a27923c3c093eba222cc24d08d8c40.1784112948.git.vmalik@redhat.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/global_map_resize.c  | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/global_map_resize.c b/tools/testing/selftests/bpf/prog_tests/global_map_resize.c
index 56b5baef35c8c..602ce30f1720c 100644
--- a/tools/testing/selftests/bpf/prog_tests/global_map_resize.c
+++ b/tools/testing/selftests/bpf/prog_tests/global_map_resize.c
@@ -23,6 +23,7 @@ static void global_map_resize_bss_subtest(void)
 	struct bpf_map *map;
 	const __u32 desired_sz = sizeof(skel->bss->sum) + sysconf(_SC_PAGE_SIZE) * 2;
 	size_t array_len, actual_sz, new_sz;
+	int *array;
 
 	skel = test_global_map_resize__open();
 	if (!ASSERT_OK_PTR(skel, "test_global_map_resize__open"))
@@ -58,10 +59,13 @@ static void global_map_resize_bss_subtest(void)
 		goto teardown;
 
 	/* fill the newly resized array with ones,
-	 * skipping the first element which was previously set
+	 * skipping the first element which was previously set;
+	 * access through a plain pointer to avoid -Warray-bounds
+	 * since the array was resized beyond its declared length.
 	 */
+	array = skel->bss->array;
 	for (int i = 1; i < array_len; i++)
-		skel->bss->array[i] = 1;
+		array[i] = 1;
 
 	/* set global const values before loading */
 	skel->rodata->pid = getpid();
-- 
2.53.0



