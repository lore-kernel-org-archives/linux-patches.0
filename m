Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7D8634E;
	Wed,  5 Feb 2025 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765539; cv=none; b=D92Ckp/ef77SPTBy2gvBfSjojatZtpqGpFFw+BOMsNcWmXdgxySokd9L1BnHWwp1YsBf7xcfU9Xa+EQolxdGq3manLjGLpEjmW0XlkivCr4X7uA/rHGJ8kRXkrYpuoAVfx0W2EiZwJQt8b3Wz+/M++3Go8HHOgtwmKxx79dFXF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765539; c=relaxed/simple;
	bh=fAhjMPsWq5toNTn1psgQUZzrLt+pZ+tLFb3fAVltPto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbnkaP1D52BlYXEub55LzrjGmy2WYJHEQKm77WOSyNaQERxzDFWqBYbO/HHqpBcyEL+jLdCP7l6SEqCIPH8e5dx+DjiLgPJ7ER800Vv5t0ZKGxJwjpEwpUAmYSksiJn1pRE52JbV8iwad94c9xw+XnJ7b+sOAAbtue5Rn+NQkWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTvuBkoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTvuBkoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36197C4CED1;
	Wed,  5 Feb 2025 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765538;
	bh=fAhjMPsWq5toNTn1psgQUZzrLt+pZ+tLFb3fAVltPto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTvuBkocXmwWePAe1/R1hKnVismrYiV0HbczxpxenOc7pNNQ7kjQrQkvkV0RL06YC
	 858WKG58H/FlmhHEv1B29cCthKdOfmaf0l5+luDponpeashVb7tPxD2sKQm2q50i5P
	 ZG5N+4IpqZs0bJ7yGAB/CTAoNB4A+n69yjqq2ot0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/393] of: reserved-memory: Do not make kmemleak ignore freed address
Date: Wed,  5 Feb 2025 14:43:15 +0100
Message-ID: <20250205134430.870406525@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 29091a52562bca4d6e678dd8f0085dac119d6a21 ]

early_init_dt_alloc_reserved_memory_arch() will free address @base when
suffers memblock_mark_nomap() error, but it still makes kmemleak ignore
the freed address @base via kmemleak_ignore_phys().

That is unnecessary, besides, also causes unnecessary warning messages:

kmemleak_ignore_phys()
 -> make_black_object()
    -> paint_ptr()
       -> kmemleak_warn() // warning message here.

Fix by avoiding kmemleak_ignore_phys() when suffer the error.

Fixes: 658aafc8139c ("memblock: exclude MEMBLOCK_NOMAP regions from kmemleak")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250109-of_core_fix-v4-10-db8a72415b8c@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 7ec94cfcbddb1..959f1808c240f 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -50,7 +50,8 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 			memblock_phys_free(base, size);
 	}
 
-	kmemleak_ignore_phys(base);
+	if (!err)
+		kmemleak_ignore_phys(base);
 
 	return err;
 }
-- 
2.39.5



