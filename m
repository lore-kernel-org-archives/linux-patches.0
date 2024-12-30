Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF2A15E8B;
	Mon, 30 Dec 2024 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573872; cv=none; b=V2rZhG9N9IClW1Ii8lgRgb9fAj/8D+m0Gahf7r+VMluv1P4DhLzaJ13YRP16WrDxDkoeKAEZ3fCFNyERuzqDoLuMYq8r4YVDvVLBHXrvKbFiYts4Dl9MoFezzCC8BCTyvUPwsoKArnmM/IrsWrxcIJN8K4+AmK42pMSZpBCdbzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573872; c=relaxed/simple;
	bh=iNHmw/UQZwNYx1puc5wJMwFZVdVntg/bnxFZk2r/duk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMqOTICLVi1q9A1ifkJSwX6T9kw11l8ysM3eENcpLVtV/JjaQEfPuvkZaPSaWk49pqsU5PPMkRhXE6W0ko5NEmNL/LPUhcSL5WA3Rpl8UzOKWdbnlaW7XATDTT5xCj+t6I4jkbxeZ8eUx1IMYJ4K3nIXqdXGaJ3auz+DcmYIecU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPb35l1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPb35l1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C10C4CED0;
	Mon, 30 Dec 2024 15:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573871;
	bh=iNHmw/UQZwNYx1puc5wJMwFZVdVntg/bnxFZk2r/duk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPb35l1O38lqG+v3zegi3QaIOvsiHQQW8kAhaxeH+YirRkAarOsDYQvmMAITfLuHh
	 bGJEexbO5NhoXvrvuQizZvmzQ7XxGw116Sk4b2tV/a/cV/jS3Bg9NRVLN2ILQr4cIn
	 9dCK9N/VWdKW2wLLkArejjKP1Z83VX7TENpk70Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 57/86] pmdomain: core: Add missing put_device()
Date: Mon, 30 Dec 2024 16:43:05 +0100
Message-ID: <20241230154213.885374787@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 582564f8dde6..d9d339b8b571 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2021,6 +2021,7 @@ static int genpd_alloc_data(struct generic_pm_domain *genpd)
 
 static void genpd_free_data(struct generic_pm_domain *genpd)
 {
+	put_device(&genpd->dev);
 	if (genpd_is_cpu_domain(genpd))
 		free_cpumask_var(genpd->cpus);
 	if (genpd->free_states)
-- 
2.39.5



