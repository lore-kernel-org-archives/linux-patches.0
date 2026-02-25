Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC1D1D5ABA;
	Wed, 25 Feb 2026 01:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982864; cv=none; b=hnzKRn+XGGYPwpc3by1CBNR/8jL9yxSbihj/kPMdePsmOKreSHb1BXdKR8Y/cxxuYHHgy+b8J/YX6UrbpN8WNwkIUTk2rvCAa2YuJXhbmqlgV8JIcgbzkKhef7MNPv4s30adAKgoY9u8lu0QwGCmIbKmc7xcFYsqtmTLVVL9BQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982864; c=relaxed/simple;
	bh=bPCPVlHxZZYXzC/h1suOXTnukHjoGzJClPesrldqpfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9PzAH4PhzqP4DUMblrwstag42nmi/iQc1YhGB0G3iJ4TNYGMVeRfUOHxV1/AyMmbEk+fDZcrySVkXEM4W2CemdgQDbdj/VSy9orz/3/rLuOwnLrA55N+2RyIX6Gy5CmNtxfk1UFxi/gDXK33xCic8qnZGdUqAsQkeu8+NRBWIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYsDEQ9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYsDEQ9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA9EC116D0;
	Wed, 25 Feb 2026 01:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982864;
	bh=bPCPVlHxZZYXzC/h1suOXTnukHjoGzJClPesrldqpfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYsDEQ9medfcndtlOZcMFrWTAUr+7h+YaSgEtwl5V+JfLdarBbi4NkUnzlWOvXyw1
	 urylAxOL2hnDaGEgEr2uF2VNIl0+GtixJz5zZpSmWKwxMpSfDLrR+RGBNVXw8z/3z4
	 NUYk8+Phvf7ecpPyqe9JtFvyyj7zOyd6GqCWvnvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 051/781] cpufreq: scmi: Fix device_node reference leak in scmi_cpu_domain_id()
Date: Tue, 24 Feb 2026 17:12:40 -0800
Message-ID: <20260225012400.952892321@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 0b7fbf9333fa4699a53145bad8ce74ea986caa13 ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In scmi_cpu_domain_id(), it does not release the reference.

Fixes: e336baa4193e ("cpufreq: scmi: Prepare to move OF parsing of domain-id to cpufreq")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index e0e1756180b0c..c7a3b038385b5 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -101,6 +101,7 @@ static int scmi_cpu_domain_id(struct device *cpu_dev)
 			return -EINVAL;
 	}
 
+	of_node_put(domain_id.np);
 	return domain_id.args[0];
 }
 
-- 
2.51.0



