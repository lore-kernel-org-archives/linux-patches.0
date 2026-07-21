Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A79B471264;
	Tue, 21 Jul 2026 18:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660222; cv=none; b=rP5JUlR9HeqBO0bjmmQ5u+aYq00Q0doTm9wKIAO2OadN/CsVIBTnnxQzxOpJ+54Am9DvjcE5dOwLXyhEUNTZrSEU2AJKqezwxblV24LblvI7m0jlH98Ju8+pIwIE7NwVin0a3TrkEYtBF5Hm3PBcF4myfQ3WqdgCHpUJ6whcrDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660222; c=relaxed/simple;
	bh=WdRxVKwGWidMn6Kl4DEkEnpk72YWotZ/paPW/O9UxgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLwK5avYDpSsvPI7VSt1XLZPe/aUYCGQfy2lgVjPulPE5qjzA2X3EmmjwKtohsxVBKEy4vVA/+ZUeL5/475P7Zt95oFSbft9SpvBDcM4k4AblfAUCfaJHtkt+0HRqh5mn46N4ZqkzAMZsqeHNkReJz3t974rNyqEIlcCPk48zIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxcHZdRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxcHZdRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B7F1F000E9;
	Tue, 21 Jul 2026 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660221;
	bh=Wqu6dtKwAKLFM8ECN/upSw0QUgUhP1U0a6xrQ0OJJHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxcHZdRKN/flfH7P3OjaVfwUfrZydrWTlQX4rdthwL4PRceVl2EmJxKJ+rS8z0GVZ
	 j7muxDQ1hsLGLY+2O1x5HyQyET9QhzLdHGKpTQqEhN7bMVJ/yuRjU2dquKo5LPe+NJ
	 gKbJDq3WlBjxGvASUUtI1qd1ECS3CQOAZOW9HPvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0898/2077] gpib: cb7210: Fix region leak when request_irq fails
Date: Tue, 21 Jul 2026 17:09:31 +0200
Message-ID: <20260721152614.000907002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 5ad28496055858166eb2268344c8fda2c26d3561 ]

When request_irq() fails, the region allocated by request_region()
is not released. Fix this by calling release_region() before returning.

  Smatch warning:
    drivers/gpib/cb7210/cb7210.c:1068 cb_isa_attach() warn: 'config->ibbase'
  from __request_region() not released on lines: 1064.

Fixes: 82e3508046f9 ("staging: gpib: cb7210 console messaging cleanup")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://patch.msgid.link/20260503093036.283546-1-zenghongling@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpib/cb7210/cb7210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpib/cb7210/cb7210.c b/drivers/gpib/cb7210/cb7210.c
index 6dd8637c5964b3..05058bf2cd50bc 100644
--- a/drivers/gpib/cb7210/cb7210.c
+++ b/drivers/gpib/cb7210/cb7210.c
@@ -1062,6 +1062,7 @@ static int cb_isa_attach(struct gpib_board *board, const struct gpib_board_confi
 	// install interrupt handler
 	if (request_irq(config->ibirq, cb7210_interrupt, isr_flags, DRV_NAME, board)) {
 		dev_err(board->gpib_dev, "failed to obtain IRQ %d\n", config->ibirq);
+		release_region(nec7210_iobase(cb_priv), cb7210_iosize);
 		return -EBUSY;
 	}
 	cb_priv->irq = config->ibirq;
-- 
2.53.0



