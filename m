Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C933B18787E;
	Tue, 10 Sep 2024 10:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962576; cv=none; b=RHHuJPr1ybNdRosEXfYsyAx41WqdyY57JImopLSnz9o1c2+ieohGnQQPBP9lEFseNiwrPnVpUzu+aIoSRDAZeyKLV0OlSGmxy2rC9/Z8yuZnhTDp3y+c15Vox0aPKSsu+Fp8VXfDtZiQ8cCpkP0pHfGvwyMjPXbijnYQcvBTfLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962576; c=relaxed/simple;
	bh=+flJCUBRh8ua8g5O+Gzc792sja8SWeGxKneJ1jVrVSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yg+IyRn1rddKQVv9gB4PtLhlnitkmYKnjTkYron0IJ53LtKJIVFgQebW+vinTuYNGVhu/goEn5UuO2jLfFqxBen5T+WCHEV7tjtLzXTjrknrlY5J8XxDy59kGF8sQsFMH3mdt+QgWgoi+CkcLCNgdo0rzm5AL6tVZs/YMAp6YUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9Rez9kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9Rez9kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F177C4CEC3;
	Tue, 10 Sep 2024 10:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962576;
	bh=+flJCUBRh8ua8g5O+Gzc792sja8SWeGxKneJ1jVrVSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9Rez9kpSYMWOuX9KDIFNPM54bto/3lAQ/s4rJJI8GI/EpRRNblrr+uBXOF0xykhu
	 B/7/Wn05OzyjovFCw5Czq03l+JPQ7CnlDUXNtTVq3DR0hNb6YN+JKSO+5HqTufulX+
	 NgkCdYAFBiBOJBjloTd8vZTf1As0AQb6oPdlQLFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Ziegler <ziegler.andreas@siemens.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/121] libbpf: Add NULL checks to bpf_object__{prev_map,next_map}
Date: Tue, 10 Sep 2024 11:32:35 +0200
Message-ID: <20240910092549.692657546@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b8849812449c..98e34c517267 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4754,7 +4754,7 @@ __bpf_map__iter(const struct bpf_map *m, const struct bpf_object *obj, int i)
 struct bpf_map *
 bpf_map__next(const struct bpf_map *prev, const struct bpf_object *obj)
 {
-	if (prev == NULL)
+	if (prev == NULL && obj != NULL)
 		return obj->maps;
 
 	return __bpf_map__iter(prev, obj, 1);
@@ -4763,7 +4763,7 @@ bpf_map__next(const struct bpf_map *prev, const struct bpf_object *obj)
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



