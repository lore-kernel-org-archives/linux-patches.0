Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF7D139579;
	Tue, 27 May 2025 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365753; cv=none; b=mK65xmOZcbaYVd7BoU1TVV3iIIjQSghBojLLAI9RgPi06vdmgOsm5hBNLHVZ9nUltH8iplFhYiBUnadU/ehwSIJbXI53UtRPFr917vs/JtIDBzaeyzMO4gv0FOH0K2JkrKmpNufAzpXikQrpUPn5xymAHZas/IzazvEEHvut63w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365753; c=relaxed/simple;
	bh=FkVUyNg8qS424oy6FDmOkZfPfEeye/R9vVacSH6Z7Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj+Ep6WFq+ffL9h+F6IjEMqCXo72+3Q3IwB+/2b4CvBiDpIilnjB83UEMkgPGGLUADFDoWN7mXpBW782N89Gt2IhlAjcXjB/ylGvg19QYwjMm5wGmuW7TEOMdLinkb3rKuUMXJNHEoKoIEv0iSujQV1FFhE26T1qCIQrZpLI75A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1UUUl5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1UUUl5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914C7C4CEE9;
	Tue, 27 May 2025 17:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365753;
	bh=FkVUyNg8qS424oy6FDmOkZfPfEeye/R9vVacSH6Z7Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1UUUl5wh9p31K+5M4/En+yjumt01aEGPTI7YjxwKophlxeZWDPCxXXXFoJNCymcK
	 K8WiGz6HtS0YJF3zYTRVqIMLksV0WFBdfVrbyp5AVFsUJ0qtv6JW9uP1eTILtnMa3W
	 OU0ot4VGIEF3HhcVb8zjARrtD6jhSf0T6p+a+E7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 447/626] cpufreq: amd-pstate: Remove unnecessary driver_lock in set_boost
Date: Tue, 27 May 2025 18:25:40 +0200
Message-ID: <20250527162503.166260150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>

[ Upstream commit db1cafc77aaaf871509da06f4a864e9af6d6791f ]

set_boost is a per-policy function call, hence a driver wide lock is
unnecessary. Also this mutex_acquire can collide with the mutex_acquire
from the mode-switch path in status_store(), which can lead to a
deadlock. So, remove it.

Signed-off-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Acked-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 9db5354fdb027..7a16d19322286 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -696,7 +696,6 @@ static int amd_pstate_set_boost(struct cpufreq_policy *policy, int state)
 		pr_err("Boost mode is not supported by this processor or SBIOS\n");
 		return -EOPNOTSUPP;
 	}
-	guard(mutex)(&amd_pstate_driver_lock);
 
 	ret = amd_pstate_cpu_boost_update(policy, state);
 	WRITE_ONCE(cpudata->boost_state, !ret ? state : false);
-- 
2.39.5



