Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7C41F5FA;
	Mon,  4 Mar 2024 21:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587853; cv=none; b=HsUmgfqHbBHU+i53Zyy+JDTs2TUKc8+PEpabNW3f7OI/NcGbFNfemld7dCtBmf5zkrytfJo0dXRRMH/Cn5xhIXX3cp2UnUbF/NpSIB7VF6HXrhuQ/faFdTMQxJimwFNBJ8uWHrzDDnqbzGFhLBZMmMGdeAv9Mm9Xf18HntIu6nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587853; c=relaxed/simple;
	bh=WcANRqZeCfxcMBATQK4WsmVIBAdmmZg9lotHksAMHOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEnwF8pC8Eis4z5Y8vua7J03WzE+KUAmuJstCZgNtyIrOIqZw8X5bipe5MFAUXV2TVSmXhoBE404nvIB+stXlteUyqPZ3mcIy1qgL3En8o9CD3jK79yiNx1EFvELBcPsC6GkQ8+m/96bTthQaeUEyWO3g5fYG6rVm8bPqHXMbH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBLf8LTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBLf8LTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D296C433C7;
	Mon,  4 Mar 2024 21:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587852;
	bh=WcANRqZeCfxcMBATQK4WsmVIBAdmmZg9lotHksAMHOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBLf8LTIZUjepiPRxXmahVuaa7RtlhuJuWPgGrFitmxI+C/PdKPusbKAvt/KhGySO
	 qNaVNuHDSmAxI+O+SpTfAKxIDE/boyV5ExTs/hmtUT+1R03ITK+ocRCUtLTJ3bTzrW
	 VnatJOANDBqgLw2AMGyCb8KeyaiQqhyXUjlXBhMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.7 114/162] pmdomain: arm: Fix NULL dereference on scmi_perf_domain removal
Date: Mon,  4 Mar 2024 21:22:59 +0000
Message-ID: <20240304211555.421498729@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

commit eb5555d422d0fc325e1574a7353d3c616f82d8b5 upstream.

On unloading of the scmi_perf_domain module got the below splat, when in
the DT provided to the system under test the '#power-domain-cells' property
was missing. Indeed, this particular setup causes the probe to bail out
early without giving any error, which leads to the ->remove() callback gets
to run too, but without all the expected initialized structures in place.

Add a check and bail out early on remove too.

 Call trace:
  scmi_perf_domain_remove+0x28/0x70 [scmi_perf_domain]
  scmi_dev_remove+0x28/0x40 [scmi_core]
  device_remove+0x54/0x90
  device_release_driver_internal+0x1dc/0x240
  driver_detach+0x58/0xa8
  bus_remove_driver+0x78/0x108
  driver_unregister+0x38/0x70
  scmi_driver_unregister+0x28/0x180 [scmi_core]
  scmi_perf_domain_driver_exit+0x18/0xb78 [scmi_perf_domain]
  __arm64_sys_delete_module+0x1a8/0x2c0
  invoke_syscall+0x50/0x128
  el0_svc_common.constprop.0+0x48/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x34/0xb8
  el0t_64_sync_handler+0x100/0x130
  el0t_64_sync+0x190/0x198
 Code: a90153f3 f9403c14 f9414800 955f8a05 (b9400a80)
 ---[ end trace 0000000000000000 ]---

Fixes: 2af23ceb8624 ("pmdomain: arm: Add the SCMI performance domain")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240125191756.868860-1-cristian.marussi@arm.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/arm/scmi_perf_domain.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pmdomain/arm/scmi_perf_domain.c b/drivers/pmdomain/arm/scmi_perf_domain.c
index 709bbc448fad..d7ef46ccd9b8 100644
--- a/drivers/pmdomain/arm/scmi_perf_domain.c
+++ b/drivers/pmdomain/arm/scmi_perf_domain.c
@@ -159,6 +159,9 @@ static void scmi_perf_domain_remove(struct scmi_device *sdev)
 	struct genpd_onecell_data *scmi_pd_data = dev_get_drvdata(dev);
 	int i;
 
+	if (!scmi_pd_data)
+		return;
+
 	of_genpd_del_provider(dev->of_node);
 
 	for (i = 0; i < scmi_pd_data->num_domains; i++)
-- 
2.44.0



