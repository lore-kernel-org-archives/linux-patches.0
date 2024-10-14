Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EDD1AB505;
	Mon, 14 Oct 2024 14:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915845; cv=none; b=L8FniCS1YKGpd1Fan/O2s/g2kYotRF3NMnE7IfoPUlGzD3r+n46ydanA7DM2wdTANaPFgYn++7wmr511qRmkpz/gKdxRg/DjQk4qPDEraC5rdtPj4crjcv7pIGEIOBZoZAMmCDNoMmGKgLlHsyukjBNHGb0lZM3ADAGNoG9XFnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915845; c=relaxed/simple;
	bh=d97/4jlYhprWleUWysNJF25d1E5FY+vpECQpab+r4kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHs+wEv7aVD+g/gPvOFN6ln7LtL+tPibQKtpwk1JMPEjlBJL88M4VHSgkc2dFHgB8ZmLbHyUdz1QgFafJXebpmOKB3K1VD57tjaBFqHrlmS9MZSZL0R56SV3xNOHK+3Fj1lx88J9FJpdhBaG5OVcEuROdHlmkAcsXTv96KUJmWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=un1oLzRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="un1oLzRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFAAC4CEC3;
	Mon, 14 Oct 2024 14:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915845;
	bh=d97/4jlYhprWleUWysNJF25d1E5FY+vpECQpab+r4kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=un1oLzRkUjhl0sc0A53otdcG7qeZAHaYErqyl62UXvvuSUQoiR3IPxECXygiQhBk/
	 mVmlGgddxAqhxhNeg79nskg2RGYiTNLCfPvMLIeFMW2DhG3qFLwcxZYAF9zVwfX66E
	 5flXawioX2wpX69Zfx/559L8AKY71TsBv8BBYkZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 016/214] bpf: Call the missed btf_record_free() when map creation fails
Date: Mon, 14 Oct 2024 16:17:59 +0200
Message-ID: <20241014141045.627217046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 87e9675a0dfd0bf4a36550e4a0e673038ec67aee ]

When security_bpf_map_create() in map_create() fails, map_create() will
call btf_put() and ->map_free() callback to free the map. It doesn't
free the btf_record of map value, so add the missed btf_record_free()
when map creation fails.

However btf_record_free() needs to be called after ->map_free() just
like bpf_map_free_deferred() did, because ->map_free() may use the
btf_record to free the special fields in preallocated map value. So
factor out bpf_map_free() helper to free the map, btf_record, and btf
orderly and use the helper in both map_create() and
bpf_map_free_deferred().

Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20240912012845.3458483-2-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d9cae8e259699..21fb9c4d498fb 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -733,15 +733,11 @@ void bpf_obj_free_fields(const struct btf_record *rec, void *obj)
 	}
 }
 
-/* called from workqueue */
-static void bpf_map_free_deferred(struct work_struct *work)
+static void bpf_map_free(struct bpf_map *map)
 {
-	struct bpf_map *map = container_of(work, struct bpf_map, work);
 	struct btf_record *rec = map->record;
 	struct btf *btf = map->btf;
 
-	security_bpf_map_free(map);
-	bpf_map_release_memcg(map);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
 	/* Delay freeing of btf_record for maps, as map_free
@@ -760,6 +756,16 @@ static void bpf_map_free_deferred(struct work_struct *work)
 	btf_put(btf);
 }
 
+/* called from workqueue */
+static void bpf_map_free_deferred(struct work_struct *work)
+{
+	struct bpf_map *map = container_of(work, struct bpf_map, work);
+
+	security_bpf_map_free(map);
+	bpf_map_release_memcg(map);
+	bpf_map_free(map);
+}
+
 static void bpf_map_put_uref(struct bpf_map *map)
 {
 	if (atomic64_dec_and_test(&map->usercnt)) {
@@ -1411,8 +1417,7 @@ static int map_create(union bpf_attr *attr)
 free_map_sec:
 	security_bpf_map_free(map);
 free_map:
-	btf_put(map->btf);
-	map->ops->map_free(map);
+	bpf_map_free(map);
 put_token:
 	bpf_token_put(token);
 	return err;
-- 
2.43.0



