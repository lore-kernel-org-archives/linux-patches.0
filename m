Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0820F39FCE;
	Mon,  6 Jan 2025 15:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179148; cv=none; b=V+FjEViWRuY88ZS44wg+QH7D1pJWwl9vGZXxM+aU50t9+k1oLZvKoNQS0qVANhm2BJgYAyL9ZeE3/WYMdU06sCMsiZ0/JdbHhy5ZpZKtTs0udHMwIN7QA4y0yX6+EdU5IwATqe73nlYMVzIGqDC389gP93QqbwfzatLMPyuBZN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179148; c=relaxed/simple;
	bh=oXJa8OruSNOHXOZ9c/gQY9tUYHgdEfiRJub8irG4x+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2IDIznBN/rOHDncjfzQsKDLNcNW+gvDKMH2D79fxFp3vfoCITB/YrV8LmyAaTbg/TD0bc34nJN0cZbP/lhaaRf4aR597GaEDyd0ge0pZBfQ81aVb0pf4g35pgRJqs0Jegli97lo7qC7K/xliIddplH0tUJ67fznxa9UTX/QPPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ns2i2b9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ns2i2b9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BE6C4CED2;
	Mon,  6 Jan 2025 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179147;
	bh=oXJa8OruSNOHXOZ9c/gQY9tUYHgdEfiRJub8irG4x+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ns2i2b9+lfYqKz9urldRdKnsb3qd9idXxig5kt1prFX20TZsNQY2vvvO0hi9CkWnw
	 66GUwJJIIvXsEBovAaUG+0J5xXCmOATLXf4MtPNiPJ+V8jconY7JwJ6iNACdR3qB4o
	 7Zj57Hw1CpbgW0fXYMmGXrwhG/uvwTAyFE107Cdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 41/93] dmaengine: mv_xor: fix child node refcount handling in early exit
Date: Mon,  6 Jan 2025 16:17:17 +0100
Message-ID: <20250106151130.252193949@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 362f1bf98a3ecb5a2a4fcbdaa9718c8403beceb2 upstream.

The for_each_child_of_node() loop requires explicit calls to
of_node_put() to decrement the child's refcount upon early exits (break,
goto, return).

Add the missing calls in the two early exits before the goto
instructions.

Cc: stable@vger.kernel.org
Fixes: f7d12ef53ddf ("dma: mv_xor: add Device Tree binding")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241011-dma_mv_xor_of_node_put-v1-1-3c2de819f463@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/mv_xor.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1394,6 +1394,7 @@ static int mv_xor_probe(struct platform_
 			irq = irq_of_parse_and_map(np, 0);
 			if (!irq) {
 				ret = -ENODEV;
+				of_node_put(np);
 				goto err_channel_add;
 			}
 
@@ -1402,6 +1403,7 @@ static int mv_xor_probe(struct platform_
 			if (IS_ERR(chan)) {
 				ret = PTR_ERR(chan);
 				irq_dispose_mapping(irq);
+				of_node_put(np);
 				goto err_channel_add;
 			}
 


