Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A381021660B;
	Thu, 12 Dec 2024 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024057; cv=none; b=ECApwVrZkxQ+swqtVncu2Tws+iqmk10wM1xS48jTs93e5fjue9rYgFQA+W2HHlRFosi1ybZnCzUQBp6tUQWh3Fih3IRQL5Wc2I2+sHVxkhfCXss/2/rhvlpk/V7JRUKI4YnOX5hF0c75qI/RvQvXJqmXEiDZSZyyUrliRa3ETlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024057; c=relaxed/simple;
	bh=474OyoAA377XTanm+JQV3+L07br42q5PirsoCxa9qek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNYzy2wxs17/8L8I8TwBD7cknKZPrQsqnjpsxcTpi3kOOhCenUW/X3LPni2QyCfolFSMG+5Cgzy3TPoEYtoPwZ5aOxfoZX3BCIUbzqs/F3DDw6Z5x5LuZgaUk8klS3H+XfW4FAHqZoEZ38wZSitldZhaiyjZjdTfGR5Ywoy7/6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbONKA3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbONKA3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F82CC4CECE;
	Thu, 12 Dec 2024 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024057;
	bh=474OyoAA377XTanm+JQV3+L07br42q5PirsoCxa9qek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbONKA3YSCApzp7VBLdhgyeJC6FD6vpSBKDt3zFfbwGP3aEIP7z5Hs//p3KR3vu9j
	 FOlttdpN3Q61mWrBSRGQPPFmlasvVk9AN3sVq0ofZxRXrId3ia34jQopGZpK3sMNCJ
	 NaWvdUyajTMdlDMp9/TbALW7cPfTQhWhe4VXidH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/459] cpufreq: loongson2: Unregister platform_driver on failure
Date: Thu, 12 Dec 2024 15:58:29 +0100
Message-ID: <20241212144300.266234154@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d05e761d95721..e1893e33b1a94 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -155,7 +155,9 @@ static int __init cpufreq_init(void)
 
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



