Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61FC35A942;
	Wed,  3 Dec 2025 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778914; cv=none; b=tAzpSl3mO5UhAaa79Z6s6KGXYR1Pd5b2nz1JraWsZrqWCEpIGBMuMTCMHK6Svn0Vd1PssSb/K7CB2XMzxgaZZM03aU525rIjRgRhnByk3DXzRwOU5/Hp4UpPIBcn664NuO1W2LPPWwu0zP5shQlSf0oilv83/DgdgQ/+8ifTpHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778914; c=relaxed/simple;
	bh=aMNvChc1grJxas3PHzjB6NnPNp5MmD+8D7/FAfdj+rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kphaAo/1B+nfRRBSvqiV1WZxemRL9oSF0X0Dv0ZkUO8Z+YpKUolWBSEUFOF07EFTARLzGVGZ8Kquz08Tv2pso3Q7VL1TmzqlUMx8NHi0Vl8glJUx+mJ8veAg2MlbFivjKFPHjyVIwy/egYCYe6JWlJ9mr9a98I2s6hp++9IQYIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIxYkqyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIxYkqyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F4BC4CEF5;
	Wed,  3 Dec 2025 16:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778914;
	bh=aMNvChc1grJxas3PHzjB6NnPNp5MmD+8D7/FAfdj+rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIxYkqyDa+zpJJSlAvbjFTWGbO4lRzKQpQeTA8ggXOfpDCNBsiznrtp9ZW0vaATxx
	 tn1G4V9kXtkdO323+2TUTA6l4nKD1IbMNspwU3V05iNpFGdFw1yekd5rz2GTHtv2DC
	 aC4C/pEkg0kiCqK3ew3ryqQbHvYvNQOv0YcL8TpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Beier <nanovim@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/568] cpufreq/longhaul: handle NULL policy in longhaul_exit
Date: Wed,  3 Dec 2025 16:21:39 +0100
Message-ID: <20251203152444.292622392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Beier <nanovim@gmail.com>

[ Upstream commit 592532a77b736b5153e0c2e4c74aa50af0a352ab ]

longhaul_exit() was calling cpufreq_cpu_get(0) without checking
for a NULL policy pointer. On some systems, this could lead to a
NULL dereference and a kernel warning or panic.

This patch adds a check using unlikely() and returns early if the
policy is NULL.

Bugzilla: #219962

Signed-off-by: Dennis Beier <nanovim@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/longhaul.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 3e000e1a75c6c..9b6ec68753dde 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -953,6 +953,9 @@ static void __exit longhaul_exit(void)
 	struct cpufreq_policy *policy = cpufreq_cpu_get(0);
 	int i;
 
+	if (unlikely(!policy))
+		return;
+
 	for (i = 0; i < numscales; i++) {
 		if (mults[i] == maxmult) {
 			struct cpufreq_freqs freqs;
-- 
2.51.0



