Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316442594B6;
	Mon, 30 Dec 2024 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573617; cv=none; b=moph935LdugQvvmLGy8wdcu09mkZQqncQxu2jv3k/SbZZ8X7GfzgMxHVGvIaeOCycX6Nw+FfvIo+gBIAlOQRXJ+qJ4z0STdwagFPKIjkmubNA+xSJfiB7QkveayRzsFCSW44wtP5vlcIMd9zKvyMbQtJ2OVEzyxvdZtPJLTDQ6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573617; c=relaxed/simple;
	bh=YBKW+OGzL/hUdFrpeDXM8dWnr0tUKtWG3sd1LozB2fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNXR2Tq1iFYxxajBfjbTae/2N14doHzE2smS/ni0jlC3TzEN7FECYygCDiprgHm8481unG+cKffvSzS3SOKvaRiqHadXDlBEGB/oKi6u+TC2EdCbQgvV72OzPOFElDvr/Lcv1JsTPYiVKt1gWzWIjwP4lICS8mBYtCFImZO5+QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQHXzPff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQHXzPff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D64C4CED0;
	Mon, 30 Dec 2024 15:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573616;
	bh=YBKW+OGzL/hUdFrpeDXM8dWnr0tUKtWG3sd1LozB2fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQHXzPff+tInSMbKGc+8e0hV1JWS9EspFUvVH7C/Duys4kebuzLm3h+hPl9A9/Jav
	 lG+m7Nxx/Ah/FReZOXzwiY5aLkJfeZD4WgUftzOeH2tZvUfn6HLy8uyMTyfaog0cUi
	 6fUVNtDKHYeHT6YEGxifQ9NfXvbmo9IiPm0ftRpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/60] pmdomain: core: Add missing put_device()
Date: Mon, 30 Dec 2024 16:42:56 +0100
Message-ID: <20241230154209.021648643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit b8f7bbd1f4ecff6d6277b8c454f62bb0a1c6dbe4 ]

When removing a genpd we don't clean up the genpd->dev correctly. Let's add
the missing put_device() in genpd_free_data() to fix this.

Fixes: 401ea1572de9 ("PM / Domain: Add struct device to genpd")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <20241122134207.157283-2-ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index e01bb359034b..3c44b0313a10 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2012,6 +2012,7 @@ static int genpd_alloc_data(struct generic_pm_domain *genpd)
 
 static void genpd_free_data(struct generic_pm_domain *genpd)
 {
+	put_device(&genpd->dev);
 	if (genpd_is_cpu_domain(genpd))
 		free_cpumask_var(genpd->cpus);
 	if (genpd->free_states)
-- 
2.39.5



