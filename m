Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A793C79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4DFC433EF;
	Thu, 12 Jan 2023 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533335;
	bh=5fcVo2jlPcGzJpmhQKUWS+VtPDZqrjGN2kj90IqMvxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzEQ3Bg9BK9Y0faKBii6f354Yi4L6KgLNbm0aec8Nv1uWXabs4vvCIJIjrNBxOd09
	 iB3DKnTd93HL2uCqdlaRFFBjPaHlkiVNjNLAoLnDv6NEKxXLsiS/iN/HQv6Tso1k4l
	 R/UyZDsaVscsVszayb32II4+kf1Bv/xlFi8WfIG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 446/783] remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()
Date: Thu, 12 Jan 2023 14:52:42 +0100
Message-Id: <20230112135544.929324208@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index a26221a6f6c2..c348ea35e47c 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -625,7 +625,9 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
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
@@ -636,6 +638,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 		if (ret) {
 			dev_err(sysmon->dev,
 				"failed to acquire shutdown-ack IRQ\n");
+			kfree(sysmon);
 			return ERR_PTR(ret);
 		}
 	}
-- 
2.35.1



