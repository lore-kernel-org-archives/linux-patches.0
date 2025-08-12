Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6820F26FA77;
	Tue, 12 Aug 2025 19:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025600; cv=none; b=AML1AtlqDz/Nmk2/cMq/qMTjTWF962La5zAT381mDVknNEhNiNkuXYlO4mRHSGzZ478ecAuxN4qPPpHQk3IKnpwnbijV/2Qx92smpEhoIq4iLKP5BmqrklLjuSletLNoXFGabmEKRgUoPlMLXV4RHyEHmuGJteOYRYovguqGM7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025600; c=relaxed/simple;
	bh=Fr/L7+QNH73Brgzgoa3emTO9y185OQT929a5DHUlLFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk3vC8YrxsUUdLj1M5AS4bvYEyytlDkKFyCnav0z+si75yXeLJ+XAd4w1MH3AokzNsqfswTWKq5ff0g9XA+xqPdnKI4etA1JPs6wFJFcX9QIMBn5sxYzKSQJ7aW+KLqtv+wIyBhgseDy6RNDAI0LdRqvoPjMaEFXY3Va2NKP3bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ry1M/Emf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ry1M/Emf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD63BC4CEF0;
	Tue, 12 Aug 2025 19:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025600;
	bh=Fr/L7+QNH73Brgzgoa3emTO9y185OQT929a5DHUlLFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ry1M/EmfHF8FvrmudJLrdHwSHvkDioCVwpOvz1M9JLUcYI5E/wE473dK3VZLyYnp5
	 p8nDVs3oJvlTlDVKJZNZIqIuqNbV/uJYbzsxGeU+NIKaYe+GnMQweHVt/Dd8t87jty
	 yrMbP4LLJSBWS54RJIrex9CxYpmfoatWiOlWezko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 090/480] soc: qcom: pmic_glink: fix OF node leak
Date: Tue, 12 Aug 2025 19:44:58 +0200
Message-ID: <20250812174401.165120031@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index cde19cdfd3c7..e57b47c17c3c 100644
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



