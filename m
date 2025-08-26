Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC18F2E88B7;
	Tue, 26 Aug 2025 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219009; cv=none; b=Ix9Qp73dOWImdErhecgVIwsTIsMj5jy1+iBNt+W9EipQ11L/TH3Ws9EhHRqHKa7LZwsoAoqT8CzVCGI0bgQPiQcHbasBtRw3iC3raW7dGlUxLL/TLV10hbpLwj3h+P2VtmUVhroSgU0/0Q7whlZGZDZMBNOM+E1Tmv8EfWTkgL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219009; c=relaxed/simple;
	bh=JOheNb2vZ9hwEsxvk5j+nQ7jlnE/eoNr7TxyXpcSI0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9vxOWcY4bWNQ0lyuyLyGtVPDFXVDPGOKyo9qzPd8sVdu1JNK3DFC+qdmklDzBF3EGE1z88J0QF4fA2PqC3fSA0zCLZghWRxYtTTBf0PLmA4dmL+G42NTQjDejQGFBA8A4G9KOOXdilqAVdUS4SE+Feoe12jm6USj1dNc3HrlYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL/cOdnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL/cOdnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3477FC4CEF1;
	Tue, 26 Aug 2025 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219008;
	bh=JOheNb2vZ9hwEsxvk5j+nQ7jlnE/eoNr7TxyXpcSI0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mL/cOdnU2Y4mOc5hB3rL+VlPQLHQ+1i6kaHgjG/f915cfrWxVusNYcMQq6ub+JLLI
	 2shgPYHAmr0sFa91HxoKfW13WSdRZDH8lqWzIIi1TX80M7poudVapa0QKDDFBda2eT
	 9lsxyBM1DCF5bmfBrFKPiw3rRLv+7x1V3f+MBj+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 186/403] cpufreq: Exit governor when failed to start old governor
Date: Tue, 26 Aug 2025 13:08:32 +0200
Message-ID: <20250826110912.019310563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 0ae204405095abfbc2d694ee0fbb49bcbbe55c57 ]

Detect the result of starting old governor in cpufreq_set_policy(). If it
fails, exit the governor and clear policy->governor.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20250709104145.2348017-5-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 00f12d23077c..0f8777343e21 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2483,10 +2483,12 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	pr_debug("starting governor %s failed\n", policy->governor->name);
 	if (old_gov) {
 		policy->governor = old_gov;
-		if (cpufreq_init_governor(policy))
+		if (cpufreq_init_governor(policy)) {
 			policy->governor = NULL;
-		else
-			cpufreq_start_governor(policy);
+		} else if (cpufreq_start_governor(policy)) {
+			cpufreq_exit_governor(policy);
+			policy->governor = NULL;
+		}
 	}
 
 	return ret;
-- 
2.39.5



