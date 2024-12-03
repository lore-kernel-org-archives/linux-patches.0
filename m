Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6889E1DE8A5;
	Tue,  3 Dec 2024 15:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241483; cv=none; b=qCBhb3jNk1d22EULx4+m0yE32/NZS9B3+Zzc/yefjLLHNqh/LZB9zKtwdubkJm6mtTH9scI98I8q1YdW6I6ab1nbrdg9HOQu9l4tp6XvGkz6gKxH/uKdaLlbLyNV1jBNI1l+jFeJlS2W31ofD68mqKKe5PY5hHWyrHhr+WZ8SQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241483; c=relaxed/simple;
	bh=hU8ng9lI51nVh2xg1Lm1g78jEFoRQFzeHrZjkacWiZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvwJigi6ZnTEmtvjv46ZlPScbVjXoiFY1Xlz1IH9l89OiIUWuy3xCj3v6uMX4tWAjd8jgg0qmofHDll1gTOWzh8twJkBpBiEAZWjaZr623Ma6X6M6nNjpuhL25qc97+F2HCSijwgRqVQu60VTHtFv+h3Sw7sE26s9KE55W5/n4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MROrYuGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MROrYuGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA66BC4CECF;
	Tue,  3 Dec 2024 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241483;
	bh=hU8ng9lI51nVh2xg1Lm1g78jEFoRQFzeHrZjkacWiZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MROrYuGslW/QPoECUYBOE2lH8us9o36bKlaAO3jhqQ8tZYAZe87xHT5mXA37XmLd4
	 L+9x52SL6m6CS/PXWBJpeEiZTQo8p6Rmt5QMG9Zadg3jM3RcXW0h4ITSNS3lQcQ7HC
	 x4tMP1P2We90uWXPp3KVTdslkskd2bdjxgnm/Cfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 430/826] cpufreq: loongson3: Check for error code from devm_mutex_init() call
Date: Tue,  3 Dec 2024 15:42:37 +0100
Message-ID: <20241203144800.535863043@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



