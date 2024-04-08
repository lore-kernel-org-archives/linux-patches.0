Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D0C2E62C;
	Mon,  8 Apr 2024 13:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581527; cv=none; b=C1/jYLIxwUW0Ubf09q7vM8hSUTmdtjcZa2S6ljUW4Rmpay08PtN7kqDyxz5gkPV2JkIkMWYrut/IjQZyt4lX1uFnrrCbyT/J5c2FkeENA8Iy3z62sk7oVmRALfjUVms29agVmbrl1zTTCaNm2LnLWWcXOFGLbo1Rpcit9Lqbk8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581527; c=relaxed/simple;
	bh=OqtFJB7z8G3BfQrbmVuM7QDgZee8QG0XRnhHw89Qd6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OpLSsKReuMEwHE/k7imjFwP/XHBCTOZ+z6J6B0qRxcOD3TaGVhmuT74tEtesc0GMvg50pdIZm6NSSEJlOrRkPV925t74gKazU5387KXcnfenpMnCS5TOQeAzgRYQjT+urEd7bzzah0D+lKtzKysnjTyW4NYhIJvIPAAJN6TiDyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgWlQoc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgWlQoc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED651C433C7;
	Mon,  8 Apr 2024 13:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581527;
	bh=OqtFJB7z8G3BfQrbmVuM7QDgZee8QG0XRnhHw89Qd6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgWlQoc0QOkrwDjArHIHPry4GBC+jtLqQ2IF/v0bOWMOsXWB+G3neZZgdA+X5hMOC
	 cGb1UUwiiUm+zR270wOWYPlZ8CaHg1gEkoBVn24gNjQHieC2BVhHrVx95nTsDKPwSM
	 eJSZZl/0U65b7v2BCyzV5jgAjsj+ojdzW6jAx6WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Sakharov <p.sakharov@ispras.ru>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/252] dma-buf: Fix NULL pointer dereference in sanitycheck()
Date: Mon,  8 Apr 2024 14:55:05 +0200
Message-ID: <20240408125306.844364559@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c0979c8049b5a..661de4add4c72 100644
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



