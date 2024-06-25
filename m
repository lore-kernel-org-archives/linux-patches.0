Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9E7FBEF;
	Tue, 25 Jun 2024 09:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308165; cv=none; b=drvUEfn8J7qfzkMky91FWcvLhL2tnztN72ZXhPLsFe1zRg8YMHTf2WIv0tCNXPb+KZlvPx+Q5XfVM4crHInq9hsNuklxVK6B4Av8rE+WQgmr/uEfo82132gyCYOido5uWBzxoHCeQd8FeLK3kUrJYY0KD8LEAMCtkuaSUP2nf/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308165; c=relaxed/simple;
	bh=A07In+00EDxvLx5GFt8ux2oZmumpyIOz/qh1spdWWzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rl2fzLLR7/MqU+EVeQCFM6l7oVDv8TuTng6IpLQem/8TsXnxSX18WPNydPq97ptYeAL58KNy/N8YwoC8udVE+X91pvihiVMIsT6IWHSba9McyP7urZcogpS4wY8kn4mpyMqPPfoBJbL11cJBU2yafm1lVPIK84/lT6Lho8CvSwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXmHE6uY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXmHE6uY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DCFC32781;
	Tue, 25 Jun 2024 09:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308164;
	bh=A07In+00EDxvLx5GFt8ux2oZmumpyIOz/qh1spdWWzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXmHE6uYBU0S5akUtLrAsOna7J1bi2/kgnLN7Jm8zeMQETsFeCvlyqei6uitQ1aMs
	 f3AcXli7bmOOGcEa5usIqNrKGFWLqRQpBjwSVtiXr+Soo2QiTdDUU7z5guNl2WxqA2
	 I4TrXZazqIbeZczh8TLqoxFQb8m/dvD3L7VckQEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 004/250] crypto: hisilicon/qm - Add the err memory release process to qm uninit
Date: Tue, 25 Jun 2024 11:29:22 +0200
Message-ID: <20240625085548.208463556@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit c9ccfd5e0ff0dd929ce86d1b5f3c6a414110947a ]

When the qm uninit command is executed, the err data needs to
be released to prevent memory leakage. The error information
release operation and uacce_remove are integrated in
qm_remove_uacce.

So add the qm_remove_uacce to qm uninit to avoid err memory
leakage.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 92f0a1d9b4a6b..13e413533f082 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2893,12 +2893,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	hisi_qm_set_state(qm, QM_NOT_READY);
 	up_write(&qm->qps_lock);
 
+	qm_remove_uacce(qm);
 	qm_irqs_unregister(qm);
 	hisi_qm_pci_uninit(qm);
-	if (qm->use_sva) {
-		uacce_remove(qm->uacce);
-		qm->uacce = NULL;
-	}
 }
 EXPORT_SYMBOL_GPL(hisi_qm_uninit);
 
-- 
2.43.0



