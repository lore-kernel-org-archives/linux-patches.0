Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC2B221D93;
	Thu, 12 Dec 2024 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024614; cv=none; b=aBycT8NOp/9t4XWqnr0e7N7k8kWZFVfyXy6bkmDz9iP317yADhXsTtZ8g6bzwx6chNvTkn6Ns7Zi37R9DMMaOWhL4QqxLMDK8T6yoovbEr7TKgI+w1mxuCD8oy7LonPxdrMWSyPCEZG3ZzVwYxDHv6GylmFV3jQlpV32cRqoYIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024614; c=relaxed/simple;
	bh=nvA2XrCTtzG8ZxBqv2oSLS4VELMa9bNIlxfjNXIiT68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtTrCVx1N24zeRcsDCGpgHST7istxOKo9oCSeqouLqPM0vu69JkJWG91q1Csgc7et7hkE6wT1HqHPMy7TXamWgeNUKGKnePgl+RUs522g2VrDE4FlohtCJlgvYQQERkBWcxq3vY3mKN31IJqdcNVYS0uWM6D0TAHb8maL+YiNBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a123gz1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a123gz1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5BEC4CECE;
	Thu, 12 Dec 2024 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024614;
	bh=nvA2XrCTtzG8ZxBqv2oSLS4VELMa9bNIlxfjNXIiT68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a123gz1JsT4P49AB9lDVdTbMnsTpKm/5lm9SrN4Z/7h8I7FYIVs3aCwJK9mSJQVwj
	 ocbmJBjMo8xH6tB/3a/DDSOhDUjyjeUqcjl7+5zjC6orWyiDlRHiJ5SNrF9EL96iTE
	 DAJlLApnhtYbzS+1bv3W9QlMV4xi/nNJu5F2G62g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/459] spi: mpc52xx: Add cancel_work_sync before module remove
Date: Thu, 12 Dec 2024 16:01:33 +0100
Message-ID: <20241212144307.687457846@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 984836621aad98802d92c4a3047114cf518074c8 ]

If we remove the module which will call mpc52xx_spi_remove
it will free 'ms' through spi_unregister_controller.
while the work ms->work will be used. The sequence of operations
that may lead to a UAF bug.

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in mpc52xx_spi_remove.

Fixes: ca632f556697 ("spi: reorganize drivers")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/1f16f8ae0e50ca9adb1dc849bf2ac65a40c9ceb9.1732783000.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index ef2f24420460d..be99efafabbce 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -519,6 +519,7 @@ static int mpc52xx_spi_remove(struct platform_device *op)
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
 	int i;
 
+	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
-- 
2.43.0



