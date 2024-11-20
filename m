Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186221C8317;
	Wed, 20 Nov 2024 13:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107604; cv=none; b=YLMu7o5Udr14RdKz8rLbHCZlR66z2N5QhFuCcbsSer4Iv9A3rXqw3abKYRsfAYHHLA6ZTA+lydVSRccBMyNeb/YXN3sgig1193zcVRy4CtY9v3muvYmc4GVcc193U0sHnDqYuKtmjy/PZItYORbfrexFFQ0cA9KCJDgqFR4oYiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107604; c=relaxed/simple;
	bh=Kv04WEcVbSh1lKPV6uWXf30tpmm+PcsXZgKDhhXUK6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5M0pbBijg/y2IvVwmPkDX6H7gF9GqomPM3kIOCpP4U0pKmBxjgJFA0cciZP9++po0gauTlaU2Caxp/BVxrFgsKZWHLlscwzLivMQ6YSA/TVnmUN7YHEFSatSOptu+pBN3KB5W6Z0B3zBK/nAXdB4nO12VSQZE72Pwc9bXjQtUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reSVDqHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reSVDqHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC813C4CECD;
	Wed, 20 Nov 2024 13:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107604;
	bh=Kv04WEcVbSh1lKPV6uWXf30tpmm+PcsXZgKDhhXUK6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reSVDqHxxC0bS4Abm5uUUWfbwabERpXOk2YXtRLGArVIELJR/QHHHaaLbbF0/8gFz
	 AuecRPVCm8V+5YaapmRryvt25RHc8WSjiHyszPFfFshv1I9gvlXtTTcIUWBvj11D4u
	 kBsblmeNbmX9oxOWr6TLmFAnbE/iz5+QW+HcAjew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiaHsuan Chung <chiahsuan.chung@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 54/82] drm/amd/display: Adjust VSDB parser for replay feature
Date: Wed, 20 Nov 2024 13:57:04 +0100
Message-ID: <20241120125630.829345425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 16dd2825c23530f2259fc671960a3a65d2af69bd upstream.

At some point, the IEEE ID identification for the replay check in the
AMD EDID was added. However, this check causes the following
out-of-bounds issues when using KASAN:

[   27.804016] BUG: KASAN: slab-out-of-bounds in amdgpu_dm_update_freesync_caps+0xefa/0x17a0 [amdgpu]
[   27.804788] Read of size 1 at addr ffff8881647fdb00 by task systemd-udevd/383

...

[   27.821207] Memory state around the buggy address:
[   27.821215]  ffff8881647fda00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   27.821224]  ffff8881647fda80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   27.821234] >ffff8881647fdb00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   27.821243]                    ^
[   27.821250]  ffff8881647fdb80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   27.821259]  ffff8881647fdc00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   27.821268] ==================================================================

This is caused because the ID extraction happens outside of the range of
the edid lenght. This commit addresses this issue by considering the
amd_vsdb_block size.

Cc: ChiaHsuan Chung <chiahsuan.chung@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b7e381b1ccd5e778e3d9c44c669ad38439a861d8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10725,7 +10725,7 @@ static int parse_amd_vsdb(struct amdgpu_
 			break;
 	}
 
-	while (j < EDID_LENGTH) {
+	while (j < EDID_LENGTH - sizeof(struct amd_vsdb_block)) {
 		struct amd_vsdb_block *amd_vsdb = (struct amd_vsdb_block *)&edid_ext[j];
 		unsigned int ieeeId = (amd_vsdb->ieee_id[2] << 16) | (amd_vsdb->ieee_id[1] << 8) | (amd_vsdb->ieee_id[0]);
 


