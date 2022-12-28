Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863E21C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A184C433EF;
	Wed, 28 Dec 2022 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244088;
	bh=i8cFz/NGR+W2QvY2ThVU4pXhFpj7i6kk3Z/AMLdP7Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbN7eVN/d4ok0juat544wNCVHCN5jVct2aLan9OrHP+JH0G3RRVTn1huxdC8eV5z9
	 2SJAC5SZLiam0A0TYDdRms6tsF6Ry3XYMlcmu3KEnXISIsgB0tIrzdUS4KtoOWhKAs
	 eKzjoDwbjMiJ1U9qCKQqksDnG644eAPzBGi+XgYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0576/1146] crypto: hisilicon/qm - re-enable communicate interrupt before notifying PF
Date: Wed, 28 Dec 2022 15:35:15 +0100
Message-Id: <20221228144345.818470993@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit ee1537fe3dd89860d0336563891f6cac707d0cb5 ]

After the device is reset, the VF needs to re-enable communication
interrupt before the VF sends restart complete message to the PF.
If the interrupt is re-enabled after the VF notifies the PF, the PF
may fail to send messages to the VF after receiving VF's restart
complete message.

Fixes: 760fe22cf5e9 ("crypto: hisilicon/qm - update reset flow")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c7e7fc49ec06..e5fefc466ac8 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5725,6 +5725,7 @@ static void qm_pf_reset_vf_done(struct hisi_qm *qm)
 		cmd = QM_VF_START_FAIL;
 	}
 
+	qm_cmd_init(qm);
 	ret = qm_ping_pf(qm, cmd);
 	if (ret)
 		dev_warn(&pdev->dev, "PF responds timeout in reset done!\n");
@@ -5786,7 +5787,6 @@ static void qm_pf_reset_vf_process(struct hisi_qm *qm,
 		goto err_get_status;
 
 	qm_pf_reset_vf_done(qm);
-	qm_cmd_init(qm);
 
 	dev_info(dev, "device reset done.\n");
 
-- 
2.35.1



