Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509C719B3FF;
	Tue, 15 Oct 2024 11:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992974; cv=none; b=cS8/bBHMxl6ivnlobh08kA/vEk40jbIlrlof9gAJnEnyXN7s5M2CxcinuIbNY3MVfLkalSveSvA6SY7Mw4ryhp6XDCwtwB1owFom8k81vfuMOfN2GUek2ZFT0f+3oaeKwyyVWAI9/iUJKoXCK+s+onD+ULGMBXoUIngbW7ZRGhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992974; c=relaxed/simple;
	bh=9PgUsBZVfDBlqn9mRZvPxr3WBiv5S9Nkwf1P5D+SsBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWE27hzG9OPBhgMqbRWjPZ4TXtTj4LmoAOoluLRezLMih510mlEMYonpn6u5S7/wGtVRAvKkSZ33yUiPAmvB/71MUfJd3LkIQchCGpBKoHVsh2XNL/UDv+fAa+OJdx8Gt+RYUOCunGkLknpcllXVF1/alQkYZtIHQ4dua3CHlX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRkPFemu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRkPFemu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6BEC4CEC6;
	Tue, 15 Oct 2024 11:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992974;
	bh=9PgUsBZVfDBlqn9mRZvPxr3WBiv5S9Nkwf1P5D+SsBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRkPFemuXxsTXMozYG6rtQOKb58QhRwGO4rJhG51vgxP8UGhgooN/cMp4/H2WdBh0
	 MyHfjXzeCrjtWmiyS5DGV/uK/htgbgEwiMRT3B/Ja6o6aGGpdx7pMkAdOn04glgLZj
	 qjVIaIE1Q9eGYgJ5h1aSdsBkx1OxgB6DKhNNXgig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/691] spi: spi-fsl-lpspi: Undo runtime PM changes at driver exit time
Date: Tue, 15 Oct 2024 13:23:41 +0200
Message-ID: <20241015112451.181780633@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 3b577de206d52dbde9428664b6d823d35a803d75 ]

It's important to undo pm_runtime_use_autosuspend() with
pm_runtime_dont_use_autosuspend() at driver exit time unless driver
initially enabled pm_runtime with devm_pm_runtime_enable()
(which handles it for you).

Hence, call pm_runtime_dont_use_autosuspend() at driver exit time
to fix it.

Fixes: 944c01a889d9 ("spi: lpspi: enable runtime pm for lpspi")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240906021251.610462-1-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 314629b172281..b6674fb6c1d67 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -948,6 +948,7 @@ static int fsl_lpspi_remove(struct platform_device *pdev)
 
 	fsl_lpspi_dma_exit(controller);
 
+	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
 	pm_runtime_disable(fsl_lpspi->dev);
 	return 0;
 }
-- 
2.43.0



