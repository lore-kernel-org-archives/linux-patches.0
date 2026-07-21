Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B3544AB62;
	Tue, 21 Jul 2026 21:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670880; cv=none; b=glJzg6PUNymI+/4VGq+XulTMAYhDQngszwj5vD2Tb15KXfZk/k+XQQOKKDLBcCFeRFIGayPmHrqy7aKcPY/4yT4loK/XsyakOZKlPtDQYCxhEDp0sp8fNRPZ2EKgWrXWvVaimF2dEU9jsp+Y5JaF7NC3vjhB0rOzDa8JKZVxrzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670880; c=relaxed/simple;
	bh=9lRSYullpj0+wtnBKs6MGWJabBu6qhMqPR4/ofzMJyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss5gS0QVcfMUlESCdob9okTg1pN2FbsP82iCSfirxrpmFMuMb+x7tPuZ4OsF0eQPfdLI9pBjIgaJDvu1BqC6SoDGeIVQHFptDH+0zsMom3JRJ35vpciR1995zh+fp+BZgwSAfFyb1mWQFA3WG9dLij2axGeIfcBMv/+z7ju+lFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjB4MNVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjB4MNVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DF11F000E9;
	Tue, 21 Jul 2026 21:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670879;
	bh=Xq3V46oFG4gNmtxvkL9H3op4eVzKhW0TdBBmlUK6f1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjB4MNVO1q0Oje1wIFw8VeUl0Do6RUWjn8J4zpPUy9mIwnftzsTt60iv/Rq+2DqfS
	 ctb61rHjgLOp+UCEaQeFjvyh7z2nZMKTCWU0wOv+NXizgFDvjHLIRydHwiZC3Vka+q
	 t2xMYT3eQnZ9a5o57lcWX6H9VybQnPRUF8fwoYxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/843] slimbus: qcom-ngd-ctrl: Fix probe error path ordering
Date: Tue, 21 Jul 2026 17:14:05 +0200
Message-ID: <20260721152406.185706443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 2c22ff152d380ec3d3af099fa05d0ac5ca9b4c1e ]

qcom_slim_ngd_ctrl_probe() first registers the SSR callback then
allocates the PDR context, as such the error path needs to come in
opposite order to allow us to unroll each step.

Fixes: 16f14551d0df ("slimbus: qcom-ngd: cleanup in probe error path")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204421.116824-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 346cd7c8127065..0ee537576b8204 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1577,23 +1577,22 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 	if (IS_ERR(ctrl->pdr)) {
 		dev_err(dev, "Failed to init PDR handle\n");
 		ret = PTR_ERR(ctrl->pdr);
-		goto err_pdr_alloc;
+		goto err_unregister_ssr;
 	}
 
 	pds = pdr_add_lookup(ctrl->pdr, "avs/audio", "msm/adsp/audio_pd");
 	if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
 		ret = PTR_ERR(pds);
 		dev_err(dev, "pdr add lookup failed: %d\n", ret);
-		goto err_pdr_lookup;
+		goto err_pdr_release;
 	}
 
 	return of_qcom_slim_ngd_register(dev, ctrl);
 
-err_pdr_alloc:
-	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
-
-err_pdr_lookup:
+err_pdr_release:
 	pdr_handle_release(ctrl->pdr);
+err_unregister_ssr:
+	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
 
 	return ret;
 }
-- 
2.53.0



