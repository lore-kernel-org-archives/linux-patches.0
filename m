Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2884E1AA1C3;
	Wed, 20 Nov 2024 12:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107557; cv=none; b=RjvPqow7WJ2bwZAbsSQIvZlvqhK8Z838JMFlvp8DjfCVi/x3+cXbkwfFtbmeQUFVozbXAUsR6Svwov9Jh8smwzwCCLJ/TuxHGE7VY262bc9hSu+ZvO1H/iVxq7T41xz4Au4Vepn1nMDZ/QSjVtH1vrAnz/gqNlbBXPwGkVey5fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107557; c=relaxed/simple;
	bh=EcsRZL6iKeHxjqz9cVQrwpAaj87PUgVOtyfM8G3AgBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEoJNnesjWRH5orX9suS9C7DP1jmzn9Ok38RMdbCXjCDN6GimR4hQGPoXYrTBPwH+JQnb5ZAY9lU1dv0pAgMVXMaDRNyorZBvO6+jRjfz61e57yyJ1rcZSVOr88Ja5F/yowoQQM8RM/zWOfnif/OSnMikKCrmO8HuSiCZuSKrk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtQIgm/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtQIgm/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED91EC4CED2;
	Wed, 20 Nov 2024 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107557;
	bh=EcsRZL6iKeHxjqz9cVQrwpAaj87PUgVOtyfM8G3AgBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtQIgm/CHFDmHKP/2YyjLuPl1/li8E2pL5MVAo7bLd8ZoQExlU8tJCiD1zj0JrC7y
	 /vho8sAgy0jns5b8aLnbzVVABXqu8GvFCGZRBh5jNBST1mIKtWTMQr4mWkHkWVM2MF
	 9ROtH1/wZR/LUZ4jYJTulp8b8OnzsRmg/HnMEIcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiaHsuan Chung <chiahsuan.chung@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 098/107] drm/amd/display: Adjust VSDB parser for replay feature
Date: Wed, 20 Nov 2024 13:57:13 +0100
Message-ID: <20241120125631.937319797@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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
@@ -12038,7 +12038,7 @@ static int parse_amd_vsdb(struct amdgpu_
 			break;
 	}
 
-	while (j < EDID_LENGTH) {
+	while (j < EDID_LENGTH - sizeof(struct amd_vsdb_block)) {
 		struct amd_vsdb_block *amd_vsdb = (struct amd_vsdb_block *)&edid_ext[j];
 		unsigned int ieeeId = (amd_vsdb->ieee_id[2] << 16) | (amd_vsdb->ieee_id[1] << 8) | (amd_vsdb->ieee_id[0]);
 


