Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0213F1DE2A1;
	Mon,  6 Jan 2025 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178332; cv=none; b=ZZV7QKTSyGmQKRbFD3Lg+PKmoQbQiIbCZY0KMH5p4cYHhcrpRWJXkjtRtjZ9qiFO41R1qy9BwQuSYrv/Do1OJJ2ZKQ6HZT/yP3+mymWt3uh0PNCEAerwNNSWy3hm+OCrpysYZ595FGbWj0GH+YuabrdksODxfskmvzmc5qpIL/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178332; c=relaxed/simple;
	bh=8hBZbDrfU6JLcmBkIpfOOFuadFGjiIEqRdRNpauqWkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCPrQfUeTUc9MWOoKTOcjSnPNTSIOAbgfIAIXukMOx+0nb0UPRSTSVaYZd9vWtqDubBLHoWhks0KjTxnx4226cDQqSd2oeDlPaZ9lR+67CXMuV7tlevRqW55XPdz9aP+gCjoyA4hc5QAQEbectcD2H4xURUfeGJqu/ccnUvPEeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMwlYKJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMwlYKJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4A6C4CED2;
	Mon,  6 Jan 2025 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178331;
	bh=8hBZbDrfU6JLcmBkIpfOOFuadFGjiIEqRdRNpauqWkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMwlYKJ7dqP2CkoRhCE2uFhDp7hZzOPaLmTSYtl+tqwubDdYFMJkPi6qOgjoclA7n
	 BF0EglXDJZX0KmM80wvkk6xS4B+R7eDiaXTCKizk4wPxK7h8gMHBuFfJSkl0BFlkDx
	 ys34XijL1F3OQNxiIR86ibPcbwexzWh/reusLsHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 055/138] dmaengine: mv_xor: fix child node refcount handling in early exit
Date: Mon,  6 Jan 2025 16:16:19 +0100
Message-ID: <20250106151135.318335573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1393,6 +1393,7 @@ static int mv_xor_probe(struct platform_
 			irq = irq_of_parse_and_map(np, 0);
 			if (!irq) {
 				ret = -ENODEV;
+				of_node_put(np);
 				goto err_channel_add;
 			}
 
@@ -1401,6 +1402,7 @@ static int mv_xor_probe(struct platform_
 			if (IS_ERR(chan)) {
 				ret = PTR_ERR(chan);
 				irq_dispose_mapping(irq);
+				of_node_put(np);
 				goto err_channel_add;
 			}
 


