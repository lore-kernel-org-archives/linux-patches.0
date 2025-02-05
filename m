Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09E0149C53;
	Wed,  5 Feb 2025 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764607; cv=none; b=hH/qSS0QXi2ZqgzIgqQfooCqVmmB1FYDQjGfpIua8CNXPSBLuQnuQRXy6I+/PlNmmUA58s95BFebqwXcgK0wA3NnUIi2MZsmErBJEY3NYwR67NXgwshWywPGG4UVVKK+SwQ1WAcud8x0O4+BefR9sPBjsJY79D0XiLpMJUeGsJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764607; c=relaxed/simple;
	bh=GV5yj26IeDgS/k6415t7zm0NlvCvoP6DplPitdBc938=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRiPHGgoyP83CmyVGPnz2MITIPcoTWnlKcE8viPlZkz03LykN/hlVmSGEaLSbXJtHQewqpFjLGR06320ZpQOZG19l8V8eVM6PrlwWPSWF21VOVN9L2yWfuOZBRkI+AkbTQ5QyyOM5dEYjifTmjA9yTpLCJ1cSremMp1w02qbIlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/jvfXpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/jvfXpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8936C4CED1;
	Wed,  5 Feb 2025 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764606;
	bh=GV5yj26IeDgS/k6415t7zm0NlvCvoP6DplPitdBc938=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/jvfXpisa1tP1p78C/Cz/1uKruLVNmOvyT/YVZRxkj8KiJX7hZASRm/vwYRlwnor
	 zvnDhYGlWcv3QgIkuSJn0uds272i8rUmjddnbhANIbICVOZaJnqfqtAK4F1H1v1NAO
	 9H9cYSZNtZj0xQNScvIIuuJ3/5GH37NyEoVvMCVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/393] bpf: tcp: Mark bpf_load_hdr_opt() arg2 as read-write
Date: Wed,  5 Feb 2025 14:41:45 +0100
Message-ID: <20250205134427.414807253@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Xu <dxu@dxuuu.xyz>

[ Upstream commit 8ac412a3361173e3000b16167af3d1f6f90af613 ]

MEM_WRITE attribute is defined as: "Non-presence of MEM_WRITE means that
MEM is only being read". bpf_load_hdr_opt() both reads and writes from
its arg2 - void *search_res.

This matters a lot for the next commit where we more precisely track
stack accesses. Without this annotation, the verifier will make false
assumptions about the contents of memory written to by helpers and
possibly prune valid branches.

Fixes: 6fad274f06f0 ("bpf: Add MEM_WRITE attribute")
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Link: https://lore.kernel.org/r/730e45f8c39be2a5f3d8c4406cceca9d574cbf14.1736886479.git.dxu@dxuuu.xyz
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5881944f1681c..84992279f4b10 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7604,7 +7604,7 @@ static const struct bpf_func_proto bpf_sock_ops_load_hdr_opt_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
-- 
2.39.5



