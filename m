Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC724A8430;
	Wed, 30 Sep 2026 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791869; cv=none; b=XvYsB+3jdf7W1qI4RjHlYE6BHY84fP6wLC3pGFvhtoyplKcZSJ1FmTXD8VKSFUFU2raho2AIKA5eNsiFQIBR5Gg9IiWhsrE7Zo1KirUhHCoI4WiBJkNgrspcJEeDeV2eIFCqSl6ZEQR2HZh0nAz8Lcd2yDAyjqhVv7aISU/HZQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791869; c=relaxed/simple;
	bh=IqdHX/LWxB5As4AtYgt0zS9UFunWNjCoCRo5fhAC/Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtVw3Oi5pr7NY0XbrDvNXRJHe6EJz46QmVGaDmwLFrI4+QR8e/tGdyrZj0t9rLxWTt8hrWy8W9C7hkXDN0wmWK4qPoJzBOs25kgVEBZDlAWIx/x7dgnh4Zjbh/Ee1WlO2695AMQu7teTfgFvauh7RSwFimV3vRcJdt0x3PW8OEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=horUBsxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="horUBsxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970FD1F000FF;
	Wed, 30 Sep 2026 18:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791868;
	bh=5Tq4wpsVgTFWf+9mYhD4vgseSTNm8ZG8Tc0GOJTvJKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=horUBsxRxfLTfx8kBX0WmiI/reDgUoIzbvkzHn4K8T/AP2xz5XscDMYGZp1l4BGH3
	 IPnHnXwHFwW4Rf0XrqEpTUuPvydZMx+n+sZZfUPqIz5U/OcLIOyNUBWvTSd5JlZ2VG
	 wCrhYwF4xa4RHgI4lsnw6areNhS/c73L06+8sSMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 417/752] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Wed, 30 Sep 2026 17:24:47 +0200
Message-ID: <20260930152407.305400822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1263,6 +1263,7 @@ next_match:
 out:
 	if (i % 2)
 		scratch->map_index = !map_index;
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 	local_bh_enable();
 


