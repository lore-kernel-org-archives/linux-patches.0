Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1693A1A3F;
	Sat, 17 Oct 2026 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258704; cv=none; b=uPIZ27eE9f02BQS2OhKp/wD+OL/onvbwaJDQ7zf0opP7UFvGcAqNIg1OxoVhT6pbGpi+ADhsz2IGRnm7cR66CaL3WfcuBGQbgG7+gFvWVDUlUkMXlE6xwQxC6a2k/TYJREimiZizheEF03sSN5xKOjTVN9c2VjkRia2EZRAnXKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258704; c=relaxed/simple;
	bh=PdFqvzgaaYTb3CfQKNs/NNiSMT8z77u0DAR8PgrpSx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ONFHe0KlOavCpSwB0y5IEq+I2u9fWMdt14sVdmLWwwelR5dwZuDuZaSJ1H8rqNi3uMyDORA/BJ++ckjDAGDR2JKXlq4n0/HbWEcyXDO97/AglniPSz7wsjAvIaAjs3imkIuvYbBFZxbv+6cmMXKbq/prK5lBRq0tiTEjSmBP9mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejeLSTYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejeLSTYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19071F000C4;
	Sat, 17 Oct 2026 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258703;
	bh=vnjuv1lQoBMo12P8JW2JCb/IXQkbCATbHa2U7+1CD4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejeLSTYUifiKjobDexqaPyOdHFEhvuE/rTeH2Iiasnp0AFkap9Y+fT2Ynjb+w1iZ0
	 L152Cd4Y04tsDJ7hVjsMAcOFHbKGrnT3oheXF4fzqD5w4ZSkZKbipMd9uSzpbocg0p
	 gT08oukpUHgiRvKRCqBlprDC+qBZtlmOLzKhCwAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	ChiaHsuan Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0970/1674] drm/amd/display: Fix dc_link NULL handling in HPD init
Date: Sat, 17 Oct 2026 17:54:02 +0200
Message-ID: <20261017160456.023534671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 226a40c06a183abaeb7529a4f54d6c203bd14407 ]

amdgpu_dm_hpd_init() may see connectors without a valid dc_link.

The code already checks dc_link for the polling decision, but later
unconditionally dereferences it when setting up HPD interrupts.

Assign dc_link early and skip connectors where it is NULL.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_irq.c:940 amdgpu_dm_hpd_init()
error: we previously assumed 'dc_link' could be null (see line 931)

drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_irq.c
    923                 /*
    924                  * Analog connectors may be hot-plugged unlike other connector
    925                  * types that don't support HPD. Only poll analog connectors.
    926                  */
    927                 use_polling |=
    928                         amdgpu_dm_connector->dc_link &&
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The patch adds this NULL check but hopefully it can be removed

    929                         dc_connector_supports_analog(amdgpu_dm_connector->dc_link->link_id.id);
    930
    931                 dc_link = amdgpu_dm_connector->dc_link;

dc_link assigned here.

    932
    933                 /*
    934                  * Get a base driver irq reference for hpd ints for the lifetime
    935                  * of dm. Note that only hpd interrupt types are registered with
    936                  * base driver; hpd_rx types aren't. IOW, amdgpu_irq_get/put on
    937                  * hpd_rx isn't available. DM currently controls hpd_rx
    938                  * explicitly with dc_interrupt_set()
    939                  */
--> 940                 if (dc_link->irq_source_hpd != DC_IRQ_SOURCE_INVALID) {
                            ^^^^^^^^^^^^^^^^^^^^^^^ If it's NULL then we are trouble because we dereference it here.

    941                         irq_type = dc_link->irq_source_hpd - DC_IRQ_SOURCE_HPD1;
    942                         /*
    943                          * TODO: There's a mismatch between mode_info.num_hpd
    944                          * and what bios reports as the # of connectors with hpd

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Cc: Timur Kristóf <timur.kristof@gmail.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Mario Limonciello <superm1@kernel.org>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: ChiaHsuan Chung <chiahsuan.chung@amd.com>
Cc: Roman Li <roman.li@amd.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
index 29e1b252ec730..eb9003d3cfaea 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
@@ -908,6 +908,9 @@ void amdgpu_dm_hpd_init(struct amdgpu_device *adev)
 
 		const struct dc_link *dc_link = amdgpu_dm_connector->dc_link;
 
+		if (!dc_link)
+			continue;
+
 		/*
 		 * Get a base driver irq reference for hpd ints for the lifetime
 		 * of dm. Note that only hpd interrupt types are registered with
-- 
2.53.0



