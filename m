Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33AB1BA87E;
	Tue, 30 Jul 2024 15:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354749; cv=none; b=KtPqegi2iSiDoxBQf3vr93OH5zUkMQbDfC37S5mFagdkDz6OyG4qoavYcmowX+gGgJObJZXgo22mCzMHZnxnQSv89xLTafGnewlqaIkwq0WsY+6u9BfXQYtRq5g/izfiAIZniUBM9xZEIegioyRj4rxAmICwrffyJ+uMCgQRBsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354749; c=relaxed/simple;
	bh=s8nRa/fx1ZzeyRCaz0Dgjuu+uAHYKCSQrBq8MKC19P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inlPowXDetiWG90HI+QEZpFlRC6trKI6oh1nDlTgiouXVO/hwnqVoYZ9y2v5lkeW6faOzfKpbQCMTe/Vvi5R55fLYRKhgvIzWqyUpS94yJ34riXWLKU2oxzqgZSHkuzZWvu0TPZgjPuuF0RlKUUe9GgZ/O61dqsdiP14mW/ffjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItrwzzZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItrwzzZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00E1C32782;
	Tue, 30 Jul 2024 15:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354749;
	bh=s8nRa/fx1ZzeyRCaz0Dgjuu+uAHYKCSQrBq8MKC19P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItrwzzZs/rls2jzrnbUtn8s99OkJK12XRZblTFIX1WArt6GLomUyAMJpIhVWV+7Ri
	 6gb+ZAre06+dZjyXp9DvarwEWYIBeMQr5kpq5M/r6ot2KV2kUzyrQbmbs7GMrCDM8N
	 JPbbFwrlzT/5cDMh9TyAR0mewKYKjLrhdDlhKaN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 002/809] spi: atmel-quadspi: Add missing check for clk_prepare
Date: Tue, 30 Jul 2024 17:37:58 +0200
Message-ID: <20240730151724.747077192@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit ef901b38d3a4610c4067cd306c1a209f32e7ca31 ]

Add check for the return value of clk_prepare() and return the error if
it fails in order to catch the error.

Fixes: 4a2f83b7f780 ("spi: atmel-quadspi: add runtime pm support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://msgid.link/r/20240515084028.3210406-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 370c4d1572ed0..5aaff3bee1b78 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -756,8 +756,15 @@ static int __maybe_unused atmel_qspi_resume(struct device *dev)
 	struct atmel_qspi *aq = spi_controller_get_devdata(ctrl);
 	int ret;
 
-	clk_prepare(aq->pclk);
-	clk_prepare(aq->qspick);
+	ret = clk_prepare(aq->pclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare(aq->qspick);
+	if (ret) {
+		clk_unprepare(aq->pclk);
+		return ret;
+	}
 
 	ret = pm_runtime_force_resume(dev);
 	if (ret < 0)
-- 
2.43.0



