Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBA1267F66;
	Tue, 25 Mar 2025 12:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905869; cv=none; b=T1bOOg0e8of6d7xaHnKjIi5dKnuchTRelfqaXdCGdBQ5EgM1tM4Ke1vM7nmh6pvQmoDBJSNzTu80EOVLLt+weGpvcldxpON/xs4SaMeUBTXOhbnKQbrSYxOoNzIltow3wTJ1DZK7qoaUttGae5MwSDh6uZMdmsfYUemsNU+vajY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905869; c=relaxed/simple;
	bh=C5PmZTvBIgtM/k0hacKkiCNvN0rXjMBNCD96NisFAUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbkP1vuJhSYupAJVn4StYlzpa5DEy5frUtitnzEw0A8BmBTSCH+Rk0zOwhaJtpxFmsqZxldUngQpPk5CSascIHAxv/gZYoya6tVtqvMuH9kZVqlSr4F7pV1deNZKSpMZwIa6R+l2DrxoPvKYNePHyPkFVjmaptKgW4mT7NegnfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3VZjxgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3VZjxgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745C7C4CEE4;
	Tue, 25 Mar 2025 12:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905868;
	bh=C5PmZTvBIgtM/k0hacKkiCNvN0rXjMBNCD96NisFAUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3VZjxgBaevdk4bpyRPVIIiHKjcqgX5v/903x/XKqAeKUnRc8Ej511cWAae+YE+el
	 5A9BsNYh9JBJHNAwBaKF6aBWRYOPN3P/JdC/XTGBAKt3nj7OTxnImRr4Zbwzou3Qoj
	 Yx2O7Ll2APYhw+IPEKvqQbz8jrFlBzJ4Ar3IhTPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 001/119] firmware: qcom: scm: Fix error code in probe()
Date: Tue, 25 Mar 2025 08:20:59 -0400
Message-ID: <20250325122149.099579711@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7f048b202333b967782a98aa21bb3354dc379bbf ]

Set the error code if devm_qcom_tzmem_pool_new() fails.  Don't return
success.

Fixes: 1e76b546e6fc ("firmware: qcom: scm: Cleanup global '__scm' on probe failures")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/a0845467-4f83-4070-ab1e-ff7e6764609f@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 959bc156f35f9..44e6885cdae86 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -2082,8 +2082,8 @@ static int qcom_scm_probe(struct platform_device *pdev)
 
 	__scm->mempool = devm_qcom_tzmem_pool_new(__scm->dev, &pool_config);
 	if (IS_ERR(__scm->mempool)) {
-		dev_err_probe(__scm->dev, PTR_ERR(__scm->mempool),
-			      "Failed to create the SCM memory pool\n");
+		ret = dev_err_probe(__scm->dev, PTR_ERR(__scm->mempool),
+				    "Failed to create the SCM memory pool\n");
 		goto err;
 	}
 
-- 
2.39.5



