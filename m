Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED0D2D6639;
	Thu,  3 Jul 2025 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555792; cv=none; b=i3d8NTfkihN24L6sOzJcdx9vpWk4nYNUaT0Kxf64so2YpgW+Vm/R3c6Zf4txgdGxcnHqt7Q/y/fz7oNZ7LvhFUhAt4pdi5vG7mBZGtnzidcSPkj3m9j5UejklSS79aiv2hCXoa4L0sOvmpKIlsJC93MV/j26yQCH4vEmr00IPd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555792; c=relaxed/simple;
	bh=levAjfTVaEpWOeqkByA++j3K42y3Bfl81oyj5/7Z71w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PilS7X47iBY7rUG4ZqaSikGm59Lktvms89JFKMu3NgpgaE3oU+d8Rldw+o2Gbrjf+E9wswgWl0tEwa0ykPQvAB2P6rC3vEybl7Ji6veUeQeiS4OYGXvXPWHu343t3Awwm780kt7AegWgiBQcLFE0VZxcOF1JqJaJcag8wQLgjYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyvsczo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyvsczo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88DDC4CEE3;
	Thu,  3 Jul 2025 15:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555792;
	bh=levAjfTVaEpWOeqkByA++j3K42y3Bfl81oyj5/7Z71w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyvsczo41Qz1JVHQbMOfLRZjhoz5YRweR4Z7xq5vs3DlyhwpxBDVMPAOHRjbbEmFg
	 Oaui3/iRxRKkisoYW9CJIic000pGMn3dnofANapiqy2U9HF4C49cDNjbDP3mIc6Geb
	 X7iHa3wdYE+Sy36OtiTYB39Wevu8N2CmlDPIOA2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Olender <john.olender@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Subject: [PATCH 6.6 123/139] drm/amdgpu: amdgpu_vram_mgr_new(): Clamp lpfn to total vram
Date: Thu,  3 Jul 2025 16:43:06 +0200
Message-ID: <20250703143945.993326069@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John Olender <john.olender@gmail.com>

commit 4d2f6b4e4c7ed32e7fa39fcea37344a9eab99094 upstream.

The drm_mm allocator tolerated being passed end > mm->size, but the
drm_buddy allocator does not.

Restore the pre-buddy-allocator behavior of allowing such placements.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3448
Signed-off-by: John Olender <john.olender@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -435,7 +435,7 @@ static int amdgpu_vram_mgr_new(struct tt
 	int r;
 
 	lpfn = (u64)place->lpfn << PAGE_SHIFT;
-	if (!lpfn)
+	if (!lpfn || lpfn > man->size)
 		lpfn = man->size;
 
 	fpfn = (u64)place->fpfn << PAGE_SHIFT;


