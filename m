Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FF9314D14;
	Mon, 13 Oct 2025 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367252; cv=none; b=iWAvghD+ABYQfdalDEyZ1J9dNBtYxV5PV4E3/6dznJZYaSgDUuGelkK8ZgdiZ3h3WcPPT8NCyrlUrAHRooBTWx3mpioWDVseLEzF+R84r7OgTcF+DQ2q7+Vr6J5p9YVuIvRzu7lQRfU7zrirMNdFT3y20ZYKp5tPwzamNUoFKfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367252; c=relaxed/simple;
	bh=b3X0uHSg21ZW2VUFc3VLSjsDPljx1AGJ51fsvjHisy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNzHEERn7I5N5K60mXFSq+hwoEPqPaQTi+59JwwU5U6Aj/7TvJA4jYD461m6oVIFxqHtwQc8OEmkptL0v73GhV3y2RaPOz4Hxp9Lvac8C1VL48GfyeH9YWScPfxV6mSBtYJIRx+X/kjoxlSH0H4EeDmN5Hl7bmXBWOja9HLZiZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSBh7ATP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSBh7ATP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCEAC4CEE7;
	Mon, 13 Oct 2025 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367252;
	bh=b3X0uHSg21ZW2VUFc3VLSjsDPljx1AGJ51fsvjHisy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSBh7ATPLb6DxLOGccDfwZ0bmwKS+QyWqi+KdKPrMjUYv8Q2wZ9AFsSpCKMCWvQ5B
	 haJcIzXWpE4LVsTzi7kivtcHm52FV8EThj6/ErHSgluN58YILymh7l87+yDxwqhQlH
	 NOLQf1/S9gRB1tjV4JXePp0O/T7iOzxBHCaBrw/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/196] crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs
Date: Mon, 13 Oct 2025 16:45:17 +0200
Message-ID: <20251013144319.908160890@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a1d41ee39816b..cb27a44671ca1 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -815,6 +815,7 @@ static int qm_diff_regs_init(struct hisi_qm *qm,
 		dfx_regs_uninit(qm, qm->debug.qm_diff_regs, ARRAY_SIZE(qm_diff_regs));
 		ret = PTR_ERR(qm->debug.acc_diff_regs);
 		qm->debug.acc_diff_regs = NULL;
+		qm->debug.qm_diff_regs = NULL;
 		return ret;
 	}
 
-- 
2.51.0



