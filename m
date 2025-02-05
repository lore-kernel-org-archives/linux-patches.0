Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F181FC111;
	Wed,  5 Feb 2025 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766817; cv=none; b=hGzS097vSSa3K5qhihtIpVXG04VhusrXt8RAGTUvpMzM+LjzBaQ1ldoKZJ83gvcBNPb1fZRxrHffvraw96K+GEEwjy/fg1bubEEkRVZ+/V0JM3jThIoE9iZCMCbqkBl14BAjL1974tqelyZa89YaKCWpFbA0j2a25rRGYMwcsB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766817; c=relaxed/simple;
	bh=OLEXA/vreJ7AQ8omtBTxqt6NKgiSO5ijgH2Dbv9AT98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9OHE5QoPc+pmNyEwrwZsKGz+qyZpeiNkJ1qK9siLa5jBA+04DrXTmbPfPltNWRwt9sddiKvgoDWno0Hfc30vFU/WG4cnA9QuC5zrJx47Y0hx1j1QsI93tYoOLS3PhxXb2EhhLtvWFZWm3b4xeF5Nboe+OCE59prwK/XDvckCUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyrTeam2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyrTeam2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B97C4CED1;
	Wed,  5 Feb 2025 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766817;
	bh=OLEXA/vreJ7AQ8omtBTxqt6NKgiSO5ijgH2Dbv9AT98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyrTeam2bntU3aMp/Z1Fg69eau83xFeaQN6tYvzMQl2oPmqOpZZu6D7T63UyZx4RG
	 6e1xNnmKqlx4pU38WzVUES4+Q7vd+7Rfa5KXcW3hX9aa66TSzpcqEJcsNUeELiHZ/p
	 U/dabWY48qP5xswBKpyCt3Ybcvh0KpQeQ4m0JtMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 312/623] bpf: tcp: Mark bpf_load_hdr_opt() arg2 as read-write
Date: Wed,  5 Feb 2025 14:40:54 +0100
Message-ID: <20250205134508.160194612@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 2fb45a86f3ddb..d59a7ea646cad 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7652,7 +7652,7 @@ static const struct bpf_func_proto bpf_sock_ops_load_hdr_opt_proto = {
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



