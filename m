Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9744238C03;
	Fri, 21 Nov 2025 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732384; cv=none; b=D0l65ePc1p01Uht24xuNQRlbfGiEpo/c8z7nZopdinD/kKK9O0h9VU3J07n1Xfk+rwIWErPKn08N4Ob0hV4h1srdIyUhTjZfP9C9nYGdxdATHtzByHC6+sy35Ycop4TX1eOSDkUHMUo4X2NecOPyMuCULhY3S6A5NRHKB3U/frU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732384; c=relaxed/simple;
	bh=knSjVujnyJIZJLHCYsW6HUsO8qKVujoIkBBb/UqgD7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0t/YsCRb0hPQFGDd1xdMrxujpPukGWdbFgt6jWB7vrL1gmn2uNx0hjIwkgdOQpGcXFrmASTJyWKcPefuT+zCy7NBvQQNdc+9shu2HClloOw+9abzGaItzKDHGbDqyXT/kQ688lt+TbIB/bBSmjkNcgijlzQjBMd+Xw4ccU7Eso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sl9nX3L/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sl9nX3L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA4BC4CEF1;
	Fri, 21 Nov 2025 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732384;
	bh=knSjVujnyJIZJLHCYsW6HUsO8qKVujoIkBBb/UqgD7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sl9nX3L/nmRKbbgem/MqAbYLLYzCnLbnmnrVQPiJGbc4tU+s69Xa0m/Q6dwAtAmC9
	 Ma+4HanXm6+exXi3OCPkv7IKTnPa6tTTi1LGZcJVCABI+D1saMwk5JXD/Cg5aZtAgL
	 vPDMWukRladlID1HMX7/wR5qBcy7nwuXfJq+D8O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Stellard <tstellar@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/529] bpftool: Fix -Wuninitialized-const-pointer warnings with clang >= 21
Date: Fri, 21 Nov 2025 14:06:34 +0100
Message-ID: <20251121130234.407609693@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Tom Stellard <tstellar@redhat.com>

[ Upstream commit 5612ea8b554375d45c14cbb0f8ea93ec5d172891 ]

This fixes the build with -Werror -Wall.

btf_dumper.c:71:31: error: variable 'finfo' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
   71 |         info.func_info = ptr_to_u64(&finfo);
      |                                      ^~~~~

prog.c:2294:31: error: variable 'func_info' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
 2294 |         info.func_info = ptr_to_u64(&func_info);
      |

v2:
  - Initialize instead of using memset.

Signed-off-by: Tom Stellard <tstellar@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20250917183847.318163-1-tstellar@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf_dumper.c | 2 +-
 tools/bpf/bpftool/prog.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 1b7f697146041..42c7b70f6996c 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -38,7 +38,7 @@ static int dump_prog_id_as_func_ptr(const struct btf_dumper *d,
 	__u32 info_len = sizeof(info);
 	const char *prog_name = NULL;
 	struct btf *prog_btf = NULL;
-	struct bpf_func_info finfo;
+	struct bpf_func_info finfo = {};
 	__u32 finfo_rec_size;
 	char prog_str[1024];
 	int err;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 174e076e56af2..90fa7a8d0f4b3 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2203,7 +2203,7 @@ static void profile_print_readings(void)
 
 static char *profile_target_name(int tgt_fd)
 {
-	struct bpf_func_info func_info;
+	struct bpf_func_info func_info = {};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
 	const struct btf_type *t;
-- 
2.51.0



