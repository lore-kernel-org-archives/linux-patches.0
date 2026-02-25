Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B2F283CB5;
	Wed, 25 Feb 2026 01:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983805; cv=none; b=nIg+Po3oo2kGplXYUA7V+GNbWeXy15XYR2Y8tZGBk4kKM2BQt8yS9pP6KNzj4pRxK5Um3DQFcRl52y+9YKJSLQY4oFpH37tP4LJR4gHwqtskkdk1QFvtEsERtbPvv+yjj+kN9TxbjFNw9ghnH9iQzoerHSxup6Gako9/dzMmAFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983805; c=relaxed/simple;
	bh=bO4GEV21rmvp0PWgkGBQgS3mSuz+uj2CqIOC8G7TYSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vz6BmKUL+UpGNcxvU+TY8m/B1ASOGTHv6hKE5HjX5372nNaDXAQ5k05dwNJCkXodiXOFd4xoyJbJnf5uToERv8IndLkjYccW/Ge/KI+KdFMJuoMXwwrhXcwkf1AuOWRv7T6xzew9aBqhabIb0mgnxPjehEa3+3aiLXpwsGD+kzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqFyNr4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqFyNr4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479A4C116D0;
	Wed, 25 Feb 2026 01:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983805;
	bh=bO4GEV21rmvp0PWgkGBQgS3mSuz+uj2CqIOC8G7TYSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqFyNr4LsQ//SpPW3mtjU9bJy62npjImHW60jFrI/dS5Y6h56tTDskEeIT+uP23NR
	 L2OpNMOTt+abH5wA5ZxGVGPuIR1olmAlXV3unQHxHN1/in/pEcgswE0EpRPayW8OQ4
	 idg0vmYpJuDo7dDxz4pt9fghhLYpssigYMKXFaGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/641] cpufreq: scmi: Fix device_node reference leak in scmi_cpu_domain_id()
Date: Tue, 24 Feb 2026 17:16:14 -0800
Message-ID: <20260225012350.196651273@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 0b7fbf9333fa4699a53145bad8ce74ea986caa13 ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In scmi_cpu_domain_id(), it does not release the reference.

Fixes: e336baa4193e ("cpufreq: scmi: Prepare to move OF parsing of domain-id to cpufreq")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index e0e1756180b0c..c7a3b038385b5 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -101,6 +101,7 @@ static int scmi_cpu_domain_id(struct device *cpu_dev)
 			return -EINVAL;
 	}
 
+	of_node_put(domain_id.np);
 	return domain_id.args[0];
 }
 
-- 
2.51.0



