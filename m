Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF3113E204;
	Tue, 23 Jan 2024 01:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971994; cv=none; b=kunl2/WhpPkdPVbdFO0/zaPmABlOutdVsd7IFjF65lafJ+rfpSFwwSZjfU238JOeHtG9Z4/QHhGj1zQ8zGTtZVwNYcvGlApi/8I+jX5qtGrK8KsJ7UMHnYi2qLuhxUrUb3uszIaUx6U8dXX/rKz14jpyNEvsKeVNlgfjH+YUnUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971994; c=relaxed/simple;
	bh=NEmR8+tGgaUe+Zvo1EhU6y2pggOS5Y4kT50/9EMdNkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWdElkkIvrX/tSHVrGhX9hkzph3lSajVjkymS7brzYkimZlv9N67jIkf7UivwpUfFmLdGU/MrjRe7ZfrEubf7BV7lx7ve5AysXMfJnEuf0I7XheEKqfppGA94LOIXMffo2iREKEyrdQvYdF4lSyTNgWdn54eB7usZJNMb5mBWSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYrUixxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYrUixxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E7BC433F1;
	Tue, 23 Jan 2024 01:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971994;
	bh=NEmR8+tGgaUe+Zvo1EhU6y2pggOS5Y4kT50/9EMdNkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYrUixxL+6ggjK7eJBWn8IFJIUU7fOBgOkTZlDLZAZBlSjMvDMnrOgkTQ8Tqv0vCR
	 1W+ONBwxeXq0OXez5iSE5f7kHD3nQGqXDFx7ofkOvEIOEbRIm6vEZpFj6+j8Zq8UEq
	 ied+ae/vdOST4Kda+1y57x07zf8OSlHa5c7MTanA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Chanho Park <chanho61.park@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/286] i2c: s3c24xx: fix read transfers in polling mode
Date: Mon, 22 Jan 2024 15:59:51 -0800
Message-ID: <20240122235743.030995138@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 0d9cf23ed55d7ba3ab26d617a3ae507863674c8f ]

To properly handle read transfers in polling mode, no waiting for the ACK
state is needed as it will never come. Just wait a bit to ensure start
state is on the bus and continue processing next bytes.

Fixes: 117053f77a5a ("i2c: s3c2410: Add polling mode support")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-s3c2410.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 05831848b7bf..687588834fc8 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -223,8 +223,17 @@ static bool is_ack(struct s3c24xx_i2c *i2c)
 	int tries;
 
 	for (tries = 50; tries; --tries) {
-		if (readl(i2c->regs + S3C2410_IICCON)
-			& S3C2410_IICCON_IRQPEND) {
+		unsigned long tmp = readl(i2c->regs + S3C2410_IICCON);
+
+		if (!(tmp & S3C2410_IICCON_ACKEN)) {
+			/*
+			 * Wait a bit for the bus to stabilize,
+			 * delay estimated experimentally.
+			 */
+			usleep_range(100, 200);
+			return true;
+		}
+		if (tmp & S3C2410_IICCON_IRQPEND) {
 			if (!(readl(i2c->regs + S3C2410_IICSTAT)
 				& S3C2410_IICSTAT_LASTBIT))
 				return true;
-- 
2.43.0



