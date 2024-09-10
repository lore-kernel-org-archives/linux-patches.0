Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04261917DE;
	Tue, 10 Sep 2024 10:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964361; cv=none; b=u9E5wWvBdXMhT58inw7MN66y8EguUALQ/xKNwmwUlhUB9akeJj3am10B9MDSscQiSA0RL41Tp5X85SWnExqT4tTGe/SsbCEWkpcxVLMXFd71Ad48BicAuoaHboZI7DfbTXgWSigYtgTs3QE3d/sthcdrZ7Dtv4Pi8PMDgUuNOxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964361; c=relaxed/simple;
	bh=sKNp6vBe1BaTXGUF7K9lYNdl23rYIsSHrmAm4Q5R65E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlE+XH0QgzxW2/Lrw7ipoEEPVuF0YNFIXS7laz4+2vI+SPoiViK92/2UaULtKOiPgY8JHj6T9EIrZWUTPYp39Dy5JjXRvabe7VeIGcsWGGnx/DosA80Fuj5qxwGPEOUphyqs7otfZkp0epsZ1ZKmo+FOwVvGCUredGJqSO78BPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vXwyn9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vXwyn9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA9DC4CEC6;
	Tue, 10 Sep 2024 10:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964361;
	bh=sKNp6vBe1BaTXGUF7K9lYNdl23rYIsSHrmAm4Q5R65E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vXwyn9c+403yKByTbpzSb47ahISkOctkboo1iAZOnSbrxrPK94iUINC+pUly5/sy
	 Zyah2ZSh6ZDaH/BN6ZPWTjb7gsVPWm1wDuo0ckaPiRPd8ZtObrqg/atxzgx38hBqFx
	 uvSAqi2EFHSY7gulH+y3woTEShgQdSbWzlTfZbf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Ziegler <ziegler.andreas@siemens.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/269] libbpf: Add NULL checks to bpf_object__{prev_map,next_map}
Date: Tue, 10 Sep 2024 11:32:24 +0200
Message-ID: <20240910092613.790516648@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index de35b9a21dad..ceed16a10285 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9753,7 +9753,7 @@ __bpf_map__iter(const struct bpf_map *m, const struct bpf_object *obj, int i)
 struct bpf_map *
 bpf_object__next_map(const struct bpf_object *obj, const struct bpf_map *prev)
 {
-	if (prev == NULL)
+	if (prev == NULL && obj != NULL)
 		return obj->maps;
 
 	return __bpf_map__iter(prev, obj, 1);
@@ -9762,7 +9762,7 @@ bpf_object__next_map(const struct bpf_object *obj, const struct bpf_map *prev)
 struct bpf_map *
 bpf_object__prev_map(const struct bpf_object *obj, const struct bpf_map *next)
 {
-	if (next == NULL) {
+	if (next == NULL && obj != NULL) {
 		if (!obj->nr_maps)
 			return NULL;
 		return obj->maps + obj->nr_maps - 1;
-- 
2.43.0



