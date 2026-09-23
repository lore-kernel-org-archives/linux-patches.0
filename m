Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43B92D6E64;
	Wed, 23 Sep 2026 14:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172658; cv=none; b=Jt+Im0fySq15frkMy25nu6u+QQeCLgYKjOq8Rvh/g+IckrW9uD5LesY/Z6l8lTrvuue1ebrZ+j90jq6DlxqE6WThQjUN8k8Y7BTQChQOEMb/HnMEYkwQJ4Wkgu/hLx47FUWHKAacPhs3vR2VStA0864oHnCngfrnWdnvoP1KDxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172658; c=relaxed/simple;
	bh=xA9cwWpQ9tFEd4v8uHU0eQ/P2AoPqA7S1iGZES9c7Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAp++Z/eQCDm1nsfd8RBexidrNj6iVQbmvjiX2zFnNuN/ugh11sk8XepyQL6KxTt2x+w5zARbBeNRuSAuMc9GKODn8CJyUHR7UVnFSurYI2EtXOusJqdqZ6rtP+Ft/E9MmcMjLwBZ6bsmXC0peLj+fi3p/Ow8t0u3LZaKvZP39Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qctq4W7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qctq4W7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1711F00893;
	Wed, 23 Sep 2026 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172656;
	bh=H1lW1lfLSarypMz9dPXwc3FsahB++pmhEG5fREaofTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qctq4W7DyRW2Dc8u5+Ir4TlDt3k2guHTpOSOhbuBZSxu6spZpHj3R6+ZG99I5zC0P
	 +5r+preLnoeQuHC0/k9gQbwEO6etN5rnDx8m/dSoU3ckOQ3W6ZG9jq1q/u0gYYjbFH
	 QxP9Ijstm//Hj1kK/nsFpof8PMuEA0qhtkpLU1II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 023/438] clk: scpi: register scpi-cpufreq once and clear on failure
Date: Wed, 23 Sep 2026 16:00:44 +0200
Message-ID: <20260923140645.376243772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit ab06cf8152dace327cd873188e4a036c4e0b5944 ]

scpi_clocks_probe() walks clock children and, for each DVFS provider, calls
platform_device_register_simple("scpi-cpufreq", -1, ...). Two related bugs:

Since all DVFS providers register the fixed scpi-cpufreq device using
PLATFORM_DEVID_NONE, a second registration fails with -EEXIST and
overwrites the pointer to the successfully registered device. The first
device can then no longer be unregistered.

Register the virtual device only once. If registration fails, reset the
pointer to NULL so a subsequent DVFS provider can retry and the global
pointer only represents a successfully registered device.

Fixes: 9490f01e2471 ("clk: scpi: add support for cpufreq virtual device")
Fixes: 67bcc2c5f1da ("clk: scpi: don't add cpufreq device if the scpi dvfs node is disabled")
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/fd1b9199a9c3.v2.1785200642.git.liuxixin@kylinos.cn
(sudeep.holla: reworded the commit message to improve readability)
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scpi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-scpi.c b/drivers/clk/clk-scpi.c
index 3c33a9e3c6909..e1891351c221a 100644
--- a/drivers/clk/clk-scpi.c
+++ b/drivers/clk/clk-scpi.c
@@ -284,10 +284,14 @@ static int scpi_clocks_probe(struct platform_device *pdev)
 		if (match->data != &scpi_dvfs_ops)
 			continue;
 		/* Add the virtual cpufreq device if it's DVFS clock provider */
+		if (cpufreq_dev)
+			continue;
 		cpufreq_dev = platform_device_register_simple("scpi-cpufreq",
 							      -1, NULL, 0);
-		if (IS_ERR(cpufreq_dev))
+		if (IS_ERR(cpufreq_dev)) {
 			pr_warn("unable to register cpufreq device");
+			cpufreq_dev = NULL;
+		}
 	}
 	return 0;
 }
-- 
2.53.0



