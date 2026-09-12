Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8862BCF4C;
	Sat, 12 Sep 2026 18:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238263; cv=none; b=ElShIGa0qnVEz6vwiW67oJQnOFZ+oA368UO+TcSnwvrc9u9TzpDa1dxyksxuAuaqL5+QYqxAi1pcutkDzf8HcwEdk+BB0zIU7sESP/IUIrssffDpma8z/A6E4Ju0tI/C98iUPSZepZ0UYJ70ehRmjH3MZqRbnQwKzRQeL3P8XN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238263; c=relaxed/simple;
	bh=91j4eP14YZwX7Zi9RIADcryfEdFeuVD5jmvQeLbV3Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJIPJNXuMPArBKATQHUaVp9kfaP8mdAjPEhOb46Yn5+vU3xZsKO9cs6LWLzOH+CnRVpN2898YaSKQyMXn19VQ1L7t3sPsufqQ+M+w7ogZf4Q4DMKTZQWIr1ez3KZmOX282kG+NFVr9B8F+Y3B2soXtLtAJG9GHrrXP3CqzkoxDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dls6LWzH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dls6LWzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB871F000FF;
	Sat, 12 Sep 2026 18:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238262;
	bh=ANtLvybqOTpx3WYjAChAEq9T1lPLnJK1SzGNtoPoQRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dls6LWzHKn3iMiE+FGcR16BHAW6gnizE7o+0hpfwAqE6mhIsa8nqoQMgr90unfPB8
	 brVwggOj+VXE0yZgqPKH62cmZlayZbPSDW6uBZb6kNCnuSL3MvnFzkt2hZGMpYrR3F
	 qJY9SvfPU5PRwC286iboSoLsjmoN4beFzUdwGMgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/935] bpftool: Fix pretty print dump for maps without BTF loaded
Date: Sat, 12 Sep 2026 08:57:36 +0200
Message-ID: <20260912065536.596272572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f76d8507d23834f7e56b0fe95c82605e7d7e0efe ]

The commit e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
fails to dump map without BTF loaded in pretty mode (-p option).

Fixing this by making sure get_map_kv_btf won't fail in case there's
no BTF available for the map.

Fixes: e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220216092102.125448-1-jolsa@kernel.org
Stable-dep-of: 66d7e39e49b0 ("tools/bpf/bpftool: Reset vmlinux BTF after map commands")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 12d782962c8c8..fe3ac01db919e 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -792,29 +792,30 @@ static int maps_have_btf(int *fds, int nb_fds)
 
 static struct btf *btf_vmlinux;
 
-static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
+static int get_map_kv_btf(const struct bpf_map_info *info, struct btf **btf)
 {
-	struct btf *btf = NULL;
+	int err = 0;
 
 	if (info->btf_vmlinux_value_type_id) {
 		if (!btf_vmlinux) {
 			btf_vmlinux = libbpf_find_kernel_btf();
-			if (libbpf_get_error(btf_vmlinux))
+			err = libbpf_get_error(btf_vmlinux);
+			if (err) {
 				p_err("failed to get kernel btf");
+				return err;
+			}
 		}
-		return btf_vmlinux;
+		*btf = btf_vmlinux;
 	} else if (info->btf_value_type_id) {
-		int err;
-
-		btf = btf__load_from_kernel_by_id(info->btf_id);
-		err = libbpf_get_error(btf);
-		if (err) {
+		*btf = btf__load_from_kernel_by_id(info->btf_id);
+		err = libbpf_get_error(*btf);
+		if (err)
 			p_err("failed to get btf");
-			btf = ERR_PTR(err);
-		}
+	} else {
+		*btf = NULL;
 	}
 
-	return btf;
+	return err;
 }
 
 static void free_map_kv_btf(struct btf *btf)
@@ -849,8 +850,7 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	prev_key = NULL;
 
 	if (wtr) {
-		btf = get_map_kv_btf(info);
-		err = libbpf_get_error(btf);
+		err = get_map_kv_btf(info, &btf);
 		if (err) {
 			goto exit_free;
 		}
@@ -1041,8 +1041,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 	json_writer_t *btf_wtr;
 	struct btf *btf;
 
-	btf = get_map_kv_btf(info);
-	if (libbpf_get_error(btf))
+	if (get_map_kv_btf(info, &btf))
 		return;
 
 	if (json_output) {
-- 
2.53.0



