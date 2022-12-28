Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2681863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63845C433D2;
	Wed, 28 Dec 2022 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241004;
	bh=MgDrVh8TgP1lYs6ZUZmj1KacACULdMBbFc2oSgkD32A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjxI0fJj6iry/2rSFI3EMVsI6km4lQWwzHsvCYr4utZSFLOrWopRPxepfH8jLcu/t
	 UlymqetoYBowXhEKke9U7uez8Aw4HRNtYbnPe7iyfufrvv9GHuM5nsc2ARkDtKtmKs
	 LeawajycG2esa7oRfI9zQe0JnTC5H5QYUIfx9sOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kui-Feng Lee <kuifeng@fb.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0194/1146] selftests/bpf: Add missing bpf_iter_vma_offset__destroy call
Date: Wed, 28 Dec 2022 15:28:53 +0100
Message-Id: <20221228144335.415930323@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 1d2d941bc140b34587b4c889699fb0f89d29937f ]

Adding missing bpf_iter_vma_offset__destroy call and using in-skeletin
link pointer so we don't need extra bpf_link__destroy call.

Fixes: b3e1331eb925 ("selftests/bpf: Test parameterized task BPF iterators.")
Cc: Kui-Feng Lee <kuifeng@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221006083106.117987-1-jolsa@kernel.org
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 3369c5ec3a17..ecde236047fe 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -1498,7 +1498,6 @@ static noinline int trigger_func(int arg)
 static void test_task_vma_offset_common(struct bpf_iter_attach_opts *opts, bool one_proc)
 {
 	struct bpf_iter_vma_offset *skel;
-	struct bpf_link *link;
 	char buf[16] = {};
 	int iter_fd, len;
 	int pgsz, shift;
@@ -1513,11 +1512,11 @@ static void test_task_vma_offset_common(struct bpf_iter_attach_opts *opts, bool
 		;
 	skel->bss->page_shift = shift;
 
-	link = bpf_program__attach_iter(skel->progs.get_vma_offset, opts);
-	if (!ASSERT_OK_PTR(link, "attach_iter"))
-		return;
+	skel->links.get_vma_offset = bpf_program__attach_iter(skel->progs.get_vma_offset, opts);
+	if (!ASSERT_OK_PTR(skel->links.get_vma_offset, "attach_iter"))
+		goto exit;
 
-	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.get_vma_offset));
 	if (!ASSERT_GT(iter_fd, 0, "create_iter"))
 		goto exit;
 
@@ -1535,7 +1534,7 @@ static void test_task_vma_offset_common(struct bpf_iter_attach_opts *opts, bool
 	close(iter_fd);
 
 exit:
-	bpf_link__destroy(link);
+	bpf_iter_vma_offset__destroy(skel);
 }
 
 static void test_task_vma_offset(void)
-- 
2.35.1



