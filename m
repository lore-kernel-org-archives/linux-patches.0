Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70581D174E;
	Wed,  2 Oct 2024 13:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877563; cv=none; b=nuoLJv3rmdnWLPPcYzKEki41wjNp2twSWhwItc6o3X0ZHNMMCXtkyhd2fu0kqkjBxs8A61b+GSlyd32hJD4hwNpYU8dpV3HvlFk16OLadvRXgZBUoapOA4hnz0EyEBncjNoAj0WBoQPvtmFb4OIduxG45vqG5legrXKi2lSF3QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877563; c=relaxed/simple;
	bh=rneXkBj5oNdIizqV+fCCNd1+42/CB7jCeq8aik1ZjkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVCL/bi35B2+Wj016wi7ycpL6l2sC9WJC7eAJzH+hIlyPX9FoIl6uY77Pu4qRU/apZRRATMXtj/vDsidyOvLeeVGDOoOUUhiiHdGeCQq2/c8/aB8Jtp6njCr0pfTKDbIihwwqm6LI0Te7ryhDIn0mACes7AwFfZIEB3+FjXHGFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTke5q8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTke5q8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC3AC4CEC2;
	Wed,  2 Oct 2024 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877563;
	bh=rneXkBj5oNdIizqV+fCCNd1+42/CB7jCeq8aik1ZjkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTke5q8gLWt70iTBpOUos1hZ609Dj+rgX4ypaaPGiDUV01Q2JdJ5hjVnn4D7Dt+71
	 XviA7znTotyI1Mugpfn6HxNToP+l8zW0zkgsuvclufA4hoeLKGu0k6pYu9lSwgluRv
	 57lHdEbnE6A8G59WT1fyai7QCnSy5H+ijIJ2nArM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 117/634] spi: ppc4xx: handle irq_of_parse_and_map() errors
Date: Wed,  2 Oct 2024 14:53:37 +0200
Message-ID: <20241002125815.731375656@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 0f245463b01ea254ae90e1d0389e90b0e7d8dc75 ]

Zero and negative number is not a valid IRQ for in-kernel code and the
irq_of_parse_and_map() function returns zero on error.  So this check for
valid IRQs should only accept values > 0.

Fixes: 44dab88e7cc9 ("spi: add spi_ppc4xx driver")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20240724084047.1506084-1-make24@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ppc4xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 942c3117ab3a9..01fdecbf132d6 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -413,6 +413,9 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
 
 	/* Request IRQ */
 	hw->irqnum = irq_of_parse_and_map(np, 0);
+	if (hw->irqnum <= 0)
+		goto free_host;
+
 	ret = request_irq(hw->irqnum, spi_ppc4xx_int,
 			  0, "spi_ppc4xx_of", (void *)hw);
 	if (ret) {
-- 
2.43.0



