Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80171BA866;
	Tue, 30 Jul 2024 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354995; cv=none; b=hYWnCklNEDwNePL4FMuZHRwR/4iE/GwXU1y4XpJw5GeyBO61uGTP7SZLoE+Lu1ZPrB+5QXhcwo6frjYJQQZacL4OYuJMU7HjyjSnM10mLri5tQcSQburjHK28y7bk4/LY3dPhzXALEWI1hbQ2J1QRS3URa1aBaaPMoTHlt7iRCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354995; c=relaxed/simple;
	bh=kK+vfQNVdU4pqLr0Yo7w+nD2Yt14C0qG1TiWtC0JNfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkgSJYGhMDF1begcllCSFcUStThT5zZyQvwO3+mG1XpRC4LBQs0N7i0b/k75iFCWY83d6VB59tsRJLSHhJhvCz5al1fko2VFzcrdA11voy96GIrSJgiAAmE/TmgAafEoSBonxlyLzDO7BQd6JzsS9IQDk9FKYDdnYIKBNXEI5jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAXMQ1Fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAXMQ1Fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69808C4AF0A;
	Tue, 30 Jul 2024 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354994;
	bh=kK+vfQNVdU4pqLr0Yo7w+nD2Yt14C0qG1TiWtC0JNfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAXMQ1FljHtNkBK51/E8q26hQUt/r/Qk75sk06OybKyu+dEYsRh+6JzWyl4oYKi4X
	 8vFOJC6elYD+0uuzm2nBLJqrLkv+ojLSKFjGPzWjQmV4Fi0jsQWDJPCJMw2QrtcdZi
	 TaGnbifn9pOcuQF0xGqWOdSJZQ2nOB+La1JskLrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/440] cpufreq: ti-cpufreq: Handle deferred probe with dev_err_probe()
Date: Tue, 30 Jul 2024 17:44:38 +0200
Message-ID: <20240730151617.522794336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Primoz Fiser <primoz.fiser@norik.com>

[ Upstream commit 101388b8ef1027be72e399beeb97293cce67bb24 ]

Handle deferred probing gracefully by using dev_err_probe() to not
spam console with unnecessary error messages.

Fixes: f88d152dc739 ("cpufreq: ti: Migrate to dev_pm_opp_set_config()")
Signed-off-by: Primoz Fiser <primoz.fiser@norik.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/ti-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/ti-cpufreq.c b/drivers/cpufreq/ti-cpufreq.c
index 61ef653bcf56f..15e2ef8303508 100644
--- a/drivers/cpufreq/ti-cpufreq.c
+++ b/drivers/cpufreq/ti-cpufreq.c
@@ -381,7 +381,7 @@ static int ti_cpufreq_probe(struct platform_device *pdev)
 
 	ret = dev_pm_opp_set_config(opp_data->cpu_dev, &config);
 	if (ret < 0) {
-		dev_err(opp_data->cpu_dev, "Failed to set OPP config\n");
+		dev_err_probe(opp_data->cpu_dev, ret, "Failed to set OPP config\n");
 		goto fail_put_node;
 	}
 
-- 
2.43.0



