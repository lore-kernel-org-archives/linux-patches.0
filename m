Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D06615696E;
	Thu, 12 Dec 2024 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025214; cv=none; b=OwELBZeNIXZQ2zDrG9cwrL9qdhOwUQL6QZdvBDgPKeqAF14v0cFGjzJoCBol+1dx2smbVL9K530I5oEzvpv2m3CO9sEn+Rl3lsMZPI6iM1hYa8UbBhlkpSj1os+7Xgy5BhN6xzn2RlHOM75suww4ICd0MLusmKgHiv7pK+ETd6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025214; c=relaxed/simple;
	bh=RcfVm5RNbvcUJhCHy79NCep43y8XgXa6Hylw4lCQAqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeJ+k/av6uKZ01xwH7pX6NNKqpyw8tmx9g43/OH/QRTqFDZcxKe42d/XQ6ZDDgSusJ4vTQTlFv4fFxMaaRBmpJnzPA1/qcOSnMubMDFgzCe6iB5s+4rH4sssONoRHUAaO8nNj1TOsyo7c6yaYjVvrUY/lr0atri4LNcbo1ISW0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHr3WEGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHr3WEGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15555C4CECE;
	Thu, 12 Dec 2024 17:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025214;
	bh=RcfVm5RNbvcUJhCHy79NCep43y8XgXa6Hylw4lCQAqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHr3WEGj8neMtn/5xrdr4jcasGSn7Orn24GPU6xKg/u+NvVpQqdkbfxgKQo5Q6VNO
	 bMzM1Kt3f5UrXFM0FCj1IB7gh32UN1hgtY/DgBW87P800vvKlCpOlkuLXbCPz1wmj5
	 IgAVOUAs4KOa25XyDHXkSaillSJclH/IG8VUKWrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/321] cpufreq: loongson2: Unregister platform_driver on failure
Date: Thu, 12 Dec 2024 16:00:12 +0100
Message-ID: <20241212144233.703801189@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 890813e0bb768..9685c35c0cfad 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -167,7 +167,9 @@ static int __init cpufreq_init(void)
 
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



