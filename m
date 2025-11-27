Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416D1286416;
	Thu, 27 Nov 2025 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255058; cv=none; b=T3hQuy2SpHrtld9TN7WyHSy1RZpR9CI35lIh6hcRonGo34g9AAUVPBwbBdAffzZIyTWp1zZpU+BVR3KCS1fbBr8AWDj1XtFyJuWiOT1vrwBD+Kvzb5uag21m7/dpM+7FNlWSkomZgfvcsh0bbMGzLAt6W12i8TM1dWU6in9ARM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255058; c=relaxed/simple;
	bh=AIvmQCb23L2VT0MTAytpwEEuPZApP2LbKvEQPHpYmn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcZHL9lNPeeUtNtTDviNgWwNx+GZr5+ab6RmqWzZOnAMPvY6Zf27KOto6p3T8IH9ldF9X1eK9ie0j8rgJ4fGNLKPcCUC+o6MFn9EVby1y+uNmzoJra0Z7bU/0sGgf6cTVv3pHnhuai+GkVSquP7AxSAZS3JbC4tzVMPkMBJi+M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJdxkdgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJdxkdgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49C0C4CEF8;
	Thu, 27 Nov 2025 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255058;
	bh=AIvmQCb23L2VT0MTAytpwEEuPZApP2LbKvEQPHpYmn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJdxkdgp4Y5wR6A6J+xHw0FSoFzTTHGSiNW0tELSdGSQbOavJhILPhfxYcdj5a+WJ
	 lX+3uaEu0HNZbYHDF8U99LUrK+UI1uKfBq8brYmeWZFgl4dhbcw1ATflTSdf8ND5RE
	 kD2fmJGA42UzHCrJhOmJByVtTPRVzf3nfCWsAuUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 79/86] pmdomain: arm: scmi: Fix genpd leak on provider registration failure
Date: Thu, 27 Nov 2025 15:46:35 +0100
Message-ID: <20251127144030.718834990@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 7458f72cc28f9eb0de811effcb5376d0ec19094a ]

If of_genpd_add_provider_onecell() fails during probe, the previously
created generic power domains are not removed, leading to a memory leak
and potential kernel crash later in genpd_debug_add().

Add proper error handling to unwind the initialized domains before
returning from probe to ensure all resources are correctly released on
failure.

Example crash trace observed without this fix:

  | Unable to handle kernel paging request at virtual address fffffffffffffc70
  | CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-rc1 #405 PREEMPT
  | Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform
  | pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  | pc : genpd_debug_add+0x2c/0x160
  | lr : genpd_debug_init+0x74/0x98
  | Call trace:
  |  genpd_debug_add+0x2c/0x160 (P)
  |  genpd_debug_init+0x74/0x98
  |  do_one_initcall+0xd0/0x2d8
  |  do_initcall_level+0xa0/0x140
  |  do_initcalls+0x60/0xa8
  |  do_basic_setup+0x28/0x40
  |  kernel_init_freeable+0xe8/0x170
  |  kernel_init+0x2c/0x140
  |  ret_from_fork+0x10/0x20

Fixes: 898216c97ed2 ("firmware: arm_scmi: add device power domain support using genpd")
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[ drivers/pmdomain/arm/scmi_pm_domain.c -> drivers/firmware/arm_scmi/scmi_pm_domain.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/scmi_pm_domain.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
+++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
@@ -54,7 +54,7 @@ static int scmi_pd_power_off(struct gene
 
 static int scmi_pm_domain_probe(struct scmi_device *sdev)
 {
-	int num_domains, i;
+	int num_domains, i, ret;
 	struct device *dev = &sdev->dev;
 	struct device_node *np = dev->of_node;
 	struct scmi_pm_domain *scmi_pd;
@@ -112,9 +112,18 @@ static int scmi_pm_domain_probe(struct s
 	scmi_pd_data->domains = domains;
 	scmi_pd_data->num_domains = num_domains;
 
+	ret = of_genpd_add_provider_onecell(np, scmi_pd_data);
+	if (ret)
+		goto err_rm_genpds;
+
 	dev_set_drvdata(dev, scmi_pd_data);
 
-	return of_genpd_add_provider_onecell(np, scmi_pd_data);
+	return 0;
+err_rm_genpds:
+	for (i = num_domains - 1; i >= 0; i--)
+		pm_genpd_remove(domains[i]);
+
+	return ret;
 }
 
 static void scmi_pm_domain_remove(struct scmi_device *sdev)


