Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693DC151988;
	Wed,  5 Feb 2025 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766123; cv=none; b=uxHR/TDxIH7xtpaNbDu/eCDFX7aIMp+VwDe0WRWvAHyS5Q6lZPf1pT80+eP8qTXFk2DYDa2GQHC2ZIymN7VNnXcejmeJwK8TSgMlnyat/r2E9rJ0Kmd3XvuWqxxPf3l8Deq2N2rlzOaOdyVZahFkWJxQmRvrIFS0spFUivT0zwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766123; c=relaxed/simple;
	bh=iF9qAu9PYZQ6GYZ+5N5uEUuZTyy672RqwUAxcAPLpu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co8Rck3VkXaqrCal1x7gZ2W6y5B6KejN6WFAvUn203I2eXuMZdOpflzHgNgjXh/6YAakgj4SjuO43QOuuF1ZIoEudWKwDNjOBCT86yy5vGM+3rHCYasbbzFMaROP94FIcVkjxTlKLn0kGqK/dIDNXSROTaED08IsWCDkUC/16ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYSZTnTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYSZTnTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C77C4CEDD;
	Wed,  5 Feb 2025 14:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766123;
	bh=iF9qAu9PYZQ6GYZ+5N5uEUuZTyy672RqwUAxcAPLpu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYSZTnTkVSi2c2/uf3g+aHQu/pqtuqr0LvOX/qaAd3Kx3AG9Ed37BQJfPBQJjCeV/
	 xoqUkLrHI/ewCxHa4tM9hok7HMGM2fceqsFsSY6VAfzW3s+LcxmlCxkb/M+D3a4Ido
	 oP0khd8GRZwUBEwvTMSEmXrWn7+CCjG2yVxGJjG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/590] bpf: tcp: Mark bpf_load_hdr_opt() arg2 as read-write
Date: Wed,  5 Feb 2025 14:40:44 +0100
Message-ID: <20250205134506.333759840@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 46da488ff0703..a2f990bf51e5e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7662,7 +7662,7 @@ static const struct bpf_func_proto bpf_sock_ops_load_hdr_opt_proto = {
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



