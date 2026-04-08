Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6668B3A6B6B;
	Wed,  8 Apr 2026 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672372; cv=none; b=pqurtJegEtCDOWIGq9bzlofUgAGgiKRkVZQpsw0WVF8nHt4wzVz8OZn9DTvl472JMvREJcGxrUbvgohm+lqDYzR4vH3Bx9XUACidQWGVpwInXGpJeNdu7pF7cbnEaEluLi0cLoxTsLAI3f938VsJQW3EGb4XcifN2U1j5pIAFuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672372; c=relaxed/simple;
	bh=a7pgviiFu1u9oNlE4dpYotKLbChCYSUjS/DGc5+Ftk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEBHlCVnw7xCl8sPgqoZE2gfnUS4gAacYiB8pf1iM6i4zdLCOlJDJEUyC39xsSAycDRkviKecVD16bKM1ECiEFEe/wdsD+LO1Xima2BvvE0yKN08Lz551oAil3BLObquaAaT0Z2bLrE2JdkrSQ+709GJBMSFJjCjqmH2Rm7wrqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbazVDIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbazVDIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B6CC2BC87;
	Wed,  8 Apr 2026 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672372;
	bh=a7pgviiFu1u9oNlE4dpYotKLbChCYSUjS/DGc5+Ftk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbazVDIaEILEi/4kw6xFrRg8U6sB6ik98AIruyassofMW46jmFgg5mIt4M5vvmcU0
	 hMNhxBp3GZDbYF/FdT4LaZLDmSL1Xl9tW8Bxe0+yrf4jfkOYzdJ1zBTW65Do9zrQz2
	 AKBPDr55zF10IQ7WntVPtkHxnPu4fWdKbgoPNTto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chang <liaochang1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 293/312] cpufreq: governor: Free dbs_data directly when gov->init() fails
Date: Wed,  8 Apr 2026 20:03:30 +0200
Message-ID: <20260408175944.709973859@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


