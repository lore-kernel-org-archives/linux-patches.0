Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0BB13B59A;
	Mon,  6 Jan 2025 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178975; cv=none; b=A5FDSB1ACBd62WmtSANFur+RMvLjicndgq5KNmOUvKGfiNnJ+8S8lOyFYniul2i5LCMar1BdsxcDd3AWIJ2Wis3bJ16koETL6Tzuqu4jEQVqZ5YhsaRy/KMCegqYEcc7yZ6wAE0f8drWYGPLo03u7P39UVZXrdQgPa03M4jfYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178975; c=relaxed/simple;
	bh=qZp8vRJbsgnhjCHaBwOqshz8gC3edNP3Q+HNswn+44Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuKSdMuSpPw/fpUdhiiS1nrqAXdpdIj7DzFAiGqW22k5baOl4R+zYEXwCezNivZpdpd3bjVJlKC04ytDXdXTFBwtHI7DSuJGfyyxdQzpCyDd+64Lr4mWLhIBMGA4sdwzA/MVX/Nfthe0yaoMhTOaIijlNTGQkFONmASQ0wLaI9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JchIy/dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JchIy/dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66023C4CED2;
	Mon,  6 Jan 2025 15:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178974;
	bh=qZp8vRJbsgnhjCHaBwOqshz8gC3edNP3Q+HNswn+44Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JchIy/ddx6Rf0xaDocvc0rLXRv5+lva3tgMrI9BFSOFvKhPGDwuKNVE9bBw0hMoDu
	 qdiUoYTqPYtC0oZGDNixG+Vh2pvK4BlWKXaAsinmQaqs4+aN/LX1ydmujGjKTSZdkE
	 MLK/ipcjj6JGEl1V7Ut/dM3oKoj3l3btCKrfm+zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/168] bpf: fix potential error return
Date: Mon,  6 Jan 2025 16:17:42 +0100
Message-ID: <20250106151144.251030379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f36f7b71dc07..d7dbca573df3 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -504,6 +504,8 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 
 int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
 {
+	int err;
+
 	/* Branch offsets can't overflow when program is shrinking, no need
 	 * to call bpf_adj_branches(..., true) here
 	 */
@@ -511,7 +513,9 @@ int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
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



