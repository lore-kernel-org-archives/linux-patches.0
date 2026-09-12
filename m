Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6911119E7F7;
	Sat, 12 Sep 2026 07:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197318; cv=none; b=HYTlHAWYPf/YgUBY04UvZg0h1awXmtSUT7iFtktlPvDFziMPpHkUAOPCvBY/9+JMUl0LKHVA1G7XkKejz8RaEg0MDlnpjvdBdmmbNEA9DYmOPW8aYLpLKp14OXsx9bqjUkEqB7yq5fW4wwLKc4vhoDxT2Of2Rd8qYW20ZeZS5kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197318; c=relaxed/simple;
	bh=h3t2Z4fF43eXPVZXcVoTfsNxCKbwfsZed9usvflMLGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9fGv94FydM7NrKS14VwAGEJ5fTWVvbRURfiV+S9pm/i81lKRMremTvTbN/YheGna/AjxCZFHZIkXIkIZ82rz0q6lKABVDoQFHtatz+43P4BioQdF/5t//ribpBJvUlChb/OmC6udWjxrEedcUTEu5UupMqF0hIwXeciaZtu5To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3tIcWYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3tIcWYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4311F000FF;
	Sat, 12 Sep 2026 07:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197315;
	bh=uS6zg1BkNhceBjnC8gvZ8eykBKU+jOwFb0H/l9US3GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3tIcWYit25OPbkvwFTjRXEztw1z2TedNuV4sojLSs/yaL2vhUkDotO6SStm/EykQ
	 12S+MVzSEdgFC8D8ww77NiVXS1Z2qMvFFzB+067D+EX7OcRiIMCH3Kp1YGbXQt/7ut
	 Myd+06Z5JpaJFJyNqsczyuNoKmaPLg2svwtuVP7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0150/1815] tools/bpf/bpftool: Reset vmlinux BTF after map commands
Date: Sat, 12 Sep 2026 08:31:40 +0200
Message-ID: <20260912065652.537444926@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 71a45d96617ed..6b9649294ca1a 100644
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



