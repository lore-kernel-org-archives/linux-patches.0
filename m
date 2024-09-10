Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D371922D0;
	Tue, 10 Sep 2024 10:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963779; cv=none; b=B2rTP492TRXW51OoWXKxSf1rrpSSUWsFfFK7MFTy5ipY65YlWCZ8CQCFSZFHixUkjGJNBvIQS5YGpmJHLFUuaafmSrCIJ32AfXHh8WHdR64WHIrgaq2in9p2HDpE3VOKRoc4VNz89Amk1wCy7rDvTLABygV8NR9aT/jyGhxGRRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963779; c=relaxed/simple;
	bh=dqLUJauZ3DwgGCB4EbgDn0PF39rpon+cWLyknyWx92c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JilIEPuYYeKJ5u7SeJtEdxcuEWkD2jQ0j1guVkyCAXzTXhCaSV1Br1urrvtiy7i7koT5cy46D3yTkaUyZbisSnSrYxs6957ez+kaBitYz4G3l8fjKKTISJMeGca3RGj8a8Mm0iXqq6AP6zqEJtgJ/qwM9ttFZ57smIDzahigd6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5vez+O8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5vez+O8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5AFC4CEC3;
	Tue, 10 Sep 2024 10:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963778;
	bh=dqLUJauZ3DwgGCB4EbgDn0PF39rpon+cWLyknyWx92c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5vez+O8QBxZZ5adZ8VDZJR8kUnG4LdjzZ5qlvuVG95CRHdhe+TsVshqJqmhGS9LM
	 rO9OXJFiR0P/udWdzxnl1aayTn3uVZL/s8Pob5qC2N87Fv2+HstCJwKqSYz2Srx4Jp
	 0QBBc5dik2XibGVfgM3X6ZBwddfkDt1t2ZwJxVPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Ziegler <ziegler.andreas@siemens.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/214] libbpf: Add NULL checks to bpf_object__{prev_map,next_map}
Date: Tue, 10 Sep 2024 11:32:48 +0200
Message-ID: <20240910092604.721364311@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Andreas Ziegler <ziegler.andreas@siemens.com>

[ Upstream commit cedc12c5b57f7efa6dbebfb2b140e8675f5a2616 ]

In the current state, an erroneous call to
bpf_object__find_map_by_name(NULL, ...) leads to a segmentation
fault through the following call chain:

  bpf_object__find_map_by_name(obj = NULL, ...)
  -> bpf_object__for_each_map(pos, obj = NULL)
  -> bpf_object__next_map((obj = NULL), NULL)
  -> return (obj = NULL)->maps

While calling bpf_object__find_map_by_name with obj = NULL is
obviously incorrect, this should not lead to a segmentation
fault but rather be handled gracefully.

As __bpf_map__iter already handles this situation correctly, we
can delegate the check for the regular case there and only add
a check in case the prev or next parameter is NULL.

Signed-off-by: Andreas Ziegler <ziegler.andreas@siemens.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240703083436.505124-1-ziegler.andreas@siemens.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0c201f07d8ae..d201a7356fad 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8729,7 +8729,7 @@ __bpf_map__iter(const struct bpf_map *m, const struct bpf_object *obj, int i)
 struct bpf_map *
 bpf_map__next(const struct bpf_map *prev, const struct bpf_object *obj)
 {
-	if (prev == NULL)
+	if (prev == NULL && obj != NULL)
 		return obj->maps;
 
 	return __bpf_map__iter(prev, obj, 1);
@@ -8738,7 +8738,7 @@ bpf_map__next(const struct bpf_map *prev, const struct bpf_object *obj)
 struct bpf_map *
 bpf_map__prev(const struct bpf_map *next, const struct bpf_object *obj)
 {
-	if (next == NULL) {
+	if (next == NULL && obj != NULL) {
 		if (!obj->nr_maps)
 			return NULL;
 		return obj->maps + obj->nr_maps - 1;
-- 
2.43.0



