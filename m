Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A8730CD89;
	Mon, 13 Oct 2025 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369905; cv=none; b=VCsPLjjgoxYbF8DUEMFCC3fs5v50ZpyVdnLOdWPibb5AGS5n2sJaa0LwK219jWUsvURaIo1hGHVEf1DsxIEw9kipmAXsIoaL44U+7zPYkYHOzTqRjXyPBz/zUA6/t/iTv/TE2XbKjUAcvARIxJq6ne/HCVLqh34hyxN0MfTdorE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369905; c=relaxed/simple;
	bh=A/kwqM9bf23Qg22w29LzPkc9R1c0MwyMHvIQsGw460U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oV/yTwf7No/mnW+2gVh2e1U/+lk1NU0qw07A6+TfLkFttCjX2tpXjt/NapHT06GhPeLkpUURFABJqoGc1TNi9xxGPyBCayPSTfBvZLPnbAqHIGUB09ujKTFJ7jLhY0mEiQxFcBAqoprLaT1wyO4AcC1BsoaGiyrXHp9/IGuZMHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhRKqv81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhRKqv81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D1BC116B1;
	Mon, 13 Oct 2025 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369904;
	bh=A/kwqM9bf23Qg22w29LzPkc9R1c0MwyMHvIQsGw460U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhRKqv81FXi46br5F+vMAEAua+79bBJvtX/m0xsfpUixARti9L+qfbiK8NrNV1fzA
	 RCYQZLJc/HrodGHzjVW15SCI66mQIRit1HMu9+HyvJJMfY0EuNr5yth16HsqM7D8BO
	 pxy62Bi0HQDQW+h84gy6/5gJ24heJYF5SRCyhb7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 408/563] crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs
Date: Mon, 13 Oct 2025 16:44:29 +0200
Message-ID: <20251013144426.067789313@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit f0cafb02de883b3b413d34eb079c9680782a9cc1 ]

When the initialization of qm->debug.acc_diff_reg fails,
the probe process does not exit. However, after qm->debug.qm_diff_regs is
freed, it is not set to NULL. This can lead to a double free when the
remove process attempts to free it again. Therefore, qm->debug.qm_diff_regs
should be set to NULL after it is freed.

Fixes: 8be091338971 ("crypto: hisilicon/debugfs - Fix debugfs uninit process issue")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index 45e130b901eb5..17eb236e9ee4d 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -888,6 +888,7 @@ static int qm_diff_regs_init(struct hisi_qm *qm,
 		dfx_regs_uninit(qm, qm->debug.qm_diff_regs, ARRAY_SIZE(qm_diff_regs));
 		ret = PTR_ERR(qm->debug.acc_diff_regs);
 		qm->debug.acc_diff_regs = NULL;
+		qm->debug.qm_diff_regs = NULL;
 		return ret;
 	}
 
-- 
2.51.0



