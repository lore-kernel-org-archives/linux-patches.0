Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72C0216605;
	Tue, 29 Apr 2025 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949342; cv=none; b=nG++ZFJCqEd9XbZFxw5UG+unRdg0VgwUyt1eoriCieSQzCIOYeQT/idceQMP2nZCoDzgeYzcTXF/JWI98AQD8oO5WC0nhO3Hy5hnnnw9dSjAMmQHot1rWz6svKt091SBaRICtQ9ytGFvo+5afbC8QFTcvdweK0tsoPesIOp0FnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949342; c=relaxed/simple;
	bh=dlbDkJStd0pFPbsw9Ru68B5YkH9BCxxrwr2qGVdjt9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLnIwPIuZcAaumKv2JesMbkwUpda6JPRquHmzX4ySo17OvC9HXVacUeybgs3BMw7UC12cMMVnvbT1XIh3eYnIJF/4zq0qW3Jk2qTGon8ujzxH0kmOLBy5dk+iK1EVn3UO2qvaxpniccInoCE8PuT7A0jn2Cmcfa10T/hJTDhs3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heha3a+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heha3a+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D94C4CEE3;
	Tue, 29 Apr 2025 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949342;
	bh=dlbDkJStd0pFPbsw9Ru68B5YkH9BCxxrwr2qGVdjt9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heha3a+ELAOrrZjnUFL1G4q9Pw+bjvYWqtUkS8yB/CKqRNH8J9h5ZENRXmjckJMcu
	 trRIenT8G+XloLhzQ/d4FIc2rVe0CptuVxGnMftqSxWiQEODty6jtCgUWpEg3wB1bK
	 ufH+CUYdH/Acmb0nDcIK6svNTO4NSaPuVKQm12kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/373] cpufreq: cppc: Fix invalid return value in .get() callback
Date: Tue, 29 Apr 2025 18:42:46 +0200
Message-ID: <20250429161135.001562425@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 2b8e6b58889c672e1ae3601d9b2b070be4dc2fbc ]

Returning a negative error code in a function with an unsigned
return type is a pretty bad idea. It is probably worse when the
justification for the change is "our static analisys tool found it".

Fixes: cf7de25878a1 ("cppc_cpufreq: Fix possible null pointer dereference")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 17cfa2b92eeec..c5a4aa0c2c9ae 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -620,7 +620,7 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
 	int ret;
 
 	if (!policy)
-		return -ENODEV;
+		return 0;
 
 	cpu_data = policy->driver_data;
 
-- 
2.39.5



