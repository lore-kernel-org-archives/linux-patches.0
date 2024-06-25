Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D825D1487D6;
	Tue, 25 Jun 2024 09:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308294; cv=none; b=BlH0Nq2+4uBET56bJjmvClIzkr+8vusI1YbRKEMYA7O2vRV7BiWFyV8a7WNnDeRPmkfMe9iZjXNryiyUDBg5Hn4VF4TnBiYGhzTtMREY8vRuYnl2pa8m77h0JpE9NIud4lzmP8Jlq7i2ubnJcCmsGJcRYQUS+u1NFL09ZZiHR6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308294; c=relaxed/simple;
	bh=sWCu6T3N3KO+gGIu4sg1rT+1x882+zgNY/pXCQ6NFbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipeRTqXwuu8uppE6/pDbAT0+xTLRJ3u88bMsmjzRFGkNHpZUxJy94BD7uLBCSwHpHHoME4iMAUYcNF5wJdOB5olL2e9BOKWVlxivCyNMmSUhL0rGjJwXoreieuSbjb2itEb7dMnZIrOFUF9OqTuYKOMx++acgAiv4OErxDNMEU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JC0YWkX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JC0YWkX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53636C32781;
	Tue, 25 Jun 2024 09:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308294;
	bh=sWCu6T3N3KO+gGIu4sg1rT+1x882+zgNY/pXCQ6NFbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JC0YWkX79Nd2lz810ywb8eI2KyJ4F1RHiCZh/936J7ew5m2fnz8NlNjSSxo18sN20
	 lrBIeVEFH8UtYY8BlDprgXPEEIXK9DylEC3My0bZI2/bmPkrSyLWI0EZYe6s8IVT4a
	 nLrIGnZbl3F1rRLq5VZdJdk4R85rDWUx62d7nOKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 073/250] usb: typec: ucsi_glink: rework quirks implementation
Date: Tue, 25 Jun 2024 11:30:31 +0200
Message-ID: <20240625085550.867909544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3f81cf54c1889eeecbb8d9188f5f2f597622170e ]

In preparation to adding more quirks, extract quirks to the static
variables and reference them through match->data. Otherwise adding
more quirks will add the table really cumbersome.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240329-qcom-ucsi-fixes-v2-8-0f5d37ed04db@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_glink.c b/drivers/usb/typec/ucsi/ucsi_glink.c
index ce08eb33e5bec..0e6f837f6c31b 100644
--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -311,12 +311,14 @@ static void pmic_glink_ucsi_destroy(void *data)
 	mutex_unlock(&ucsi->lock);
 }
 
+static unsigned long quirk_sc8180x = UCSI_NO_PARTNER_PDOS;
+
 static const struct of_device_id pmic_glink_ucsi_of_quirks[] = {
-	{ .compatible = "qcom,qcm6490-pmic-glink", .data = (void *)UCSI_NO_PARTNER_PDOS, },
-	{ .compatible = "qcom,sc8180x-pmic-glink", .data = (void *)UCSI_NO_PARTNER_PDOS, },
-	{ .compatible = "qcom,sc8280xp-pmic-glink", .data = (void *)UCSI_NO_PARTNER_PDOS, },
-	{ .compatible = "qcom,sm8350-pmic-glink", .data = (void *)UCSI_NO_PARTNER_PDOS, },
-	{ .compatible = "qcom,sm8550-pmic-glink", .data = (void *)UCSI_NO_PARTNER_PDOS, },
+	{ .compatible = "qcom,qcm6490-pmic-glink", .data = &quirk_sc8180x, },
+	{ .compatible = "qcom,sc8180x-pmic-glink", .data = &quirk_sc8180x, },
+	{ .compatible = "qcom,sc8280xp-pmic-glink", .data = &quirk_sc8180x, },
+	{ .compatible = "qcom,sm8350-pmic-glink", .data = &quirk_sc8180x, },
+	{ .compatible = "qcom,sm8550-pmic-glink", .data = &quirk_sc8180x, },
 	{}
 };
 
@@ -354,7 +356,7 @@ static int pmic_glink_ucsi_probe(struct auxiliary_device *adev,
 
 	match = of_match_device(pmic_glink_ucsi_of_quirks, dev->parent);
 	if (match)
-		ucsi->ucsi->quirks = (unsigned long)match->data;
+		ucsi->ucsi->quirks = *(unsigned long *)match->data;
 
 	ucsi_set_drvdata(ucsi->ucsi, ucsi);
 
-- 
2.43.0



