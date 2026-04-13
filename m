Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68A030BF68;
	Mon, 13 Apr 2026 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099826; cv=none; b=UjC4QB5ni8+pk2hEBvpAekR4klTGJI/E2inNuH4T5kWOvg750ylTLdf0pxxWcb0JNYvaeStkNhjUWyR5kZwMtiL1kzk4+Sn91C9+WY/vXmwHuhWG+QSAXKgd2JVLYiBuj0BFM4sIAR6tsR51RtfGN805rjX5bsikKxNSYCobKeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099826; c=relaxed/simple;
	bh=Ng77QWRck+va5hiLTTjGD+t0iqBFl22Pd8zbIsvUXk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wdy7SHMhYjYvs1snw1R8rD5kQy2FcMIDmGBJm2xhojdwiPpE0uIx6Cbe+f1IFFX08FGXFDiMuYWCi6Rnin54dVhdZhFXqHXffZpuW+KPhdUzASjNJUUg9Smv9NxV/6cqix80Di5yOhcOQJoJe+adSVvTdV/6tQ3v83EpX3Rd9b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXTdSSAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXTdSSAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBC5C2BCAF;
	Mon, 13 Apr 2026 17:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099826;
	bh=Ng77QWRck+va5hiLTTjGD+t0iqBFl22Pd8zbIsvUXk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXTdSSABUwKmNoXM/pO9a0Hfh9nvC5O7qcu+1aXspIkcm6OTAu9oHWA68z4jNTSnW
	 iWw4GjSKFzYTT+hs19e5l1eU/HnTIHRTRv5mNBTJOqny3ecRVXO4vS8RVaSAiXTKAa
	 YK9UpilHPOY4OkDxTot6f0RGCGn6hzfivXkEPIBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chang <liaochang1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 457/491] cpufreq: governor: Free dbs_data directly when gov->init() fails
Date: Mon, 13 Apr 2026 18:01:42 +0200
Message-ID: <20260413155836.143883839@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -430,7 +430,7 @@ int cpufreq_dbs_governor_init(struct cpu
 
 	ret = gov->init(dbs_data);
 	if (ret)
-		goto free_policy_dbs_info;
+		goto free_dbs_data;
 
 	/*
 	 * The sampling interval should not be less than the transition latency
@@ -464,6 +464,8 @@ int cpufreq_dbs_governor_init(struct cpu
 	if (!have_governor_per_policy())
 		gov->gdbs_data = NULL;
 	gov->exit(dbs_data);
+
+free_dbs_data:
 	kfree(dbs_data);
 
 free_policy_dbs_info:


