Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA164EB840;
	Thu, 17 Sep 2026 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660781; cv=none; b=p1UHACDvG1/dXNsMe0VMUBvnihOQvWxHUBJR0JHJP2DbORAi1f0YAGu5DvVF9XSdAP/C4uslOfXPOgWl0Ar84H9C1FXm55bMlXXB0tef3a9Z6A5LmMaXZ/SiotSQbBX7T2FmlBACBbUGHCHxs5QIXR5Yue22Z8w0kxLcaosIxMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660781; c=relaxed/simple;
	bh=pnPhuuF3FTMz/lopv/27SP07OlvLWIyMAvY58mDXpUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaVwFVhUC2li1tEC4LxKidNQjRIhtQzIqIXj22aROwaBZQsqDUg+F98Z3X74JYG6DHow6ba7cFRCgCBISCwqk9Zbb/nwKtKShgMMxKAuU3bMI1N8OPGc2s6CJb/IgiYaijK7qDJUvZO3ocBi6Zn8wwKEHR3xBeIXvYRaklfDm9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fasG19Xv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fasG19Xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5F41F00898;
	Thu, 17 Sep 2026 15:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660780;
	bh=iZGG+tAOF4q3jBIMcQZNc/mqhCM651NYBk2ovz3QREM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fasG19Xv0IJjpxbb1iE+dlwhCuKq+gZa987Y19m2FxdCwI+L/ocgbgVXcBZ87D+oT
	 dXgo5SIl4oRC7I53Ou4IT29wjxnSnejURITAKUw8s+Lus4k0thkC6Y1GzpnoDBvE9V
	 /DkvoOO6Otu3a87iVYw3QOKbJl4P/a7WvoJXrhwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 700/733] media: qcom: iris: fix runtime PM reference leaks
Date: Thu, 17 Sep 2026 16:16:48 +0100
Message-ID: <20260917151410.292812562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit f87d7eda07fca21efe4b96169ae59007db46e60e ]

Use pm_runtime_resume_and_get() in iris_enable_power_domains()
to avoid leaking a runtime PM usage count on failure.

Also ensure pm_runtime_put_sync() is always called in
iris_disable_power_domains(), even when iris_opp_set_rate()
fails, so runtime PM references remain balanced.

Fixes: bb8a95aa038e ("media: iris: implement power management")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_resources.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_resources.c
+++ b/drivers/media/platform/qcom/iris/iris_resources.c
@@ -78,20 +78,21 @@ int iris_enable_power_domains(struct iri
 	if (ret)
 		return ret;
 
-	return pm_runtime_get_sync(pd_dev);
+	return pm_runtime_resume_and_get(pd_dev);
 }
 
 int iris_disable_power_domains(struct iris_core *core, struct device *pd_dev)
 {
 	int ret;
+	int pm_ret;
 
 	ret = iris_opp_set_rate(core->dev, 0);
-	if (ret)
-		return ret;
 
-	pm_runtime_put_sync(pd_dev);
+	pm_ret = pm_runtime_put_sync(pd_dev);
+	if (!ret)
+		ret = pm_ret;
 
-	return 0;
+	return ret;
 }
 
 static struct clk *iris_get_clk_by_type(struct iris_core *core, enum platform_clk_type clk_type)


