Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5681F35C6B2;
	Sat, 12 Sep 2026 09:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206264; cv=none; b=Jn2UudsXDNRq04zATayD3gD6xj8l/ezKvKGFFbg1FBYnLtqwEoutwZUL+5DKB9nv0HXu9Oopu8nM73IevwBlIyxAd6EGqN8Zz0BX+ITmk76DMb+YDXoh05UV1mvBo5DL8j2EeEBay4Qo0u//VODotRaQxbBvdfnB2ZfxwTZayOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206264; c=relaxed/simple;
	bh=OzPRaCpwEgz/HETXRAFxWzvDE1gOZplaZ7I2yH8WnCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaU0heNz3YjhbczmhpY749VkZ4XEqAzb6gm78qWgED/pxU7qo176X+xuKoYOddMPAJFkz1zWFRvEbLr6ZD1NKEbzRNK8b0nY2wKgojtnpudTQ39mSDYiqJpNLIzmHLQQkqrddANAgnStOeikW8k7K4jvkxLbJ2j8Tixc4SimR/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyuSMnSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyuSMnSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF0D1F000FF;
	Sat, 12 Sep 2026 09:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206263;
	bh=ow8QGPTm4XZxpXHD9WiNeGXaNwvOj2z2K7notpeIezo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyuSMnSZ71E+Cxff5cgFXrNFSQ/g82y1XMJGcLxElJCTmHn/KL6SnYXjptJgqPoLF
	 537dXy/V0FyyZB06iTsndqLvzxS5xbcOr6zLvWeBbcLb9dqv7Zt1s1yV21iVV/ctnn
	 Oyo9mRVl2QxBffEBiuCE3UTVs/K0gtcoHeDp4VRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0170/1518] tools/bpf/bpftool: Reset vmlinux BTF after map commands
Date: Sat, 12 Sep 2026 08:38:59 +0200
Message-ID: <20260912065627.342791937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 66d7e39e49b0dd57610c9b63afc65b4d5690983b ]

get_map_kv_btf() caches the vmlinux BTF object when a map uses
btf_vmlinux_value_type_id. map dump released that object when the
command completed, but left the global pointer stale.

The same cached object can also be returned to print_key_value(), which
freed it directly. That leaves btf_vmlinux dangling before the command
cleanup path runs.

Use free_map_kv_btf() for per-entry cleanup, and reset the cached
btf_vmlinux pointer when the map command releases the object. This keeps
batch mode from reusing a freed BTF object.

Fixes: 4e1ea33292ff ("bpftool: Support dumping a map with btf_vmlinux_value_type_id")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/9072F43B3F74DF91+20260624025055.1574875-2-chenyichong@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c9de44a45778b..f65f774476a70 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -790,6 +790,12 @@ static int maps_have_btf(int *fds, int nb_fds)
 
 static struct btf *btf_vmlinux;
 
+static void free_btf_vmlinux(void)
+{
+	btf__free(btf_vmlinux);
+	btf_vmlinux = NULL;
+}
+
 static int get_map_kv_btf(const struct bpf_map_info *info, struct btf **btf)
 {
 	int err = 0;
@@ -958,7 +964,7 @@ static int do_dump(int argc, char **argv)
 		close(fds[i]);
 exit_free:
 	free(fds);
-	btf__free(btf_vmlinux);
+	free_btf_vmlinux();
 	return err;
 }
 
@@ -1049,7 +1055,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 		btf_wtr = get_btf_writer();
 		if (!btf_wtr) {
 			p_info("failed to create json writer for btf. falling back to plain output");
-			btf__free(btf);
+			free_map_kv_btf(btf);
 			btf = NULL;
 			print_entry_plain(info, key, value);
 		} else {
@@ -1065,7 +1071,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 	} else {
 		print_entry_plain(info, key, value);
 	}
-	btf__free(btf);
+	free_map_kv_btf(btf);
 }
 
 static int do_lookup(int argc, char **argv)
-- 
2.53.0



