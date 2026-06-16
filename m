Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E443C6A2B;
	Tue, 16 Jun 2026 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626173; cv=none; b=GpKAoO8YU2m+PZo2gfTBpDuislnHHDi0dlURkzETIBHbOQ+vzYXEV0XFOwXUpL1wQi0fGtOUvK/qLtajZBSKVjlwHo7gyAW8tmrxNapr52o4j4H0T2DGbUqQWYHKILB3HTjWlY0nKoiDNkcNoljxwtu+G26pW1NvNhlRHX6e9/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626173; c=relaxed/simple;
	bh=zRAKgiSODwI7RCpuICPwdBGLjV7Xbz2Nu8SH/1q5sMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnkMpLl0BWb1jiCXV7QwzCxs4oJC5M6Wom0KStKYuicJjH2Kwj7hixeTW3b0qgztqyMNc4alXMV2TsHEY9/0rUEF5OxHsDJSvp+uinb23Mayt6UY2wMI3gMPWZPEs+Os2NNr6NK25rmW+32K0C7tVMG3J6lQzAHJaOFVurGQAxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOhD+ayS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOhD+ayS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCFA1F000E9;
	Tue, 16 Jun 2026 16:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626172;
	bh=80elVvSWK2mUq0+yoyF6w0zEmTrKTUutAIgA4Hx2xUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UOhD+aySRJK6ss+voohTdpaQNNo/sTR6psKiQdkeSGnKLlqt7clQ5fDnUZ8/WW/3J
	 h/p8Bpo4qnSj3huYpykZMAmlW1DlREkxZIxQCyPKw7rt53F53q67PUV9BHpvmrJNMj
	 0dGqQ2tOVv6YMS8i261+JczxX+HTMdOFhgKFEbUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.18 276/325] slimbus: qcom-ngd-ctrl: Fix probe error path ordering
Date: Tue, 16 Jun 2026 20:31:12 +0530
Message-ID: <20260616145112.474656681@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

commit 2c22ff152d380ec3d3af099fa05d0ac5ca9b4c1e upstream.

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
---
 drivers/slimbus/qcom-ngd-ctrl.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1666,22 +1666,21 @@ static int qcom_slim_ngd_ctrl_probe(stru
 	if (IS_ERR(ctrl->pdr)) {
 		ret = dev_err_probe(dev, PTR_ERR(ctrl->pdr),
 				    "Failed to init PDR handle\n");
-		goto err_pdr_alloc;
+		goto err_unregister_ssr;
 	}
 
 	pds = pdr_add_lookup(ctrl->pdr, "avs/audio", "msm/adsp/audio_pd");
 	if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
 		ret = dev_err_probe(dev, PTR_ERR(pds), "pdr add lookup failed\n");
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


