Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7F81F76BA;
	Tue,  3 Dec 2024 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238788; cv=none; b=kVqBVjmSmW90Hi6npPsnis84JzjKCmD/btgyQ/amwVjJ8Lp0nlDwvwuOLFAfZkL81SkS0YxVbcMe28TlhsW+h530gq5yHzg3ErbFI4IbQ0TNAicJ8SZUPLIFbogxMPyy6FJo1Ai9jguc8/4AJ9VYs63bcl+tH9V7nQrN79PYjC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238788; c=relaxed/simple;
	bh=ta3n8BYtc28gm4afNKVG4n9Lr5lSUnrZi/aDDArthhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNLmtiFPCGMrb4b2txfRqa0gO2rrxmESNusZYDLwCBypxTP/B7t1gfWtk/ARsKrHtEnjUQsnR8iSctcqmiOhYA/twlxskI1XXsJYU6mmLOxN3w/oWVzlw6X0oZW15EIrnVrn8BKO/GniqSDChTGJtA0RgQMWe7vFJH1qdBqQppI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCHyy00B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCHyy00B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DE5C4CECF;
	Tue,  3 Dec 2024 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238787;
	bh=ta3n8BYtc28gm4afNKVG4n9Lr5lSUnrZi/aDDArthhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCHyy00BhxRCjaUIs9+tOo8QWjs/02ajXH7Nam6y90RPiQKJdAX1KBBxpqLykMphd
	 ORc5C7vuNCIztRL5Dbq4MzuSKLtKGxrLVlfcqArEXk+oUsamlFmD+CQ6TMNeAOnLD+
	 ohcHLwix3aZjO9GxPLQ1/L5NrMP6oFpbKaaEfSLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 396/817] cpufreq: loongson2: Unregister platform_driver on failure
Date: Tue,  3 Dec 2024 15:39:28 +0100
Message-ID: <20241203144011.333660444@linuxfoundation.org>
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
index 6a8e97896d38c..ed1a6dbad6389 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -148,7 +148,9 @@ static int __init cpufreq_init(void)
 
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



