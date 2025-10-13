Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A1E3195E5;
	Mon, 13 Oct 2025 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369290; cv=none; b=V61ZAdDpqzeK5URBDAlDdGIYyGqd7QtJI4B7p05PTmozFSEys7w7WX/iBLgahTQ57dUpteFso6KWxaUK6GXEHnWDLCTFpG7Ehh0NlS88I6JHUa+sUxGmKXFk8CQP1W1QRP6Yum6JZFNHtgQ5gI3TpAnXr081uju9e9jtGo9xfUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369290; c=relaxed/simple;
	bh=BmQkQi5TBCYJy2x2Y9ouQ0qZa2zzpXV9C4xMHL9B99U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rL3c0pfX6U+WrRJUUqZWlud9uVt1DGqXzHLM7USpLnXNYOpLIt2ELcZWsw1Ujo4LkQo+2z79p+LIcW/7zTmVpIthPmwWpdNR3hc943yCxhHd5Mfi5T72UCnoduYM24OpxcZyoqAxI+fqMPqjDinf5YvG2kxELcTy2mILpA2N+/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRiPNjb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRiPNjb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10EDC4CEE7;
	Mon, 13 Oct 2025 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369290;
	bh=BmQkQi5TBCYJy2x2Y9ouQ0qZa2zzpXV9C4xMHL9B99U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRiPNjb3O8P5OILPT3QP8q0lOflemvRkovFrWs1lwLmV/ZHeDCcbO3pLmkBCnnJda
	 vjDJq1hNwwW/2HRT4qi9Nm6CibyM3OQLGiHkZZlnvzDDE9Fr66JBvNeLJfXwdHQhJt
	 djojo40FLeFiJgC8lzLXvwoQiIVRgXfHR3Z3xr4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Vernet <void@manifault.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrea Righi <arighi@nvidia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 193/563] bpf: Mark kfuncs as __noclone
Date: Mon, 13 Oct 2025 16:40:54 +0200
Message-ID: <20251013144418.273898304@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit d4680a11e14c7baf683cb8453d91d71d2e0b9d3e ]

Some distributions (e.g., CachyOS) support building the kernel with -O3,
but doing so may break kfuncs, resulting in their symbols not being
properly exported.

In fact, with gcc -O3, some kfuncs may be optimized away despite being
annotated as noinline. This happens because gcc can still clone the
function during IPA optimizations, e.g., by duplicating or inlining it
into callers, and then dropping the standalone symbol. This breaks BTF
ID resolution since resolve_btfids relies on the presence of a global
symbol for each kfunc.

Currently, this is not an issue for upstream, because we don't allow
building the kernel with -O3, but it may be safer to address it anyway,
to prevent potential issues in the future if compilers become more
aggressive with optimizations.

Therefore, add __noclone to __bpf_kfunc to ensure kfuncs are never
cloned and remain distinct, globally visible symbols, regardless of
the optimization level.

Fixes: 57e7c169cd6af ("bpf: Add __bpf_kfunc tag for marking kernel functions as kfuncs")
Acked-by: David Vernet <void@manifault.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Link: https://lore.kernel.org/r/20250924081426.156934-1-arighi@nvidia.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/btf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 9eda6b113f9b4..f06976ffb63f9 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -86,7 +86,7 @@
  * as to avoid issues such as the compiler inlining or eliding either a static
  * kfunc, or a global kfunc in an LTO build.
  */
-#define __bpf_kfunc __used __retain noinline
+#define __bpf_kfunc __used __retain __noclone noinline
 
 #define __bpf_kfunc_start_defs()					       \
 	__diag_push();							       \
-- 
2.51.0



