Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DED1F130F;
	Tue,  3 Dec 2024 15:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239500; cv=none; b=I70/Br/CNJMdmF1x/gSzGeZ4i/WP20YHU41TgR+xFziMng7pJBZ6VeCTYgDw3bHkLYQw8NpJONC4bFjBGRHg+DknU0e9ygmTMK3D6WI8CcTV059ltFElyvYYM373mHjrBQMRiLY/hUjJ1eYQSvf7sas/glaWfiFEu5/WvJFx5nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239500; c=relaxed/simple;
	bh=6EnsEyT/6nEEJVYa6Iy3hd3FLcylkmK8iwc3sIUqTTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQTrMU8DHon27M/OJx6BwF3190XC5AQidJW5VY79S0dykbKxsaZ+0UI1h/3C/LWpklNOkeZnADldwVKowDIO2gl7C7UIJNOWuSGn7Jml6zk7Tv3+TuozHNYAv6N0vxS5IJGgrXhYsleHqGzfTe3Qvv3Hv+pe54CoPrEwr3JBeFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfZ0ALkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfZ0ALkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AE9C4CECF;
	Tue,  3 Dec 2024 15:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239500;
	bh=6EnsEyT/6nEEJVYa6Iy3hd3FLcylkmK8iwc3sIUqTTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfZ0ALkraKstqd0pAjs/xGPkIumv+hI68Kp+ygU/sH8PRLdIS2FX47D9wBRFW2ZoR
	 gQeVrA5n3FydwtorNjiEBIBJ+8cnd0o9tDZWGpE/Qy3JMuEW9Uxy3FQDg9n5dbmcJs
	 ZVXdMMdXnFGMapxNiJHnZH67x+7FfA0zVYMfiuAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 635/817] soc: qcom: socinfo: fix revision check in qcom_socinfo_probe()
Date: Tue,  3 Dec 2024 15:43:27 +0100
Message-ID: <20241203144020.728091568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>

commit 128fdbf36cddc2a901c4889ba1c89fa9f2643f2c upstream.

In success case, the revision holds a non-null pointer. The current
logic incorrectly returns an error for a non-null pointer, whereas
it should return an error for a null pointer.

The socinfo driver for IPQ9574 and IPQ5332 is currently broken,
resulting in the following error message
qcom-socinfo qcom-socinfo: probe with driver qcom-socinfo failed with
error -12

Add a null check for the revision to ensure it returns an error only in
failure case (null pointer).

Fixes: e694d2b5c58b ("soc: qcom: Add check devm_kasprintf() returned value")
Signed-off-by: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241016144852.2888679-1-quic_mmanikan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/socinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -782,7 +782,7 @@ static int qcom_socinfo_probe(struct pla
 	qs->attr.revision = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%u.%u",
 					   SOCINFO_MAJOR(le32_to_cpu(info->ver)),
 					   SOCINFO_MINOR(le32_to_cpu(info->ver)));
-	if (!qs->attr.soc_id || qs->attr.revision)
+	if (!qs->attr.soc_id || !qs->attr.revision)
 		return -ENOMEM;
 
 	if (offsetof(struct socinfo, serial_num) <= item_size) {


