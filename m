Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F7E3AB482;
	Sat, 30 May 2026 17:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163112; cv=none; b=oOkglKKe54xjtW6RW7gxpvDI+KWzGdGDB9hkBDc8HI10X0M9sfmqq7R2VpiYfuyIcz/nIpBIYaoklH3MtYMo6XJeaha6IWma0vvEi/d579iHJvV19RJxDQdxOI0EER2+ng6KNAOGY5LLDnenW7ia6IOp4t/NedGjkeSen+JHDf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163112; c=relaxed/simple;
	bh=z89j2dPO+Khgu65faqG++GTHmMa4yCW4AnhajwEmcUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgRPj2025oMVPhVPZ0YI8RolJ3NkZ8gzgnDIZCEo2XOTMfIU3dMsozhJ8mzoNkvLaQiXPXtJ8MEiT395XLz5YvLiiWWh5WhDrh77isRTt6+7MuOjNiFiKo8we4QN+PrbqNipeSzEm90pJNpnI7fvjJ8vMxRrFrMbEzc302je+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBLBc440; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBLBc440"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4595C1F00893;
	Sat, 30 May 2026 17:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163111;
	bh=7zUL2vboSU8MrOqCcOE31/p4DIPpknH3jB46fk99vIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBLBc440ISsHZJcmrah4HBck8CifSgxXUg74SsI9uHagq9I6MUsWYBrGBJmWMa4lW
	 sAXwd24F0H4R0p4CD5VCg4gKNLjWWA9o0PkGTrgmaCHo4c/G2xSoii3u0EglR+5M+6
	 6a0Dh/YXBI2VqkvW9dbZu23mxteJQZ5vKWEDGKzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chang <liaochang1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/776] cpufreq: governor: Free dbs_data directly when gov->init() fails
Date: Sat, 30 May 2026 17:57:51 +0200
Message-ID: <20260530160244.528651669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit 916f13884042f615cfbfc0b42cc68dadee826f2a ]

Due to the kobject embedded in the dbs_data doest not has a release()
method yet, it needs to use kfree() to free dbs_data directly when
governor fails to allocate the tunner field of dbs_data.

Signed-off-by: Liao Chang <liaochang1@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 6dcf9d0064ce ("cpufreq: governor: fix double free in cpufreq_dbs_governor_init() error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq_governor.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -440,7 +440,7 @@ int cpufreq_dbs_governor_init(struct cpu
 
 	ret = gov->init(dbs_data);
 	if (ret)
-		goto free_policy_dbs_info;
+		goto free_dbs_data;
 
 	/*
 	 * The sampling interval should not be less than the transition latency
@@ -475,6 +475,8 @@ int cpufreq_dbs_governor_init(struct cpu
 	if (!have_governor_per_policy())
 		gov->gdbs_data = NULL;
 	gov->exit(dbs_data);
+
+free_dbs_data:
 	kfree(dbs_data);
 
 free_policy_dbs_info:


