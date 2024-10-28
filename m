Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C51A47;
	Mon, 28 Oct 2024 06:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097976; cv=none; b=KOAU4+rOBtBMz75+EEvTCkWV1Kwu2VGaVX04Am+mVpRJgIQrUTZGW5YluOOZe94W9CKXYg9AB62nuk4hcfTwDgJ6/3xssLgLE/Y+rSz39lDrUxyzB39FSfiZ1GIiZUQnzWoGauLkXWgI0EAOWLepdADgwABZ8fh6ArAViHANjNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097976; c=relaxed/simple;
	bh=vPepaF52yS9YcF1RI42wO0smhnD42PbjGM4j4PdB/CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaezAiF9uj04yDiypnbgsDMSEhwPpGYGocpHM8f0mCFOPFCSjZlbM/Yq7gATnkQXJ+KIkwk5A2rTKNtsdrB+35sGDJkHcO5zubX/A+451W5s8ECWH7NXi+pVC2v05TaPo+Ju8QU9hWT0++YKhSjDi5DsfOs2qDrc++l4aVuCLtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP57Nbjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP57Nbjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC012C4CEC3;
	Mon, 28 Oct 2024 06:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097976;
	bh=vPepaF52yS9YcF1RI42wO0smhnD42PbjGM4j4PdB/CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP57Nbjbyd/05vI0Om9HwWwKOLFwbugjuqHCBMGDq7lWGVl1NVxr8/++MYeUOc922
	 r/qVYAEuWL2tZ918Zt3H8reOr2cSL0CicelVtjRTluEzMIFmndNLtRxZII2qg7x08R
	 VyipgBMhJSj9yTNZCnOHDfMky0BcVK974egJSIa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 008/261] cpufreq/amd-pstate: Fix amd_pstate mode switch on shared memory systems
Date: Mon, 28 Oct 2024 07:22:30 +0100
Message-ID: <20241028062312.220457694@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit c10e50a469b5ec91eabf653526a22bdce03a9bca ]

While switching the driver mode between active and passive, Collaborative
Processor Performance Control (CPPC) is disabled in
amd_pstate_unregister_driver(). But, it is not enabled back while registering
the new driver (passive or active). This leads to the new driver mode not
working correctly, so enable it back in amd_pstate_register_driver().

Fixes: 3ca7bc818d8c ("cpufreq: amd-pstate: Add guided mode control support via sysfs")
Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20241004122303.94283-1-Dhananjay.Ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 589fde37ccd7a..929b9097a6c17 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1281,11 +1281,21 @@ static int amd_pstate_register_driver(int mode)
 		return -EINVAL;
 
 	cppc_state = mode;
+
+	ret = amd_pstate_enable(true);
+	if (ret) {
+		pr_err("failed to enable cppc during amd-pstate driver registration, return %d\n",
+		       ret);
+		amd_pstate_driver_cleanup();
+		return ret;
+	}
+
 	ret = cpufreq_register_driver(current_pstate_driver);
 	if (ret) {
 		amd_pstate_driver_cleanup();
 		return ret;
 	}
+
 	return 0;
 }
 
-- 
2.43.0



