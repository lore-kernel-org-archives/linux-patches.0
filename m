Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2569133471D;
	Mon, 18 Aug 2025 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523570; cv=none; b=iwVjRXY8GpVN0uF+GdcSLvEoX6Ej+1dUeqjXqg1AsdGWts/DcrO8JwyAVNTdjJjSmf/DvYSLc2bZSJFJZAy90sfUxgtqsAEorzghDoFvEzvOdMJy0lV2BJ6TdOyNMWMlAGg4z57u4YVbnGRXIpvpIgF91HvovsgW919eTLUflyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523570; c=relaxed/simple;
	bh=oK3qaaIITRlezXC9yLcWJxcRYKTqlWmHhldk8MOFFp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B3+0wBQZSU6fI21ADi6dNVcYv360VD+7DBmKvI4KnloASr3Wj1/zBgnJf1gFWv908GgVM46btI14HlYLctkMJWarnMd/5SoDy7Bxlbr5a+8u1KZ5NaSKIAKyT/l12NEc/cxV/3AvMAHI0PCRs/lDfkzWQ9OPkGyYg5WA53Jp+oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnV15D9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnV15D9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89528C4CEEB;
	Mon, 18 Aug 2025 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523570;
	bh=oK3qaaIITRlezXC9yLcWJxcRYKTqlWmHhldk8MOFFp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnV15D9ewEEd611vCrbzMFGrimdBte3t1CVrmSHZVYNH4qjU7qTYTFC4xd0Nxwj7N
	 V/z1RSFFuEGVBJ6mk6J0m0F2DkBv8fWEv8ii3jlh92ODD3VgiWP3ECF9tcx4WBXHK6
	 MxPOa3VgS8k7lceZOz8pFZxNVqDbN5inLNT8FkBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Croce <teknoraver@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 211/515] libbpf: Fix warning in calloc() usage
Date: Mon, 18 Aug 2025 14:43:17 +0200
Message-ID: <20250818124506.496004197@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matteo Croce <teknoraver@meta.com>

[ Upstream commit 0ee30d937c147fc14c4b49535181d437cd2fde7a ]

When compiling libbpf with some compilers, this warning is triggered:

libbpf.c: In function ‘bpf_object__gen_loader’:
libbpf.c:9209:28: error: ‘calloc’ sizes specified with ‘sizeof’ in the earlier argument and not in the later argument [-Werror=calloc-transposed-args]
 9209 |         gen = calloc(sizeof(*gen), 1);
      |                            ^
libbpf.c:9209:28: note: earlier argument should specify number of elements, later size of each element

Fix this by inverting the calloc() arguments.

Signed-off-by: Matteo Croce <teknoraver@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20250717200337.49168-1-technoboy85@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7e532fbfd684..faa4ca04986c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9221,7 +9221,7 @@ int bpf_object__gen_loader(struct bpf_object *obj, struct gen_loader_opts *opts)
 		return libbpf_err(-EFAULT);
 	if (!OPTS_VALID(opts, gen_loader_opts))
 		return libbpf_err(-EINVAL);
-	gen = calloc(sizeof(*gen), 1);
+	gen = calloc(1, sizeof(*gen));
 	if (!gen)
 		return libbpf_err(-ENOMEM);
 	gen->opts = opts;
-- 
2.39.5



