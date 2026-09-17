Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3832E4973B9;
	Thu, 17 Sep 2026 17:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666889; cv=none; b=jc+LqpK6vrbZeLFokH0iU47uUN1nHrWGLHt2dAduiK1DKUsZhEKfyErLYtVpZ4yUvFGOgs9z1rC21yEmxoQN4Qjslivkx3FYzYQeUjNbwsPPL9pzrXBOCnXnxOP+b9PGKrm3ZCJ1aNQL4+B/is/9sk0UKi0ndVANX6NVCDq/9Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666889; c=relaxed/simple;
	bh=VmCeOAiD3Q9CZHjYlqIUhxigFUIBVXp8KXPYeTZKgZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6SfA7A1kTqcKbds2lrNCmhSbTNXkYgoR6pISlzkHm+LFYPC5cdlywrbsiOHYCyyLZ+hmSSmRNBdSY7b46HH34ABeiBpicxHMOU3OTtVpA4Zfxt7FWgk8dmmrhdtzI4q3HsNB8sU0rfS8g/+JtNNC2hp/fjOuoSpKz413UiAmbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcVpRqd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcVpRqd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9127E1F000FF;
	Thu, 17 Sep 2026 17:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666888;
	bh=u6CnlAtOyZbemQi1QyAdKbwiTpFr3aMoxCKtGLcOW7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcVpRqd+J0c30uVx7RtnlPKstbzNAbqbPTVs7M1SlWYG6YOW+1NAifvFXWfugg5as
	 IHoexADjW9360OdYd7kNgkRT+xIr3wpznqdhrZcajnUjRnBmTxqMwRzAtE24RUuTqs
	 O1LLUXVVW8nGcWz4oqGKUqJWXTVmnOt/Zzd6Elew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1159/1250] media: qcom: iris: fix runtime PM reference leaks
Date: Thu, 17 Sep 2026 16:15:54 +0100
Message-ID: <20260917151623.679945198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
[ used dev_pm_opp_set_rate() instead of the unavailable iris_opp_set_rate(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_resources.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_resources.c
+++ b/drivers/media/platform/qcom/iris/iris_resources.c
@@ -66,20 +66,21 @@ int iris_enable_power_domains(struct iri
 	if (ret)
 		return ret;
 
-	return pm_runtime_get_sync(pd_dev);
+	return pm_runtime_resume_and_get(pd_dev);
 }
 
 int iris_disable_power_domains(struct iris_core *core, struct device *pd_dev)
 {
 	int ret;
+	int pm_ret;
 
 	ret = dev_pm_opp_set_rate(core->dev, 0);
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


