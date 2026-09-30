Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF7F368D7C;
	Wed, 30 Sep 2026 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783238; cv=none; b=pfGQoQp2tAjl7rFQ5NI5U4UPfS0tEeZbcYSb/Ust600xYsledwguXpf+E37n1N7K7LciOoiqrIM8jYQo3dWbFWSs5S9RaLFL0qEnPM0uwyufoZVT3CxoOLd2jYtjwOYdhBiETMVyHDZ7gKtOMQZVshdMYxU9FVVMiHKmm2+PKhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783238; c=relaxed/simple;
	bh=5X8OKj10Ffzim4n0zWGIF4PYwSIYDDxtMLdktAOpgYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muGx9ic/PCuGBf3UOlw+9/RxSoSNQsSHleVeAH/dipygr2r9OjF+HLnlVH8WHCaXxrb21Lz3majrpcCij5GOw5qW5TcNoy3T1bECQyW8Cm55S7Sttr9iO6ZV/RQ+fuvHqxbF0geFGBu8MwbyTpRsYxrhp3g99t+Edcv8tBlRdRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhYVwNfe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhYVwNfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9F11F00898;
	Wed, 30 Sep 2026 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783234;
	bh=+Gf3Upneq0b0pUzqw9rloigkI/5IwtUVVi94blq6J7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhYVwNfekrxls4jq2sCwBcA5Xdwt/osuOYlV0EpF+HrwSJll0BsgCNP7UVDWQOUCV
	 7iAAdjXN2463xcDZmvlYmMd5kJp4/CFNPKkkzZRRDKOuGxqehWfOOF8bsmvy9/GbCn
	 qhA0ovlgD83UVYRfhNoC4sbGQwLPp79TMhYCq6BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 327/595] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Wed, 30 Sep 2026 17:23:40 +0200
Message-ID: <20260930152354.717314372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1248,6 +1248,7 @@ next_match:
 out:
 	if (i % 2)
 		scratch->map_index = !map_index;
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 	local_bh_enable();
 


