Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6BE1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58F9C433F0;
	Wed, 28 Dec 2022 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245039;
	bh=AJI6k/9Bs1e+aX6ppx/bBe1+BG7dZm6i6FA2mQ1gwcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xseF1uUmMFOWUQRDRnwOEEAEEkkJVdcgZOFd53ckY8PbNaq/8ZMwA7NvnteoD/B28
	 SH6tgZq5AXyTdlnlOzXUa1m0sI51ngzllA52ORjFobaPauUu7r7Y0DDEW52NqdQwQC
	 Qd1LSMnoY1hfuWvFx53GZVMV3dJFRBP5gfgaFiB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0820/1073] remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()
Date: Wed, 28 Dec 2022 15:40:08 +0100
Message-Id: <20221228144350.287030190@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 57dde2a69b9d..15af52f8499e 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -652,7 +652,9 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
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
@@ -663,6 +665,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 		if (ret) {
 			dev_err(sysmon->dev,
 				"failed to acquire shutdown-ack IRQ\n");
+			kfree(sysmon);
 			return ERR_PTR(ret);
 		}
 	}
-- 
2.35.1



