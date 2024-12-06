Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0BE53A7;
	Fri,  6 Dec 2024 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497366; cv=none; b=IP8uMMZvZmMAvFMkJomVr8QmSjv6TEygfB14OSj9FgKysE5ydgMk/bbx1kPIX+ejZyR+f7e/LQGxlYGH/MFvJ6Ghvto54Yrf+Ilw6vZZ3fo29Va/dYqxhKwMHkjQmiaul+lX8Y/1EW3ZUEIhAPY/P5+FW6VWZE/lscsMp5WVzug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497366; c=relaxed/simple;
	bh=mll8Xcsd+Mg2pYkHM6CRWJOrigzAGskDSc0ne7lYUhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAMDwzC2dxTFC/i2MqDlPaRWs2cmOek2nX+ypg8sQ5J9mvCzjVdrnOSePIHr8vQLpbulBGc/tcboZJ4YQgsO/8R8N94wZWTHe24XHwlEwQXU2yV4bPx6flK3bumX6yInhFVQHR+KVPTGfvfL+VIOiRAxgK56m71qSeNCdLQhOww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBJqG1zJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBJqG1zJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8DDC4CED1;
	Fri,  6 Dec 2024 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497366;
	bh=mll8Xcsd+Mg2pYkHM6CRWJOrigzAGskDSc0ne7lYUhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBJqG1zJ2DLD9+aTakQtDAhh41gwneDLVAreNvxA1DpzifMcUIslC5JjN7nqZ4RO6
	 6zBAsg5yx37Zg+mKEbb/0HCKGVIxGOND3Tv3KQjvH5Dn8cVgBlSN5EsaaLfwFmHa18
	 QeI94LYaE1Zfeg3u9l/xBRSqrygYAnovM6oE9JRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/676] cpufreq: loongson2: Unregister platform_driver on failure
Date: Fri,  6 Dec 2024 15:31:29 +0100
Message-ID: <20241206143703.886027765@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 5f856d71ccdf89b4bac0ff70ebb0bb582e7f7f18 ]

When cpufreq_register_driver() returns error, the cpufreq_init() returns
without unregister platform_driver, fix by add missing
platform_driver_unregister() when cpufreq_register_driver() failed.

Fixes: f8ede0f700f5 ("MIPS: Loongson 2F: Add CPU frequency scaling support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/loongson2_cpufreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index afc59b292153d..63cae4037deb1 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -154,7 +154,9 @@ static int __init cpufreq_init(void)
 
 	ret = cpufreq_register_driver(&loongson2_cpufreq_driver);
 
-	if (!ret && !nowait) {
+	if (ret) {
+		platform_driver_unregister(&platform_driver);
+	} else if (!nowait) {
 		saved_cpu_wait = cpu_wait;
 		cpu_wait = loongson2_cpu_wait;
 	}
-- 
2.43.0



