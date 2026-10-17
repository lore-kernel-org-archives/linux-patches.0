Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E273803DC;
	Sat, 17 Oct 2026 16:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253982; cv=none; b=PT+L68G/3iG70q+LEn3jySNIJUHjXvItYsMkccShByyzEKDbXgXjxXq3b+umQgDqDJ5Vq0xT1Q+0VvhqmsFk3WpAayxWMADpBvV6IgaBpcAx/myHyQAIqRm3Ztf0AK2HVyknFxLFlC8EAdWtTUHIupuBKPw86G2lrPNqBSFRpCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253982; c=relaxed/simple;
	bh=B2UN32ZAjoC+NVQh4OsHv8MDz0+mHXiUZdZjmsydVLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXkZ1310aLx05JxQt6Su/hlE1fyXy2o3VjBm8YATVmVVkiIqvsmf0jc7eHWIZxxxNv4j8Ivflg81NoNzt9YSnK2wlyYUuEtRQZAt+r9HBNu1rqGR1jhxqv1aj9I2laUBBqv+faR9dTUbjGChg0Q8kYSlT09S4Bihmrx78gL8vtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJEXqKiw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJEXqKiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EF61F000C4;
	Sat, 17 Oct 2026 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253981;
	bh=YQYk/0xe0q+shKKdj8pokHe9GX1HeZxl/yd9BiuB8GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJEXqKiwLbihEFcditFHMHPIa6XD7RamdZg97nqhqAFsHh77wka4GpbaSIwADrvqi
	 cboFz3Z1ifrtl0vFCgjbJDjinMBqCZBJ4E0s5lIBaRluLMXld+gqDEfyIyuxFVqesF
	 tGMvbnGq4O7Z9t6DGVUqbMfYqQtWN43sP4mRdL6k=
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
Subject: [PATCH 6.12 298/869] drm/amd/display: Fix dc_link NULL handling in HPD init
Date: Sat, 17 Oct 2026 17:52:19 +0200
Message-ID: <20261017160044.715800932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
index a215234151ac3..82bc3dcd3f652 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
@@ -913,8 +913,9 @@ void amdgpu_dm_hpd_init(struct amdgpu_device *adev)
 			continue;
 
 		amdgpu_dm_connector = to_amdgpu_dm_connector(connector);
-
 		dc_link = amdgpu_dm_connector->dc_link;
+		if (!dc_link)
+			continue;
 
 		/*
 		 * Get a base driver irq reference for hpd ints for the lifetime
-- 
2.53.0



