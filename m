Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF7A1465A8;
	Tue, 25 Jun 2024 09:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308995; cv=none; b=n1xpSIIYOm8SF8eJSjIfdkH9qmAQG/nrscLkp4IUJqho6lYvdw3yWSUNEjFaY7ZEHxSZmX7992wRCaR225KztgxIQE/MgAXUV78wCJvh2lR/eWT/O1ZR/eb/RB215iQ/X40oV6birK/CLBJ+GpuhdxcbOXYew26vGyNrlXoaSX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308995; c=relaxed/simple;
	bh=fF4LC0Pd18lvHKytsU9iBYSH1PcZcEG4V8ol6gXWUv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+3QluJlDrNMTctMDHa4wy6W2sJi1A1RSLRgqFC5oN/sSwq9Fh0jK+T+lmJ1N7x555DDDdsGQQBlFyBfSKwIKWt0z9Sw17caJoHzYhPjqkCf+IZCVuI2eWRQEaFVDhhtsDPOd8vxWF59h3CWno/Y9qDSz22ABAwfFv+BMGh3oeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqe5mifL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqe5mifL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77E5C32781;
	Tue, 25 Jun 2024 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308995;
	bh=fF4LC0Pd18lvHKytsU9iBYSH1PcZcEG4V8ol6gXWUv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqe5mifLfSD9j6XUaSStFxt//4u/OrtgciUik9MTny+Hv3PNX97sS6O9NE1idZrc3
	 r/lyc4y0kMCxG6vn+zyrudWjqLbTi6HO5PamRD7BsDMD4GFdihsEMmW6+djdsHih0i
	 dGKFUZza20n6NHX9pyk0HQ/RKXh8ONzL5AWMKFmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Ma <andypma@tencent.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <Perry.Yuan@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/192] cpufreq: amd-pstate: fix memory leak on CPU EPP exit
Date: Tue, 25 Jun 2024 11:32:12 +0200
Message-ID: <20240625085539.476120456@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Peng Ma <andypma@tencent.com>

[ Upstream commit cea04f3d9aeebda9d9c063c0dfa71e739c322c81 ]

The cpudata memory from kzalloc() in amd_pstate_epp_cpu_init() is
not freed in the analogous exit function, so fix that.

Signed-off-by: Peng Ma <andypma@tencent.com>
Acked-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Perry Yuan <Perry.Yuan@amd.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index b8fdfd2c4f6fc..a5f4c255edadf 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1216,6 +1216,13 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 
 static int amd_pstate_epp_cpu_exit(struct cpufreq_policy *policy)
 {
+	struct amd_cpudata *cpudata = policy->driver_data;
+
+	if (cpudata) {
+		kfree(cpudata);
+		policy->driver_data = NULL;
+	}
+
 	pr_debug("CPU %d exiting\n", policy->cpu);
 	return 0;
 }
-- 
2.43.0



