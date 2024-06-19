Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858A13DDC0;
	Wed, 19 Jun 2024 13:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804104; cv=none; b=nrYJiYCyYQTFyI3ot+rruNOXspno8K7sgtRrZOBp7UYpYxGu9BnfnvdGF8dJfjHpWrchKsJo79gfrwQHPl44N0DXqItZLmXr23eK+5QHZSN9ml+zkjhgBbtDbqvV63dQRz1dXWx3Ipwwcddihgi7uNqyW/nzNswFfRIiCPCtnRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804104; c=relaxed/simple;
	bh=rrFSRjiEnLcSD2hCtxHvzMJ592SRg0gh6YCszI/2Ny0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta6j3V6Pq9pwS1vanPsV2ZkGehBgEFKzAHYVokSD0/aP2P2Qx/1kfj44U73fkh2RaHc7jmjV/3b7gokyFReDSn5U/hPbByNy9v14Z3Ff6HJqQ9s2f5VcN8E5gD4jG091nRPVqHlHGSKLOcWbBiYU9t70Em7wzzzc9aPsdTPqe5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BE+PWuRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BE+PWuRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A769C2BBFC;
	Wed, 19 Jun 2024 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804104;
	bh=rrFSRjiEnLcSD2hCtxHvzMJ592SRg0gh6YCszI/2Ny0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BE+PWuRGNC8rHZ0LPXEjpRx7HgdQdVg/7VPtnK/oCLKfmkcWZqFBcmvgAln6Y9Mqd
	 kun9aLNLgkHpgwxaCj3UOxRkYIXXEfdEkdLrJT49rxSAzOMRugKZkOAZTiMMani5nd
	 g6gdOBGWureHgArUy/ABVqiljZlFJZIshgu9Ipew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/217] serial: 8250_dw: fall back to poll if theres no interrupt
Date: Wed, 19 Jun 2024 14:57:34 +0200
Message-ID: <20240619125604.835969995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 22130dae0533c474e4e0db930a88caa9b397d083 ]

When there's no irq(this can be due to various reasons, for example,
no irq from HW support, or we just want to use poll solution, and so
on), falling back to poll is still better than no support at all.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20230806092056.2467-3-jszhang@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 87d80bfbd577 ("serial: 8250_dw: Don't use struct dw8250_data outside of 8250_dw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 88035100b86c6..a1f2259cc9a98 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -523,7 +523,10 @@ static int dw8250_probe(struct platform_device *pdev)
 	if (!regs)
 		return dev_err_probe(dev, -EINVAL, "no registers defined\n");
 
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq_optional(pdev, 0);
+	/* no interrupt -> fall back to polling */
+	if (irq == -ENXIO)
+		irq = 0;
 	if (irq < 0)
 		return irq;
 
-- 
2.43.0



