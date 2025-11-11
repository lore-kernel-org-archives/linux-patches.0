Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BB92472A6;
	Tue, 11 Nov 2025 01:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824895; cv=none; b=hIm7NWXEVGqUngH7tSIafC+MsbMC3Q4WLtcDfYwA/4D1BGJvHdAF8oJHIpnbJCm4Lh0TxGzOLpP381ke2aMfW1C0OpKOslLjUE48co72J3Z23NC1SZtXfoj8fIi4xiw/nQdHHn24ESKC/TXjZrdJVAykONM6FtHM887Px0XySqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824895; c=relaxed/simple;
	bh=88xBQLB0RU3biCaUZDdWxhCmYyA+L2SxHI/qLjg05Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OS+RQ7i63CTz7q/ZJpd5LPtcVvU5ekwa+wdmW64oWUUsXVEyY+mSIb/F0zr6Ukiw/i1v2yv3n2arFXUwfahJn4oKX7Xbf58cMOuo4UamvovbqNhK8RCPks0k+Lv7+d3tcid8g63k58+5vUTVpbTz9ePKpUX43AmuhgmFCSNarCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhJt1+cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhJt1+cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED183C116D0;
	Tue, 11 Nov 2025 01:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824895;
	bh=88xBQLB0RU3biCaUZDdWxhCmYyA+L2SxHI/qLjg05Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhJt1+cxJtDq3n8hT+RRlIPlmOTPwfbx89SwtPyxoat4QxHHSII65MFrPGUGybUPA
	 ZoHRNTop6mStAKldda5FlY5/+hLTFvUyz0dOHs2+ByBuXxBZwVNMpEkHfPQJgfCrP9
	 bEWt1hH+nCxFyUY1/mvHvcMscXJHlYntVsXyPPj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 593/849] drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()
Date: Tue, 11 Nov 2025 09:42:43 +0900
Message-ID: <20251111004550.760483828@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit cc9a8e238e42c1f43b98c097995137d644b69245 ]

kcalloc() may fail. When WS is non-zero and allocation fails, ectx.ws
remains NULL while ectx.ws_size is set, leading to a potential NULL
pointer dereference in atom_get_src_int() when accessing WS entries.

Return -ENOMEM on allocation failure to avoid the NULL dereference.

Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index 427b073de2fc1..1a7591ca2f9a0 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1246,6 +1246,10 @@ static int amdgpu_atom_execute_table_locked(struct atom_context *ctx, int index,
 	ectx.last_jump_jiffies = 0;
 	if (ws) {
 		ectx.ws = kcalloc(4, ws, GFP_KERNEL);
+		if (!ectx.ws) {
+			ret = -ENOMEM;
+			goto free;
+		}
 		ectx.ws_size = ws;
 	} else {
 		ectx.ws = NULL;
-- 
2.51.0



