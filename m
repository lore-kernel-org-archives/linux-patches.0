Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3AC2FD1AD;
	Tue, 12 Aug 2025 18:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023995; cv=none; b=IAl4fKOxMgxH5bdju7AE9fDKX3eL/rwQ7IJjFSWc9TD4zvccz/UafFWJARs+QTWMZW6lNkzc3Djbdb0vd6IH786p/9BW75dw6Wl3XcjJoROVbwRb0r9q1GZ6e4q0Dprj9m/4Q7u/Ez7PXG7F24wBMDGC8dLXChgepZ6C7ssLC3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023995; c=relaxed/simple;
	bh=ft9X0iT4pXziygjuqS7K4KYZkV8ZGMqzorxi2T4J6qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZAQqp/h5oPN+uPpdF8NuLYKwlKO2a9Pm7E9a8HtwDKR/O4LD710qNpCzWfq+OOJQnnL6JJEPfSHZwf8SlOZ8VqmsJCO4Dfgz6dS4hXTT3UUEHaRG2wH6xtPBpbACbERl+g85K7ZAM9+HDa1TXViCzH9++VbKq2K0Crk4lipCpVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaZ3ijuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaZ3ijuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299F5C4CEF0;
	Tue, 12 Aug 2025 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023995;
	bh=ft9X0iT4pXziygjuqS7K4KYZkV8ZGMqzorxi2T4J6qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaZ3ijuJw+qx3BQ4kPoTv/eg5PNJ+/GxSOhdN6q9dxbBk11UzCB0NDMblO8ySLtcg
	 kt6GYi/lqNcsRPbXx0ynjFVjuF214IJKsuOmhYj262IQTNCjPoAhe8zK0CCW4G9B2w
	 r9moxk4iaoUxCP2asmEAWMyL92e1PeMdLftWRdlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mark Brown <broonie@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 209/627] spi: spi-nxp-fspi: Check return value of devm_mutex_init()
Date: Tue, 12 Aug 2025 19:28:24 +0200
Message-ID: <20250812173427.232941331@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit d24a54e032021cf381af3c3cf119cc5cf6b3c1be ]

devm_mutex_init() can fail. With CONFIG_DEBUG_MUTEXES=y the mutex will
be marked as unusable and trigger errors on usage.

Add the missed check.

Fixes: 48900813abd2 ("spi: spi-nxp-fspi: remove the goto in probe")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20250617-must_check-devm_mutex_init-v7-1-d9e449f4d224@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index e63c77e41823..f3d576505413 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1273,7 +1273,9 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to request irq\n");
 
-	devm_mutex_init(dev, &f->lock);
+	ret = devm_mutex_init(dev, &f->lock);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to initialize lock\n");
 
 	ctlr->bus_num = -1;
 	ctlr->num_chipselect = NXP_FSPI_MAX_CHIPSELECT;
-- 
2.39.5



