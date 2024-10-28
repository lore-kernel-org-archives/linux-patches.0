Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB3F18EFD6;
	Mon, 28 Oct 2024 06:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097505; cv=none; b=l+m/bhg1QMTn2ETpWJTiege6Ui3bGFQUhetEuFhf2YJ2ZvCkW/pmwbtbh0HgGJ1++gvkKKiS0lU02ZC6JXNXy69XMljH87r5pjy1XT79kl1JYAsDpzQjeAx87EwIPEwmJzpoQErNyMiCyZAFo1dSTbXe6nreLf0bzn3m+wiF81k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097505; c=relaxed/simple;
	bh=AM62Q4Qz+lfhLx1rjg8VP2GWseNUxhs38MOswTtJi3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO5jlAop/oIEkgUt5rLKcsoq43Mf1YeYky3GVgBweczpYdF1TfaSJQ+PcxQ0dY3DDL5OGXzC44uJA5tyV7rfASIHOJVc0wvJw9XedLGdMSQBA16jrU0GavpfE0oNt+bLa/+hSDxAysorQ8yVqSkgPN1oDl1rdp8gM84kIORpbzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtwTtgKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtwTtgKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAA2C4CEC3;
	Mon, 28 Oct 2024 06:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097505;
	bh=AM62Q4Qz+lfhLx1rjg8VP2GWseNUxhs38MOswTtJi3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtwTtgKWDDTqVKp29AMpGyQW3oozEXaqqsY+5d9pRzeoEF4Usv2jn1oBaYE31WTDP
	 dvc0JzCYokX3F+S/BUNlX7su9zkTNRksJU2GnidjQtI32HbjtX7wnQ0j4VFNpsunHr
	 mz+kMD53BVFuITKKGAsr9FShTRi5CDdD2YadWEMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/208] cpufreq/amd-pstate: Fix amd_pstate mode switch on shared memory systems
Date: Mon, 28 Oct 2024 07:23:04 +0100
Message-ID: <20241028062306.761902710@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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
index f461f99eb040c..8c16d67b98bfe 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1061,11 +1061,21 @@ static int amd_pstate_register_driver(int mode)
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



