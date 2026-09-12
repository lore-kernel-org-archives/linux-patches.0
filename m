Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E200D4BEE54;
	Sat, 12 Sep 2026 07:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199480; cv=none; b=F//Gs2azp0fyikniXIEH25v6mEYAILCzmfnWa0SvCk3TN0RTSlfUH2OBxjA/1Q2SEk1R1SRVsuDQcTStpfLJ5/gZIk/EojYdRqBxU/v7Bo5PB9Ec3eVmIEldV+7h92plZ49oopIhOALi2TFgbpnI0lM2A1yQrRH1JtY3ymujkl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199480; c=relaxed/simple;
	bh=wTwcWo115EU7STWrAtWd4VlVv6creTncqOaa131AGhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DWKir9AzU2BXnOG6DBG6L6XHCChY9ckSkdKfF4i4X4aczZA2Do4Sfx8YxCHQe7TyMCm4U/4rO31aM2hykp/Xyv7NNB8J6A0scdAqpaU2metvMFfTIn2wRDqBuyqosgXwJXsoRacJtZBrwb3+K3vvTu5StUOfA/wUMzMYbeXdbMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZqVY2nM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZqVY2nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D250A1F000FF;
	Sat, 12 Sep 2026 07:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199478;
	bh=YvAxx9joROqz3CfJNv8ibTACPUf/v1jQqNE7BmBBXvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZqVY2nMUN0QOjgD7J9Y9OGJpDvIWvpsmk795EqIPYdx4nokH/hc4O7BBs+UcXpLZ
	 GzeHetO1Y7ni7sc1/NdJRVx8Vd7pY12EV+wruFfAZB8SzKTu+6tDnEAasKRMpSiyXp
	 8BuHTNh2uTgfWKVHBrn5/TMIGEOphEeI3uLqDSAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0550/1815] selftests/bpf: Silence array bounds warning in global_map_resize
Date: Sat, 12 Sep 2026 08:38:20 +0200
Message-ID: <20260912065701.796193365@linuxfoundation.org>
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



