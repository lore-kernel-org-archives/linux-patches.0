Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136BF35945;
	Mon,  6 Jan 2025 16:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179295; cv=none; b=Nk0UBa2Q3xV4+FYGN/Gv7hRw2TXUpSaKlm8/5JDzWXLwH6OwHK3XrcixRMh4tf87AeXl9AYgMmOXqQzi6L/8z9nzEZdlP88pUZYbFUz/FTPnb+kZyRriDAlWDFyf9QMIVZunzrtvHlNkfDCanSlzmcfvCSXjGNdIFrvYrrKIYOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179295; c=relaxed/simple;
	bh=pVy55OOvRTXnO+o3bLwTfVpPAfpI4uvVVln8Dc+g5sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpeKNoN/oJHcK7LP5utCGa5qOf/QFfCrRuONs2J7EY2QTsL0Qf7TrLfN9bJQM3dL1STCMCgAq3sC5BZqw1psBmbwQCoBbcXP3sOkQ0eSmp9DEAAtbfzjdLmhemnhIJ0/2BBk806LxbP2SK/tDry0M9LY2xrPQE9WZREvZQSswn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lj9m5PZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lj9m5PZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A7CC4CED2;
	Mon,  6 Jan 2025 16:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179294;
	bh=pVy55OOvRTXnO+o3bLwTfVpPAfpI4uvVVln8Dc+g5sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lj9m5PZ/3viEYhgonHYuhHVDauSDbixb5VCAzjI08TUlQD8gEd9p1szJg43xLGXZq
	 9UGihw7mGYFIMUG4W38fib7BsCKeYScgRZOWrKTQXWoiVTtgwuqm1/0RJ9FnQYCm/p
	 72M73bz15hcMMZoFaaGDHJoHG4c+vICBdN+mExJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 82/93] bpf: fix potential error return
Date: Mon,  6 Jan 2025 16:17:58 +0100
Message-ID: <20250106151131.800565031@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <aspsk@isovalent.com>

[ Upstream commit c4441ca86afe4814039ee1b32c39d833c1a16bbc ]

The bpf_remove_insns() function returns WARN_ON_ONCE(error), where
error is a result of bpf_adj_branches(), and thus should be always 0
However, if for any reason it is not 0, then it will be converted to
boolean by WARN_ON_ONCE and returned to user space as 1, not an actual
error value. Fix this by returning the original err after the WARN check.

Signed-off-by: Anton Protopopov <aspsk@isovalent.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20241210114245.836164-1-aspsk@isovalent.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index dde21d23f220..9fb103426cf0 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -496,6 +496,8 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 
 int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
 {
+	int err;
+
 	/* Branch offsets can't overflow when program is shrinking, no need
 	 * to call bpf_adj_branches(..., true) here
 	 */
@@ -503,7 +505,9 @@ int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
 		sizeof(struct bpf_insn) * (prog->len - off - cnt));
 	prog->len -= cnt;
 
-	return WARN_ON_ONCE(bpf_adj_branches(prog, off, off + cnt, off, false));
+	err = bpf_adj_branches(prog, off, off + cnt, off, false);
+	WARN_ON_ONCE(err);
+	return err;
 }
 
 static void bpf_prog_kallsyms_del_subprogs(struct bpf_prog *fp)
-- 
2.39.5



