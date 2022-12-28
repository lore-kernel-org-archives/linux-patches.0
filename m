Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4BE1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98247C433D2;
	Wed, 28 Dec 2022 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238900;
	bh=ZYqwG6CouYo5NQ+O+G/OelmPsdWeAGd5u5KwGMjn3DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhyWnVtBf5v08M+u/2rLltlYa3Adfb4a8ocQrC7bofRrxOZQ94uG/bCfeldz1RaQ+
	 yUgSDoG+op+065v0lHTdC8IlTSc3srxbKiQHFZT4sE+R8V0jaSX0ACylGZdTr5mP/w
	 PG/ATxTRU6aZ9SBD8z+XZuTc8B3kyAqP4T6m2qpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/731] soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index
Date: Wed, 28 Dec 2022 15:32:12 +0100
Message-Id: <20221228144257.273920159@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 6d7860f5750d73da2fa1a1f6c9405058a593fa32 ]

As idr_alloc() and of_property_read_string_index() can return negative
numbers, it should be better to check the return value and deal with
the exception.
Therefore, it should be better to use goto statement to stop and return
error.

Fixes: 6adba21eb434 ("soc: qcom: Add APR bus driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221107014403.3606-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/apr.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index 5687653fabd5..173427bbf916 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -310,11 +310,19 @@ static int apr_add_device(struct device *dev, struct device_node *np,
 	adev->dev.driver = NULL;
 
 	spin_lock(&apr->svcs_lock);
-	idr_alloc(&apr->svcs_idr, svc, svc_id, svc_id + 1, GFP_ATOMIC);
+	ret = idr_alloc(&apr->svcs_idr, svc, svc_id, svc_id + 1, GFP_ATOMIC);
 	spin_unlock(&apr->svcs_lock);
+	if (ret < 0) {
+		dev_err(dev, "idr_alloc failed: %d\n", ret);
+		goto out;
+	}
 
-	of_property_read_string_index(np, "qcom,protection-domain",
-				      1, &adev->service_path);
+	ret = of_property_read_string_index(np, "qcom,protection-domain",
+					    1, &adev->service_path);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read second value of qcom,protection-domain\n");
+		goto out;
+	}
 
 	dev_info(dev, "Adding APR dev: %s\n", dev_name(&adev->dev));
 
@@ -324,6 +332,7 @@ static int apr_add_device(struct device *dev, struct device_node *np,
 		put_device(&adev->dev);
 	}
 
+out:
 	return ret;
 }
 
-- 
2.35.1



