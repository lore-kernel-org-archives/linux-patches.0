Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6263BB24;
	Tue,  3 Dec 2024 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236584; cv=none; b=LG3nHne45PGcUBTajTSr9xe+6KtEVgLj/TB8Ix/5RPGaiGAVTF3nJsYJh2o5EFFbw2KPhj1IUVBeY245vCl7vYchJ+0i4/3+e4lTXJOMEqMuLvc1G6RN2xNGUTc4XvTEtT7imAOyOjwxLlD/DEvI9r/BzX50m5UdZ1a5wW4t6GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236584; c=relaxed/simple;
	bh=CvNR82nSXJccEbWFi+G88BcX/aKl8z/0tWoqn23L/kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyIJrySBgVudb0bwFIEs7Z5kphS/nEdBakqQAqiUf9lW19JwP+WLUNK718Kthx3uqOKm2r9Y/UjM0eYf3DPyKbt8c5evFu7qH9rJ9oYGo6AKA9B+VSc7LUkqM7fpEhAI5rsXEamE6ZS9WKxgj82WjUOqVf7ipi8eE1uLNRJc6xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGgFsPTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGgFsPTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AFFC4CECF;
	Tue,  3 Dec 2024 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236584;
	bh=CvNR82nSXJccEbWFi+G88BcX/aKl8z/0tWoqn23L/kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGgFsPTeDKHBnPMUNgeBm48Y6aHwjrhgmra53I8+5DJWFIBR7hmaz6/Nqu7Q02fFA
	 sTK/zPtF20i8GaDshjXLtEdaxZs3A2H5+Ksq5mYAtj0ZARflvWle9WD2nhjFV+wV6r
	 0H3shmZz1+RUmIR9D8Ekpe/HAPM+2IBj7v3R4S1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/138] cpufreq: loongson2: Unregister platform_driver on failure
Date: Tue,  3 Dec 2024 15:31:30 +0100
Message-ID: <20241203141925.893618243@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index da344696beed7..1f4d0cf3a53c9 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -166,7 +166,9 @@ static int __init cpufreq_init(void)
 
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



