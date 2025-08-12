Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1822FA0F9;
	Tue, 12 Aug 2025 18:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023570; cv=none; b=m5obR6n5D813Wf1SXXTR/6HsB9D3uZz0NlreQJiJCF8fkxrvNI9pyVb33Ct9yztXT9o0bK6+ZOk0Uewz3Z8t+zLQm7XfaNLKUzRpywZPAkb8kW1Mukue7awhkTgrRRb5IwGn+3/BASl4apXmFOBR4KfZxI0T3sKux6GhnpaZ62g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023570; c=relaxed/simple;
	bh=3YEg6M3P/y5fqFpDtL1JjFCes+EoqTKuJUhuq0yVWG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdArZAo0KQlYniIqXjbIGb8lo5kS7xgdQAR2NohH+q30xoVkreb9D5OILbX0shpSUnHFyYXMH4hQMEH+DyU4Qd2imVTIXJYPJjInyd2xuL/eJ6rWSnvnBk3Rlekn4A0VqMBpdtA03tdHLhkhW0+5be4X91diVgU4eBR00LT0NRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pr1OIvAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pr1OIvAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A998EC4CEF0;
	Tue, 12 Aug 2025 18:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023570;
	bh=3YEg6M3P/y5fqFpDtL1JjFCes+EoqTKuJUhuq0yVWG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pr1OIvASkE8l6yXttx1BDxdWWsfqvLt4hMTBshmv9cGGVcoMEcHCxIZ9vAfpApgEA
	 Teq3MImqgp1RW2Hy0QNX2RGwbhxrsqtstlufVpUhU5MxVDwAPminWJkcsAXiCLe3yJ
	 OLLTWuylbw9BCW7Sth0oubjsf4ypKkJdO2ATFG6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 118/627] soc: qcom: pmic_glink: fix OF node leak
Date: Tue, 12 Aug 2025 19:26:53 +0200
Message-ID: <20250812173423.804945656@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 65702c3d293e45d3cac5e4e175296a9c90404326 ]

Make sure to drop the OF node reference taken when registering the
auxiliary devices when the devices are later released.

Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Cc: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250708085717.15922-1-johan@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/pmic_glink.c b/drivers/soc/qcom/pmic_glink.c
index 0a6d325b195c..c0a4be5df926 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -167,7 +167,10 @@ static int pmic_glink_rpmsg_callback(struct rpmsg_device *rpdev, void *data,
 	return 0;
 }
 
-static void pmic_glink_aux_release(struct device *dev) {}
+static void pmic_glink_aux_release(struct device *dev)
+{
+	of_node_put(dev->of_node);
+}
 
 static int pmic_glink_add_aux_device(struct pmic_glink *pg,
 				     struct auxiliary_device *aux,
@@ -181,8 +184,10 @@ static int pmic_glink_add_aux_device(struct pmic_glink *pg,
 	aux->dev.release = pmic_glink_aux_release;
 	device_set_of_node_from_dev(&aux->dev, parent);
 	ret = auxiliary_device_init(aux);
-	if (ret)
+	if (ret) {
+		of_node_put(aux->dev.of_node);
 		return ret;
+	}
 
 	ret = auxiliary_device_add(aux);
 	if (ret)
-- 
2.39.5



