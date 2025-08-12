Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BB51EF38C;
	Tue, 12 Aug 2025 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022110; cv=none; b=DG5Kxfvl++oa79oT6aylaYh9vys02YIXiYuFoG4ABig1zxWdLF1rPY6Oad3wwemVXSTGynWk9w/BLixHhyIatA5DaHx0dYEPMuX5uvP8XrcgpftWDNsN7MbsNWojy+g3bhV1E3R0CIyxJE5BHy/Tcwr3lTfjg0f22d2c95/pX/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022110; c=relaxed/simple;
	bh=vy2cBem9Mq7rVc+rXHvryRr7gWOtGfhYpoVgjB/nuZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMILzqjX/ZPV4fzZEpRfdAInevalhHveWwvE7iNV0M2ZwVaZunfe2lmurtIEou/8+7KXmvVwcK1PIjWPzdzoxS89cNFqWDRTkt1Hxta9DRH22Y5ZEZXHI2H8B+hvC41JAyDyEwOmlNNWWRM1CT3Ho4N24C34hDQ+yNOHdNiO584=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjNtR10K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjNtR10K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11587C4CEF8;
	Tue, 12 Aug 2025 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022110;
	bh=vy2cBem9Mq7rVc+rXHvryRr7gWOtGfhYpoVgjB/nuZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjNtR10KJzdzOeqN0bn+N9bwrmfhxK/bUfuhv6QqTKuIDTL25pePGjxnrrfezGTh2
	 i426N5T40+suKC7kieNn1dYDnzj95NYtmyMMpj7rL8PQcCLLYRB1SiEQaMMLoXx7cj
	 UNZJK01h6F0Qlcf7YPh2ljqVP8kfGMMOea1VMOc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/369] cpufreq: Initialize cpufreq-based frequency-invariance later
Date: Tue, 12 Aug 2025 19:25:55 +0200
Message-ID: <20250812173016.945002786@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1f52bced4c29..df3c8daede26 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2961,15 +2961,6 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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
 
@@ -3000,6 +2991,15 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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



