Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65DD39DBD4;
	Thu, 17 Sep 2026 18:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671378; cv=none; b=oYKFEHpDYBOrysFe5yCaZuq3qDR472mZ8ZWi5YkUP2bxo+KsAOOYVg3D6oIjZaSnSAp+o4aOeE3spy8n2Wd4Dm4q09bcF70qaBF7N7fA3hsiAHotU4rSmrs+hi3+fBTanwizWfw7C0e6hwq2B92rfrA+Br8euQUoKL2IrvLAUVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671378; c=relaxed/simple;
	bh=WgEcwZF54yoL7CD45h3NUaJ5UI5HxE4bP+cu7uAn9t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8xJJF/UYI2YkPH9TNPXe7dLad6bk0s93oq1icWC1LD9qlsJz5qFGeBPdMKZ+2BByNYHOA63qU6qsvxuieDrAuaBhy4HwgCGryvPfhOQl6HxoD3IxuvsJPZcZdDwHh7nNTsPLmJ2EYAUsQ32klxDGv9VsgckuSe+jrbmq+ghkXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U40e8d6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U40e8d6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C465B1F000FF;
	Thu, 17 Sep 2026 18:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671377;
	bh=vIN9I3lA0XrRxUmExk/xDO5PSrxXT2D2lcauXcsxWCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U40e8d6C6jjSohzdmzqAjhtIy3OxRCFftrXwkC2lfWWRhOzvNAmgPNlR4pZWvp1Pz
	 qLYKD2VRKYKjPfqRIDl5R+psBo+/ai/ylW5BQdbDEeUObz7DPDBEuaH9JMaFKPkvsh
	 hCiHdg2FsK29Zxy9AmGl69cyprFCwJyq+mEQ+/KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 0955/1102] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Thu, 17 Sep 2026 16:14:58 +0100
Message-ID: <20260917151604.636513893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 55dd20f0f4b1be5c9c8a0275d8d763c86563eac2 upstream.

Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
returning from it.  This is needed to avoid degrading the performance of
any later SSE code that may happen to be executed.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo_avx2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1262,6 +1262,7 @@ next_match:
 out:
 	if (i % 2)
 		scratch->map_index = !map_index;
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 	local_bh_enable();
 


