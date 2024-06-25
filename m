Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F021465A8;
	Tue, 25 Jun 2024 09:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308860; cv=none; b=DfRzymp86gBNHq247XnU9VEdWRmz2TkPIpqtccsUivhYIp3kITtYMkAXTqwCxyAmWwvO2scx/keq1TvRdkMDQJuHQasWvyJYe7k5046JBppBAb6rgktMWLy0DiN33YrezTz4XM4gD/nXM6FdBLtAul4xpjbTQlfwLFSsrwyv7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308860; c=relaxed/simple;
	bh=TAsHXDUqT8CHfmK/YR+FdROgVgfbfNXnjAKy78LSoJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDSesAsxfkaw9yTH/O5ATqKO6+7XSnQ7TLCBidqwN/PliS9vAP+eCwEydJUURevrh2unwl2oUKvMwBjr9ZSCVXKJIs5dcSba8vaUnA6pPG23ygfUWLtzcL8XsJv1+YCqi5j/H15fBtgCrt4upOr1Lyp59ChwDNbbl8C0Wc0WTkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lL/DGuqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lL/DGuqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F4EC32781;
	Tue, 25 Jun 2024 09:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308859;
	bh=TAsHXDUqT8CHfmK/YR+FdROgVgfbfNXnjAKy78LSoJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lL/DGuqAXXwDzXY2eLx4VBf4JKHAqhpKj+1KR21jN5NPS5mBYDG98RYgbMWhTCgmR
	 EuAJqvIsXc7TwzsdLO7Qm9bMpzKKqt1hSDhmT3/6JzMlFYL5JwoaKB7gBDES0nAuwy
	 BeNTAl0WYQjtcs1RgzS2kznY3QYRAyLF3TgfUFXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/192] crypto: hisilicon/qm - Add the err memory release process to qm uninit
Date: Tue, 25 Jun 2024 11:31:16 +0200
Message-ID: <20240625085537.324029507@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e889363ed978e..562df5c77c636 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2952,12 +2952,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
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



