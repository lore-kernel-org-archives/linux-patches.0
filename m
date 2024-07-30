Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8451B583C;
	Tue, 30 Jul 2024 15:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354743; cv=none; b=cueTKXxgp7A1ZjVb3C+xBHqQBYG552eFYGNRK+XnZlyWyYXz9JirqTf7DuxxVqcd9vhnJ711bRv8b9aQ9doSmsZ3IE/v4bNeI0E0k3rkWpKNwcm0QDM5XdfCv6dqokPwwF9meez6Sd2iKyd2m+3+SNFZHu5d7ziB8+duVoGIPgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354743; c=relaxed/simple;
	bh=NDoxv1BPL+9wX9JV6Rh2k2/qUlWN+OA9Ls6OZSBLH9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSL+YGUTmrUliU/fwRWiAtvGm+zxRmffc9G8F4Y7VjmV+r+mkxNRa30OTmsuyctS4UgH9pPLFRkCCXM2gpA0q1St3k+EfPatjAWrSx526dJ9c8H673nNr57Da/cNguvZdbU60QrrtccTqB/+/njZwcFTFOVcnwPVLZ3wHs+2i0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bO2kGbb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bO2kGbb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74041C32782;
	Tue, 30 Jul 2024 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354742;
	bh=NDoxv1BPL+9wX9JV6Rh2k2/qUlWN+OA9Ls6OZSBLH9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bO2kGbb0krjZZ3aiudyGJSFe1VlSJsCF+Gjcv5180Ky9Cn3w3rlFLgvqv0M716Uif
	 tzg5JPfxdx9Z7s3GNz0uHdTkTQkWmyazZ3/QqNqcRgP7KWN8YsA+Xd/n4yfXDHNyWX
	 aA17bVBdeVHfxdrDxxClrS+8RGwvsJ9GoG9j1fTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/440] spi: atmel-quadspi: Add missing check for clk_prepare
Date: Tue, 30 Jul 2024 17:43:55 +0200
Message-ID: <20240730151615.855354219@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 7e05b48dbd71c..1f1aee28b1f79 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -724,8 +724,15 @@ static int __maybe_unused atmel_qspi_resume(struct device *dev)
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



