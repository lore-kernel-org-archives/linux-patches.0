Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC48C1E5711;
	Tue,  3 Dec 2024 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240731; cv=none; b=cltQp6RqaTltvr98YPeVQ68NTZO7OSbjMCcOIFNI2da2AcjBUsQccCmnPuzJaHJbl7tYDoy5kW4In4K1Fk5aR/40iBz/T7O6ru0vP/CH3qp5R+OE9NoV7E13tL/acKdMNbdiRFqSNxhZpVPYVtmdN56eCH8U2mtoaJ1KMWlsmbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240731; c=relaxed/simple;
	bh=+MH2h3c2+uz7AoDezyEB5ebNzeXeyPJM6vQtUZYIwSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljIBdPGLBWcoE+IPOdHuLbpdDROvA8w5vYDZAg4y4giF0YNBeo2SvTVQq9PClVyoQtyqDH9ikug/s9eOXUx7pg5ipKtzoinwOokmQsI6T3uOZ7JDLJcvB7tRBDQbYhIjfmAYhqrIktWiOTEPp3k2Vb7eaCsPMl8tpNuo0qzeQlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZR6OCXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZR6OCXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32545C4CED6;
	Tue,  3 Dec 2024 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240731;
	bh=+MH2h3c2+uz7AoDezyEB5ebNzeXeyPJM6vQtUZYIwSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZR6OCXFCboEV4tZyJeYZIVVXFDaTIPkwPsVYiDIp9LEDpHJ7V4Pdofqg9gbFFPzA
	 h5s3kfSwfJ57l+sQa0fbHJmqJzYhoTIxHww4mRQrh27ylfUNhREbJC9260jKKPd31N
	 kOBMZk9AJoOHLEGH6C1jQu0gsJhFS/1FmbduzOec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Tao Chen <chen.dylane@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/826] libbpf: Fix expected_attach_type set handling in program load callback
Date: Tue,  3 Dec 2024 15:39:06 +0100
Message-ID: <20241203144752.282609305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 219facd0e66e8..04389d00849f7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7352,8 +7352,14 @@ static int libbpf_prepare_prog_load(struct bpf_program *prog,
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
@@ -7443,6 +7449,7 @@ static int bpf_object_load_prog(struct bpf_object *obj, struct bpf_program *prog
 	load_attr.attach_btf_id = prog->attach_btf_id;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
+	load_attr.expected_attach_type = prog->expected_attach_type;
 
 	/* specify func_info/line_info only if kernel supports them */
 	if (obj->btf && btf__fd(obj->btf) >= 0 && kernel_supports(obj, FEAT_BTF_FUNC)) {
@@ -7474,9 +7481,6 @@ static int bpf_object_load_prog(struct bpf_object *obj, struct bpf_program *prog
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



