Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7221F7540;
	Tue,  3 Dec 2024 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238940; cv=none; b=T8yQz8sZuc43jL5wCI58HOtyzsC2QcF0cMHulKZpR7VQUs+Z8vq5G6f/RMRhG7KNzcEy28V3QXDV+D7TGRhQRsWoeUPF5sBWMhTv8ga7KHzNjKUGpEeds+LVH1UCVWuv2SXl4QJxH3Z6ZXMb0qzuZ6QkVSb4Z/QWUwmnLDcWbLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238940; c=relaxed/simple;
	bh=2OmEbhZtJYYNTxrO9QACjxia5YQqO2U0ZFdVzvn+fMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNP5y7CBD1MB+5dZfF1FywiOTO5F5O5Ex3BXl6RUSvFGsv9jfbnssq8xOkGgAUDOnMXfbBiuDfwIK0I1YSjgZWKH+pGzTd8pmG5aKrlhwcSYWvUDaZqlYFKlslCL9J1iXZLT1/Ib8r7FST1mDhb2S7ycLEF3MoBQNaFO4NbmWGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROQ4jfKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROQ4jfKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124B0C4CECF;
	Tue,  3 Dec 2024 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238940;
	bh=2OmEbhZtJYYNTxrO9QACjxia5YQqO2U0ZFdVzvn+fMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROQ4jfKyvHHR1nbED9bBccGnCz0/0EsiUNr0up77g1fVdJIQi8ngSoR39GFxXtQRt
	 TZlExWGgYnyq+kveSyMir5AKMRxsBc1qzvB2Izv47J0UWk06z6krvyrKp7iSoKnlwg
	 MB7CwaP15lOkDSRg1vRALsTu9LTntuw+0lgKYk4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 450/817] cpufreq: loongson3: Check for error code from devm_mutex_init() call
Date: Tue,  3 Dec 2024 15:40:22 +0100
Message-ID: <20241203144013.442545766@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit db01e46689e9a986ca6b5d2f41b57d7a81551a4f ]

Even if it's not critical, the avoidance of checking the error code
from devm_mutex_init() call today diminishes the point of using devm
variant of it. Tomorrow it may even leak something. Add the missed
check.

Fixes: ccf51454145b ("cpufreq: Add Loongson-3 CPUFreq driver support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/loongson3_cpufreq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/loongson3_cpufreq.c b/drivers/cpufreq/loongson3_cpufreq.c
index 6b5e6798d9a28..a923e196ec86e 100644
--- a/drivers/cpufreq/loongson3_cpufreq.c
+++ b/drivers/cpufreq/loongson3_cpufreq.c
@@ -346,8 +346,11 @@ static int loongson3_cpufreq_probe(struct platform_device *pdev)
 {
 	int i, ret;
 
-	for (i = 0; i < MAX_PACKAGES; i++)
-		devm_mutex_init(&pdev->dev, &cpufreq_mutex[i]);
+	for (i = 0; i < MAX_PACKAGES; i++) {
+		ret = devm_mutex_init(&pdev->dev, &cpufreq_mutex[i]);
+		if (ret)
+			return ret;
+	}
 
 	ret = do_service_request(0, 0, CMD_GET_VERSION, 0, 0);
 	if (ret <= 0)
-- 
2.43.0



