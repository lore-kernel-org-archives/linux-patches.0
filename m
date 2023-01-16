Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9059E46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16876C433EF;
	Mon, 16 Jan 2023 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886253;
	bh=AOgJp2rz1eHJsmVjxa/9tV4yqO2H9rRxOebxHhWHsXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyvBrJbjQqBuRAB/gw/q4YGdsfUR4mcJK3HO/iRwFAvYx/odWWsq0sGz4hNWc8aY4
	 MSKr56c2ujxbUGi38zgU2UQUb9a270xXyA+cfDVK2H/EaZa4bYq/Ql9vpTy/Gzy+C0
	 oRoDJU4jLQWTvIDyG9PtmRC4KOquBm5C0YE0Voas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 361/658] remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()
Date: Mon, 16 Jan 2023 16:47:29 +0100
Message-Id: <20230116154926.104936230@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit e01ce676aaef3b13d02343d7e70f9637d93a3367 ]

The kfree() should be called when of_irq_get_byname() fails or
devm_request_threaded_irq() fails in qcom_add_sysmon_subdev(),
otherwise there will be a memory leak, so add kfree() to fix it.

Fixes: 027045a6e2b7 ("remoteproc: qcom: Add shutdown-ack irq")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221129105650.1539187-1-cuigaosheng1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_sysmon.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_sysmon.c b/drivers/remoteproc/qcom_sysmon.c
index c231314eab66..b7d0c35c5058 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -518,7 +518,9 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 		if (sysmon->shutdown_irq != -ENODATA) {
 			dev_err(sysmon->dev,
 				"failed to retrieve shutdown-ack IRQ\n");
-			return ERR_PTR(sysmon->shutdown_irq);
+			ret = sysmon->shutdown_irq;
+			kfree(sysmon);
+			return ERR_PTR(ret);
 		}
 	} else {
 		ret = devm_request_threaded_irq(sysmon->dev,
@@ -529,6 +531,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 		if (ret) {
 			dev_err(sysmon->dev,
 				"failed to acquire shutdown-ack IRQ\n");
+			kfree(sysmon);
 			return ERR_PTR(ret);
 		}
 	}
-- 
2.35.1



