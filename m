Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51638381B1;
	Tue,  3 Dec 2024 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241382; cv=none; b=Ee4gJM3gVBvBR8hPD6rvIoBbdLOVs9r7MRztPwwScpLpjTVukFrj4sQ6ze5kKFYq8ExPH6oCdilY5jcpG6ITj4P0xDP7FGbCENgGVJHNez2c2w6YbK+IFmJXcAc8fMzrZIql+iop2YDn9uhKfHvELeiVEmVachczGbrqHLAGhIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241382; c=relaxed/simple;
	bh=t/ANp1sf/+oz8nlYA20XeFGhYsqxYyO6NQcpRC+3/uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri4GeGjYf/o+1PrKrHi1wql9SpOC8edEqn+4y8y4sMDrbeFAA62CzQsWFYbWLcjg9m/493SSJAseF2pPtC81Kv1XVDZqh/WEh+BmZKQ+xQ8sSAd9VVj7WuzDhV1zZyB+3QE4DN0k5yA/ETZuS9iegYe0prGXlp6tJMvFUX9zoaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWYYgkuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWYYgkuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8714C4CECF;
	Tue,  3 Dec 2024 15:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241382;
	bh=t/ANp1sf/+oz8nlYA20XeFGhYsqxYyO6NQcpRC+3/uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWYYgkuWOoAcVQVY4IxYNX2f8oT7xgGrZq6G6sbFiOjK5sLZang0KhL9Mtr1DlGKp
	 +0fTjCbqJxr7PppV5gV8g4na7ND1MBGTDscor7iwJSJMk3spcncAhwWn/uFswcpXI1
	 tuYShadh/iy65ilOCU0b0ZXLi3XlhV3LUpsx+/VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 376/826] cpufreq: loongson2: Unregister platform_driver on failure
Date: Tue,  3 Dec 2024 15:41:43 +0100
Message-ID: <20241203144758.432065640@linuxfoundation.org>
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



