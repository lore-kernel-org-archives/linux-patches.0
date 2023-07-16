Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55B28F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4796CC433C8;
	Sun, 16 Jul 2023 20:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538724;
	bh=Jmz0QdRA0iv5e/1701mJebwSvCt6Uq26e9PQd9HE6G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rN+UE06A6NGDcrkYhwuZwFrvUg7b3HUKNBLYd/p0PEOaeWXMArCiQAmXybvDc74NJ
	 rI/1auO7OjYi/TN6k+lz8p5YteiicRpLip6FQdij1qcKyXJwyVtHFspiNW3QYE9WJx
	 ICW3d2wPejljDq+0XI/sWqYVsIApil6K28rpv9Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 553/800] cpufreq: tegra194: Fix an error handling path in tegra194_cpufreq_probe()
Date: Sun, 16 Jul 2023 21:46:46 +0200
Message-ID: <20230716195001.935784609@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9ab24b0486681ecc059ee766e00d9570c6311e08 ]

If the probe needs to be deferred, some resources still need to be
released. So branch to the error handling path instead of returning
directly.

Fixes: f41e1442ac5b ("cpufreq: tegra194: add OPP support and set bandwidth")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/tegra194-cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/tegra194-cpufreq.c b/drivers/cpufreq/tegra194-cpufreq.c
index c8d03346068ab..36dad5ea59475 100644
--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -686,8 +686,10 @@ static int tegra194_cpufreq_probe(struct platform_device *pdev)
 
 	/* Check for optional OPPv2 and interconnect paths on CPU0 to enable ICC scaling */
 	cpu_dev = get_cpu_device(0);
-	if (!cpu_dev)
-		return -EPROBE_DEFER;
+	if (!cpu_dev) {
+		err = -EPROBE_DEFER;
+		goto err_free_res;
+	}
 
 	if (dev_pm_opp_of_get_opp_desc_node(cpu_dev)) {
 		err = dev_pm_opp_of_find_icc_paths(cpu_dev, NULL);
-- 
2.39.2



