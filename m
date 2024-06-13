Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A3E44C6F;
	Thu, 13 Jun 2024 12:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281760; cv=none; b=RtAb2HN3p6aaI4W6LFkCgnJTqcc4ud28VrMq9OMM9KS59l5V4yGsCOYdZkHLVbaIrttcvzoqOAWeK80Q2kUoXw0JVO+1K/1HyqmwkPoQNo1IoXVZpRy2zL+qbRH6NmrIrvtGJmIco21DL27WjiFfcPimWfOumP9GdBlKDdq7Bcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281760; c=relaxed/simple;
	bh=nRvszHWuxgosY8jgXtBZGYamIqK5l0ltiXadx43e3JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXuh3OdMwlDNnzmxgH9Ar3JzH3VMwfo9KNpKYM5Q6tkpVDWd4icVbzbFSxn1x9BMUhtGEx7zMLZEKKMfgZwrk0ALdbgwoKhLThMQLUNmdtVoXCMg/8QftRckuMQoQStJItlFVLIK6O+K6KJiehYNXAmdQnb9Fcs9OhDhaM4uEAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGdRpyFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGdRpyFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E8FC32786;
	Thu, 13 Jun 2024 12:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281760;
	bh=nRvszHWuxgosY8jgXtBZGYamIqK5l0ltiXadx43e3JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGdRpyFYzPlgd2vq1nBKge66UTrgAhzozB5osXSPPUrKAgL+GnPGg2HxR4FSBJmdh
	 wm1x0fsRHr96rAReDYmQ8PxtcqxylgiSGAtA5lnfF4U71zREJvfIVWsBHI6k9dw8aS
	 obLGSE/HairTRuzSOId+cjeNcJptkyuavG1PzIuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/402] crypto: x86/sha256-avx2 - add missing vzeroupper
Date: Thu, 13 Jun 2024 13:30:02 +0200
Message-ID: <20240613113303.895388979@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 57ce8a4e162599cf9adafef1f29763160a8e5564 ]

Since sha256_transform_rorx() uses ymm registers, execute vzeroupper
before returning from it.  This is necessary to avoid reducing the
performance of SSE code.

Fixes: d34a460092d8 ("crypto: sha256 - Optimized sha256 x86_64 routine using AVX2's RORX instructions")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha256-avx2-asm.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 9bcdbc47b8b4b..f7d7287768559 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -710,6 +710,7 @@ done_hash:
 	popq	%r13
 	popq	%r12
 	popq	%rbx
+	vzeroupper
 	RET
 SYM_FUNC_END(sha256_transform_rorx)
 
-- 
2.43.0



