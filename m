Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DE742040;
	Mon,  6 Jan 2025 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178507; cv=none; b=cxuB2bvYbiyVK9kBrr1GVQLleDW98UdcQxyT5+jLQhrtK0LpR+xt8p9uaL2x2b5Zd/a4S3YucxHsyD5WcthqsG7Z18xQg08Lkj9aUJZw5Q2REZWL08ylNMJ1BlcGa/pPQl3toGmze+upNsBK8ZDYgEDKL6cXUXBV1F+qVw60NcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178507; c=relaxed/simple;
	bh=FZibE7wPbamiH6YLNcLLRy71sZ7Xhi8zLcIGAYpLtgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLy1Q31qJmDqhsMQG0DsJ5/ZEZuxThbIWEDvMXOCRGnpdaEqIyFjCfZNDxy017045GLqA5cX1G+2S+xshsvw0972639HPeSmlmPY3KDNt0oiSQB6f+0S354yoZLeaw8E1KP9FnXwejtnSlQzgfqrc89Z15viS8LF70qA7c4mEYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAoaNobB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAoaNobB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC79C4CED2;
	Mon,  6 Jan 2025 15:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178507;
	bh=FZibE7wPbamiH6YLNcLLRy71sZ7Xhi8zLcIGAYpLtgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAoaNobBftFUSyBYV5wmdpU88uumkphd4cQBdMZHQ0gOGgbrto5L91iqJigqk0t1/
	 zJS/q8qB+O8RmPoh7iaJ2axssfT15hiiZzblupl1cFO6N2d9uYUmUjP4T457Xc0ftq
	 7vVgtJI616DDj5ZjxkXqXpAcQINosO3OlKqE7wtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/138] bpf: fix potential error return
Date: Mon,  6 Jan 2025 16:17:29 +0100
Message-ID: <20250106151137.964567214@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 33ea6ab12f47..db613a97ee5f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -501,6 +501,8 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 
 int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
 {
+	int err;
+
 	/* Branch offsets can't overflow when program is shrinking, no need
 	 * to call bpf_adj_branches(..., true) here
 	 */
@@ -508,7 +510,9 @@ int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
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



