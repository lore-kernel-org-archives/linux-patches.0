Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAB8360EF5;
	Sat, 12 Sep 2026 08:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200738; cv=none; b=jKnyJ9yv3ci4mHC59OXNleCGLqVLWJzH8kc2XKbJQzGfU1KPQ0SpS0cYWkVRfKMDEoLJwSg2Qz6N0AfTitPFm9MNPLblu9REThxkoqwD6kQa7w3MIluKTCf1+9bnF9/M76bY2eBvXHaUe1VPhNj2YNiyX5dJlLYuuaWlG/nL7ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200738; c=relaxed/simple;
	bh=dsl7dohyOaKHCAlKuQ+4iddCbC+WWLTVpVseFd5G1BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uaiA+nwz5n7NgtQZv8IMYwab5gc4qK3mI0XQ+1nyxtSXjQEzTwGFLFqqDChIE49q7KAzDskDndBNYBaEgejO+DhratSopvErduyTpeoMBnjRtB0Hvd8pbo7F3HaioTPvMUlzExu4p1Pw4OjVDmMDmh6flpo7u6moJpH4i2gkca8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2RVF6a5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2RVF6a5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860971F000FF;
	Sat, 12 Sep 2026 08:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200737;
	bh=uZcv0YO9OU1N2BmtIHZiP06c42QZiDFJNsc2Tmm0yEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2RVF6a5IYLucEsTZR+kd3YcdwzH5qqyeldXG0HomwgNqRMNf0J7GIq4XWwizDqJv
	 8UOn4RwEzTZAVABSng4J1x/T0wICi1fJ4yTphtCUSuIp+R3I5gvQgiBxFyIVWyModP
	 jYPiDyVtw+19kJUsR7h71aIGEf8e9/Ppmu/wrSYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Gary Guo <gary@garyguo.net>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0851/1815] dma-resv: Fix undefined symbol when CONFIG_DMA_SHARED_BUFFER is disabled
Date: Sat, 12 Sep 2026 08:43:21 +0200
Message-ID: <20260912065708.895990960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>

[ Upstream commit be809b60cbb61aab96179f44ac3670242ae72996 ]

When building with LLVM=1 for architectures like powerpc where
CONFIG_DMA_SHARED_BUFFER is not enabled, the build fails with:

  ld.lld: error: undefined symbol: dma_resv_reset_max_fences
  >>> referenced by helpers.c
  >>>               rust/helpers/helpers.o:(rust_helper_dma_resv_unlock)

The issue occurs because:
1. CONFIG_DEBUG_MUTEXES=y is enabled
2. CONFIG_DMA_SHARED_BUFFER is not enabled
3. dma_resv_reset_max_fences() is declared in the header when
   CONFIG_DEBUG_MUTEXES is set
4. But the function is only compiled in drivers/dma-buf/dma-resv.c,
   which is only built when CONFIG_DMA_SHARED_BUFFER is enabled
5. Rust helpers call dma_resv_unlock() which calls
   dma_resv_reset_max_fences(), causing an undefined symbol

Fix this by compiling `dma-resv.c` file only when CONFIG_DMA_SHARED_BUFFER
is enabled.

Fixes: 9b836641d3bf ("rust: helpers: Add bindings/wrappers for dma_resv_lock")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260708082454.1254320-3-mkchauras@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/helpers/helpers.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 998e31052e660..4b90a1390ad58 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -58,7 +58,9 @@
 #include "cred.c"
 #include "device.c"
 #include "dma.c"
+#ifdef CONFIG_DMA_SHARED_BUFFER
 #include "dma-resv.c"
+#endif
 #include "drm.c"
 #include "drm_gpuvm.c"
 #include "err.c"
-- 
2.53.0



