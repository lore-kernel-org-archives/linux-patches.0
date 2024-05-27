Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCE2763F8;
	Mon, 27 May 2024 19:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836651; cv=none; b=tEQRvidDpNGWlB5vuarOW5vwcNn1ZM5tBRKbV2j+1lL7cxSdFNLLxMhgVgro4tpFIaHYNowNBwhGdt3mEAts7oB15o5H1bjoB9aNtmJ3cnkXdvYVgwyygmwmeL86FpgNJbj3Oo76qUNNZ5ej/Mdc8qgbDg0LFY08svDo7cbE83c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836651; c=relaxed/simple;
	bh=sFxClzDhnZJVamf2jYOG1NzjR4rftAzlsBF0AZWaMyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdQt7uLj4iQMe2Jo0Hzjgum4E+X+/H/BzEdBiaoBVMDq+HBHjjhCno/zimbY7azLDZ079+Ig6hAAb3A2F5RFegEYNWHx57dc2NHzR2Ko1NbxzpvYsuNXUhoNmySfmaxZd6MXASfv8zo5qIcWhMRntj4YLMnsuk9a8iO5RsnrKtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHRx5Kyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHRx5Kyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812C8C2BBFC;
	Mon, 27 May 2024 19:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836650;
	bh=sFxClzDhnZJVamf2jYOG1NzjR4rftAzlsBF0AZWaMyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHRx5KyvckSngWQ74W3zz8/iOp6RAVDm0GeqG35xCOcYsd1X6xUYpS8fovA4CQJeK
	 BABhbKyRotOrEnE3s5cbyO7Q1DOVWEQIECht9nrI3nBwj4F8TDEcEws8LpEWUasjaT
	 HaZRKKvEwjrvUPT3gMwb3C+a5fPROu/3IcnVcTzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 094/427] libbpf: Prevent null-pointer dereference when prog to load has no BTF
Date: Mon, 27 May 2024 20:52:21 +0200
Message-ID: <20240527185610.575662813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index a2061fcd612d7..4980ed4f7559b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7321,9 +7321,9 @@ static int bpf_object_load_prog(struct bpf_object *obj, struct bpf_program *prog
 	char *cp, errmsg[STRERR_BUFSIZE];
 	size_t log_buf_size = 0;
 	char *log_buf = NULL, *tmp;
-	int btf_fd, ret, err;
 	bool own_log_buf = true;
 	__u32 log_level = prog->log_level;
+	int ret, err;
 
 	if (prog->type == BPF_PROG_TYPE_UNSPEC) {
 		/*
@@ -7347,9 +7347,8 @@ static int bpf_object_load_prog(struct bpf_object *obj, struct bpf_program *prog
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



