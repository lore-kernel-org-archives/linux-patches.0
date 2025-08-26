Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7596C28314A;
	Tue, 26 Aug 2025 13:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215773; cv=none; b=R9NCgsPXM+Br8VAU1qpigNhjdGH6gvXXc4lcMxbmcvTA1AcXSINi1lMgSFFt3HnLh1FQx3srwkQweu3GuooNEJH+Qtb+y5EtiAI/XKCh8RaL+My5+4NMwCiyyLKxqC6n5/GThtKR6mLX4gjSg8L6ibv8sHHBoVITU6ui7ZAh9G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215773; c=relaxed/simple;
	bh=dJwiZH+bdh+/jBMm4nDkr4isucKC6DFVaPYausoE19M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFmYIBKjzhr+Nqau9l3EPtslzhNIWFT47yW3BcVDwsFO15DQcw/yZdw7DWArsrxhm89mRZ7bP5M1rTo7BvdtyJfm978fLag7SDVzNkzuiR7R+Ggii2MJuoXcfuyBUPfidIRe87Wf6Za6jo1BZPy+3tliwpczalGzTAk+MQVAHVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rj8dl4XZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rj8dl4XZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06055C4CEF1;
	Tue, 26 Aug 2025 13:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215773;
	bh=dJwiZH+bdh+/jBMm4nDkr4isucKC6DFVaPYausoE19M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rj8dl4XZ7FQ0koe5omwj3uBEQel0VqZEdkn8Gd3Mkbpmjd/OQQW96pnC3IB6gO3D3
	 TSkQUqhSs0QHyTBRtWqPMSSRJJDttpHAFbxxiQZLcQrs6GnGr3p2iKaNjMmkWHEDcb
	 QsldW6ABJZYbTpkJZvvE0eiMU0Uy2Pj6SybPNrwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/644] cpufreq: Initialize cpufreq-based frequency-invariance later
Date: Tue, 26 Aug 2025 13:03:41 +0200
Message-ID: <20250826110949.730999487@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 2a6c727387062a2ea79eb6cf5004820cb1b0afe2 ]

The cpufreq-based invariance is enabled in cpufreq_register_driver(),
but never disabled after registration fails. Move the invariance
initialization to where all other initializations have been successfully
done to solve this problem.

Fixes: 874f63531064 ("cpufreq: report whether cpufreq supports Frequency Invariance (FI)")
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20250709104145.2348017-2-zhenglifeng1@huawei.com
[ rjw: New subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index bbb0cbb2eb8c..7d7158fa70c5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2841,15 +2841,6 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	/*
-	 * Mark support for the scheduler's frequency invariance engine for
-	 * drivers that implement target(), target_index() or fast_switch().
-	 */
-	if (!cpufreq_driver->setpolicy) {
-		static_branch_enable_cpuslocked(&cpufreq_freq_invariance);
-		pr_debug("supports frequency invariance");
-	}
-
 	if (driver_data->setpolicy)
 		driver_data->flags |= CPUFREQ_CONST_LOOPS;
 
@@ -2880,6 +2871,15 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	hp_online = ret;
 	ret = 0;
 
+	/*
+	 * Mark support for the scheduler's frequency invariance engine for
+	 * drivers that implement target(), target_index() or fast_switch().
+	 */
+	if (!cpufreq_driver->setpolicy) {
+		static_branch_enable_cpuslocked(&cpufreq_freq_invariance);
+		pr_debug("supports frequency invariance");
+	}
+
 	pr_debug("driver %s up and running\n", driver_data->name);
 	goto out;
 
-- 
2.39.5



