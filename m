Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512362F8EAE;
	Sat, 12 Sep 2026 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222605; cv=none; b=PkQ6yqz/owbVLKX7t94qkRCETkc/2SlYSwoLWGL7Md3zdiFmDt84dCDCgNAlVPEFRLQd0qzqQUoiAvJtDZh1cmb43NtLXIBu3rUSzSrN5NghVDUtsTH3osoYKoyYx01c/8D4Iu2TmrcXTVvx+eeYIx4yY0Bp7vtln7GRuS3vH0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222605; c=relaxed/simple;
	bh=HeXj0vqZAarkLg6VbeHQPzKPIizMwzrBWdg4foDXmW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRZv+0OeDmsP1JMttAJi5lXDozIBo3TRyfhLscs72KJXA7GOqw7UB23fAy7SOTzWZleKfWJZ2jcp9G/pttCL3uIZqxNCgfQ/D8RfthN9hC6mhOe8lA9wDGyqCSJpJA20fXg8rKQGudcwCBTZnWngDkZcLbGKjcCP5WeuaQX0v2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HEolQOS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HEolQOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D781F000FF;
	Sat, 12 Sep 2026 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222604;
	bh=eqFV4k/mmp8Dh8SvumYkOffAqiKeScikj3l36ET7vnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HEolQOSITItzWmgPq3N/GZUXGHRf5heFrnAJD8g8yPQkyQTF+BzBhHKCDfDsVQap
	 rAcwGx8LyMKA6q8X1/BHR9Izt1o2zwMKeYrhI9FMsjgsN/QqI3Lm7WiUToT/BjveCy
	 M79DACLPuAKmbsV9e/DtYaFs/8WhodhUFM1pB9Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0619/1424] tools/bpf/bpftool: Reset vmlinux BTF after map commands
Date: Sat, 12 Sep 2026 08:50:51 +0200
Message-ID: <20260912065621.153072805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f98f7bbea2b15..6edea36fc6375 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -787,6 +787,12 @@ static int maps_have_btf(int *fds, int nb_fds)
 
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
@@ -955,7 +961,7 @@ static int do_dump(int argc, char **argv)
 		close(fds[i]);
 exit_free:
 	free(fds);
-	btf__free(btf_vmlinux);
+	free_btf_vmlinux();
 	return err;
 }
 
@@ -1046,7 +1052,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 		btf_wtr = get_btf_writer();
 		if (!btf_wtr) {
 			p_info("failed to create json writer for btf. falling back to plain output");
-			btf__free(btf);
+			free_map_kv_btf(btf);
 			btf = NULL;
 			print_entry_plain(info, key, value);
 		} else {
@@ -1062,7 +1068,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 	} else {
 		print_entry_plain(info, key, value);
 	}
-	btf__free(btf);
+	free_map_kv_btf(btf);
 }
 
 static int do_lookup(int argc, char **argv)
-- 
2.53.0



