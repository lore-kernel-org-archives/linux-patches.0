Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0237867D;
	Mon,  8 Apr 2024 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581320; cv=none; b=DaMXaIpFg8sV5QjrHPFxII7CLJGrloWTh9PLGjyNVNQPnd5e1PSQdu6z6D347OHhCoQqCuF/TH2L6L+fDZ7o9ZYidocpcGPNcAiYuMU/bUbxYflN6nP4GW7ccr/ZYW01H1rr0JbS/x86xyks8Uqt7eXoute0Abg8bFTl0y0NnoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581320; c=relaxed/simple;
	bh=8Zf+nOSYXZtqjhz3RyWL9yCOGU1dHirKw45bo+IXEsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWF6wsw8S4M5urTLPHIVuzdN4m0qqyLUFJ0H2LRUNP0y15T8UE/G3wjS66fc9Z1MiRrFlzedlMg4hdOAanjhErxoZ/mYX+QaKKvF9TbPYe9X/xpn/r9IAZoIRjBpdcNcv3BultJCFmk4XxPZoJ23TSCFH0h76gJ74RiQAANnBOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svGk60Ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svGk60Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB574C433C7;
	Mon,  8 Apr 2024 13:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581320;
	bh=8Zf+nOSYXZtqjhz3RyWL9yCOGU1dHirKw45bo+IXEsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svGk60AdvFEN0jIJNF769EIaxk+mc8CETCWAD/fKVg0Gexu3Z8Hn3udHx7xnMm0+b
	 yAlpHTPQO55dD2DsYarSpAKnhHhTkJ8Dx+DjnuCZ6sYAv9JwAVuV21smz9l28e3iNe
	 n/z+2aR3boo05ZfuOlIV+F5cJ/SYVrAL6dps7mY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Sakharov <p.sakharov@ispras.ru>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/138] dma-buf: Fix NULL pointer dereference in sanitycheck()
Date: Mon,  8 Apr 2024 14:56:56 +0200
Message-ID: <20240408125256.298701236@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Sakharov <p.sakharov@ispras.ru>

[ Upstream commit 2295bd846765c766701e666ed2e4b35396be25e6 ]

If due to a memory allocation failure mock_chain() returns NULL, it is
passed to dma_fence_enable_sw_signaling() resulting in NULL pointer
dereference there.

Call dma_fence_enable_sw_signaling() only if mock_chain() succeeds.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d62c43a953ce ("dma-buf: Enable signaling on fence for selftests")
Signed-off-by: Pavel Sakharov <p.sakharov@ispras.ru>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240319231527.1821372-1-p.sakharov@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/st-dma-fence-chain.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/st-dma-fence-chain.c b/drivers/dma-buf/st-dma-fence-chain.c
index 0a9b099d05187..d90479d830fc3 100644
--- a/drivers/dma-buf/st-dma-fence-chain.c
+++ b/drivers/dma-buf/st-dma-fence-chain.c
@@ -84,11 +84,11 @@ static int sanitycheck(void *arg)
 		return -ENOMEM;
 
 	chain = mock_chain(NULL, f, 1);
-	if (!chain)
+	if (chain)
+		dma_fence_enable_sw_signaling(chain);
+	else
 		err = -ENOMEM;
 
-	dma_fence_enable_sw_signaling(chain);
-
 	dma_fence_signal(f);
 	dma_fence_put(f);
 
-- 
2.43.0



