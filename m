Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068D215FCE9;
	Mon, 27 May 2024 19:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837843; cv=none; b=kJ3es2QBfnZWpJ+v9Dl6/DC2r6bDFyYTsn8ijUZyeu2sTYCxNnO1AL375PqGPxH6jTVkFOfCfN/I/PIKwvR5/JoSJpu7J0hp1dqurFzW6RjyGjU9mikUSzgL6rHeIWEkMcYF5Nn/ORjpt/MRSevs8TmW9XxGHTwX1v4eH3K7ddM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837843; c=relaxed/simple;
	bh=TiGnTz90g4pCIsuEFxq2nf1laXcoLN07OIRyR6tuoBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7c66HBPt/TqlxDs/A1VICdFmf8TJj/XbaE1/xNePsuLw0MmQHBa6WGU8fmdB/Ehvpub80iJiX34UxcVjvizeatCAf+50pfFk7dgkLK83vjah0S/Sin1ixgrkKUCFC37m8+84x5kZTtqBf5kf8MzNqCGktD2o1EWUNDWDttSHBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1T7LAzMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1T7LAzMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB4EC2BBFC;
	Mon, 27 May 2024 19:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837842;
	bh=TiGnTz90g4pCIsuEFxq2nf1laXcoLN07OIRyR6tuoBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1T7LAzMHrDS01V7atTxDHJFIix3kRCbb+7VMDLgF3dcl9f6e8mOeS8bgI8pN1mNSe
	 2b6mBdygp9kezKEfU5iTYGHMOfihCJzPvsBUoqeI8mbaGIUG9JczQYn0hZHyei38jx
	 zdgbVNp5mbci9pY8aGtZP7khI+MJhIXu/oDjsnDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 165/493] libbpf: Prevent null-pointer dereference when prog to load has no BTF
Date: Mon, 27 May 2024 20:52:47 +0200
Message-ID: <20240527185635.767962530@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Monnet <qmo@kernel.org>

[ Upstream commit 9bf48fa19a4b1d186e08b20bf7e5de26a15644fb ]

In bpf_objec_load_prog(), there's no guarantee that obj->btf is non-NULL
when passing it to btf__fd(), and this function does not perform any
check before dereferencing its argument (as bpf_object__btf_fd() used to
do). As a consequence, we get segmentation fault errors in bpftool (for
example) when trying to load programs that come without BTF information.

v2: Keep btf__fd() in the fix instead of reverting to bpf_object__btf_fd().

Fixes: df7c3f7d3a3d ("libbpf: make uniform use of btf__fd() accessor inside libbpf")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240314150438.232462-1-qmo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 92bca96587a4a..5af9cab422ca3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7456,9 +7456,9 @@ static int bpf_object_load_prog(struct bpf_object *obj, struct bpf_program *prog
 	char *cp, errmsg[STRERR_BUFSIZE];
 	size_t log_buf_size = 0;
 	char *log_buf = NULL, *tmp;
-	int btf_fd, ret, err;
 	bool own_log_buf = true;
 	__u32 log_level = prog->log_level;
+	int ret, err;
 
 	if (prog->type == BPF_PROG_TYPE_UNSPEC) {
 		/*
@@ -7482,9 +7482,8 @@ static int bpf_object_load_prog(struct bpf_object *obj, struct bpf_program *prog
 	load_attr.prog_ifindex = prog->prog_ifindex;
 
 	/* specify func_info/line_info only if kernel supports them */
-	btf_fd = btf__fd(obj->btf);
-	if (btf_fd >= 0 && kernel_supports(obj, FEAT_BTF_FUNC)) {
-		load_attr.prog_btf_fd = btf_fd;
+	if (obj->btf && btf__fd(obj->btf) >= 0 && kernel_supports(obj, FEAT_BTF_FUNC)) {
+		load_attr.prog_btf_fd = btf__fd(obj->btf);
 		load_attr.func_info = prog->func_info;
 		load_attr.func_info_rec_size = prog->func_info_rec_size;
 		load_attr.func_info_cnt = prog->func_info_cnt;
-- 
2.43.0



