Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E4250E5BC;
	Wed, 30 Sep 2026 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785628; cv=none; b=R1YkzjUgq4GjGYAsWtsnJy56m3/jXMlrZ24cAqsAPcdQMR7di/nGe6KP8UGyLuf8SbpyxFtYObY5TwB1vDEyILmAh7XVu6lEsSAUXJBj1bVHmUVp7fX0gHXmjzJX1+xkzyf291Th8PFXzBBAzUMWoAiYNirv+OxAHtAFLC/b0rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785628; c=relaxed/simple;
	bh=Igr68NtEU6t6sMXD5E3gFrrKC3Frf0HOz4KOQkCP9Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDY8KNfbe9bjr6ot+xHZkMQuyHqHMYOgCSzif9dLTbzr32ANTY+11hnmAb7HWHAUw6LxakpnDaeKbORmA7t2N0J54eKe3wPJU+cILeZjOWdsNZAZVi7mveLdY0chges6gikC2U+Dp++sY4XjJb3md4LhBOg59vrSXylpC4pXLA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDFyWFDW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDFyWFDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482421F00899;
	Wed, 30 Sep 2026 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785619;
	bh=VZsMX8vycoXfQxvBH+ZvJh2H28zaFrhIdMIqFLveKV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDFyWFDWhz6bn9PNfwXg0uN0sY7OV4KvL2uND4pTEDLf7EJRkebIuYvdO+2pF6xIL
	 XjuB6STbeiMu0n9AFy2e4CiFTPNacdEEsYDouCG5sevd6aDaNg1uJF0Ghu5rdmteuI
	 1XUROgocTb0locAGO7wZofIeTU4TV04RAWwbI2/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 572/982] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Wed, 30 Sep 2026 17:21:48 +0200
Message-ID: <20260930152429.055295237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1261,6 +1261,7 @@ next_match:
 out:
 	if (i % 2)
 		scratch->map_index = !map_index;
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 	local_bh_enable();
 


