Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBF84F5E06;
	Thu, 17 Sep 2026 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667830; cv=none; b=OGU6UAlMV8WVAOfMINYJIEeEGFeEiunAdQOVmDK6T6oDJNem+D8c17OdHrevsG+QZerATkK2gQ2lTqvHFUnjc8cHCcDbEpbm4TXWwhLQ+0cT5OABZPWnF9gSuh4yD73kDDLjxpUylzvUfLHczE+hk5ItXoAIue2eBG8mFF2PNcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667830; c=relaxed/simple;
	bh=7Ctsxs0ln6+mxQDqfI+cKfGzl9KRd1FO80RELoRBVSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lt7NOht9jIXJzHyv7cay7h0G0nyDZ/wCtNpYgFYflPjyTiUIhib4zKPoAxr+5U+Y58Iw9U2mIAc6q8xpx5q6htZSppRPIslu6Jfqq+omhEt64cp4x8izoWgZbVilhUFYAPuifEhhKv/P9Kpx8H++RCrh2JwTaHuSTk7t16Pkc9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7C90EM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7C90EM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238211F000FF;
	Thu, 17 Sep 2026 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667828;
	bh=e8jEkLFWGVc4UMow6wQQqW1sThTrrJTkqILnzs3m9T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7C90EM/O3CpWIN7sBjB+39qgiwpZENTShkjIs0LWH/0lI+ed1ZBgAxRwT/j+GDiL
	 lIq5z2cV0NIqsiUEzwl2ANh2BmRgIR0KYcK56TPgMuYJtvN5roAFw/L+dDqFlk9ak/
	 Mwv9ne5JEsD76J6fom6coUhxWqKyvWLDrjmODofI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwu Zhang <shiwu.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0224/1102] drm/amdgpu: fix buffer overflow during vBIOS update
Date: Thu, 17 Sep 2026 16:02:47 +0100
Message-ID: <20260917151545.203832799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiwu Zhang <shiwu.zhang@amd.com>

[ Upstream commit 6229898d46c0cbc238a6fe9f11c1ea12cf8bb9c5 ]

Clamp the buffer postion to write by setting the bin attribute
to the maximum buffer size so that VFS layer will block the
out-of-bounds accessing.

Signed-off-by: Shiwu Zhang <shiwu.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 435376c7f5e28..8ef41dc49f74a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3979,7 +3979,7 @@ static ssize_t amdgpu_psp_vbflash_read(struct file *filp, struct kobject *kobj,
  */
 static struct bin_attribute psp_vbflash_bin_attr = {
 	.attr = {.name = "psp_vbflash", .mode = 0660},
-	.size = 0,
+	.size = AMD_VBIOS_FILE_MAX_SIZE_B,
 	.write = amdgpu_psp_vbflash_write,
 	.read = amdgpu_psp_vbflash_read,
 };
-- 
2.53.0



