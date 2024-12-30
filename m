Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0E215E8B;
	Mon, 30 Dec 2024 15:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573743; cv=none; b=lmeEaKVq7nL8iKykAvRn3RC2khwbs6Y2G3HrJtr6E8qtxBmoKnNrjKskBrdgX6pXNXiTqrueruG4w4XBTx70JCneDL/wa5BYB1L+K4sALYcbFj/T5SH64NQyO9cWq/J9e7bhbywXP3ez5/sXXBxCmkBAM9dk2KzVvHGRPesrpkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573743; c=relaxed/simple;
	bh=SUuvflWxDFaFLKVUtUa6jJv7PsW5QlqQAkqwcYWd5hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaG7VXEX8naWRHsg8O7+ZmxmjamecMIJ7J9vphIewfmrUWkCpJcKT8u7DHM6WCc4WRkLaGbSPhylHu8fBS4UoX1a2GM2QKS7IoEVOHco55QeVxrIoVnROyJ/8C49LAGIjTv9FWsJM+0c0FqJ5D0AZbtrZiYlUlrKDbs/Uie0Agc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbknWu2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbknWu2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F45C4CED0;
	Mon, 30 Dec 2024 15:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573743;
	bh=SUuvflWxDFaFLKVUtUa6jJv7PsW5QlqQAkqwcYWd5hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbknWu2V0OM3VbFFEIoOeFjjp3llZg5CZqGQzUPYmZP0yWjzbX6wXP2MWB6S5m+Ko
	 F5QaY/GHdCfs4iJ3KP4OqvsyKJgKxuJcZj2R+T2YqW0cNRB4MsPuJMC5SmLDm1/ghi
	 0TxtuE2M40snqsYAcGY0HlNzvaS0xf7arh8F8kjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 22/86] dmaengine: mv_xor: fix child node refcount handling in early exit
Date: Mon, 30 Dec 2024 16:42:30 +0100
Message-ID: <20241230154212.566619182@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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
 


