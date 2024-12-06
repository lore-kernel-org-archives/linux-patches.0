Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF12F47F53;
	Fri,  6 Dec 2024 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497070; cv=none; b=IFXCM3/BVVh7oCrkqKaADbImHAZQKch3gyYOZadY+nsqkntI4Ew0J7nvATLkJpMX0x5MV3t/3PDO4n9mh6Xjgz+xSExO74M8THW1oFsMLW4YRbbLzSg0WkNJMGZFtOfgs4pgL795bJXr2Zh8C3EKNzElJX04Bk/84A5uJ027Zfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497070; c=relaxed/simple;
	bh=DCCssZNn/b5dT4/Xy+0TsQMQiiIPiGgpX0mLjJQ3HYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI9QQLXJcMBhBw3Pm2LmLl6Z9HUMqxx8x8Shj2p5yLwNBJD8kKtLolr7dYGJgYF8PESDRtDnzz/ax5yvhj0ppvK8dkZjshtUipiCtJtGyJHNEpEGbEx9p5c6AX2Bs9HakaYMzUCplMZhu1TJDHHyYeBDWs7qilFyScCkPj6e0LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNxUz9UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNxUz9UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF44CC4CED1;
	Fri,  6 Dec 2024 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497070;
	bh=DCCssZNn/b5dT4/Xy+0TsQMQiiIPiGgpX0mLjJQ3HYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNxUz9UCbf1JLFRbuOAojLFNJWEKd+ui8rpKXruWZokazBwn/1BTQcLiu18wJGw4c
	 wDUqu9Tf/2Ki2Nj8+awDD6BCDSsSmEExfys9g7qKCCMcTbqBzcgIpMYKFpIZF6/Kc4
	 dxBiVcR1oKJpvMZPt92h4Vxn/8A5S3aU9AhDijtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Tao Chen <chen.dylane@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/676] libbpf: Fix expected_attach_type set handling in program load callback
Date: Fri,  6 Dec 2024 15:30:05 +0100
Message-ID: <20241206143700.613122537@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Tao Chen <chen.dylane@gmail.com>

[ Upstream commit a400d08b3014a4f4e939366bb6fd769b9caff4c9 ]

Referenced commit broke the logic of resetting expected_attach_type to
zero for allowed program types if kernel doesn't yet support such field.
We do need to overwrite and preserve expected_attach_type for
multi-uprobe though, but that can be done explicitly in
libbpf_prepare_prog_load().

Fixes: 5902da6d8a52 ("libbpf: Add uprobe multi link support to bpf_program__attach_usdt")
Suggested-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Tao Chen <chen.dylane@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240925153012.212866-1-chen.dylane@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ceed16a10285a..834b3e6bc72c3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6837,8 +6837,14 @@ static int libbpf_prepare_prog_load(struct bpf_program *prog,
 		opts->prog_flags |= BPF_F_XDP_HAS_FRAGS;
 
 	/* special check for usdt to use uprobe_multi link */
-	if ((def & SEC_USDT) && kernel_supports(prog->obj, FEAT_UPROBE_MULTI_LINK))
+	if ((def & SEC_USDT) && kernel_supports(prog->obj, FEAT_UPROBE_MULTI_LINK)) {
+		/* for BPF_TRACE_UPROBE_MULTI, user might want to query expected_attach_type
+		 * in prog, and expected_attach_type we set in kernel is from opts, so we
+		 * update both.
+		 */
 		prog->expected_attach_type = BPF_TRACE_UPROBE_MULTI;
+		opts->expected_attach_type = BPF_TRACE_UPROBE_MULTI;
+	}
 
 	if ((def & SEC_ATTACH_BTF) && !prog->attach_btf_id) {
 		int btf_obj_fd = 0, btf_type_id = 0, err;
@@ -6915,6 +6921,7 @@ static int bpf_object_load_prog(struct bpf_object *obj, struct bpf_program *prog
 	load_attr.attach_btf_id = prog->attach_btf_id;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
+	load_attr.expected_attach_type = prog->expected_attach_type;
 
 	/* specify func_info/line_info only if kernel supports them */
 	btf_fd = bpf_object__btf_fd(obj);
@@ -6943,9 +6950,6 @@ static int bpf_object_load_prog(struct bpf_object *obj, struct bpf_program *prog
 		insns_cnt = prog->insns_cnt;
 	}
 
-	/* allow prog_prepare_load_fn to change expected_attach_type */
-	load_attr.expected_attach_type = prog->expected_attach_type;
-
 	if (obj->gen_loader) {
 		bpf_gen__prog_load(obj->gen_loader, prog->type, prog->name,
 				   license, insns, insns_cnt, &load_attr,
-- 
2.43.0



