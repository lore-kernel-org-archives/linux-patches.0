Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B18F263F52;
	Tue, 11 Nov 2025 01:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824125; cv=none; b=feislqb5qoygcewdjCKFG7yGD2vZQjKBAVvNYuqQk6pZHa+c2ChKu2RV1cyFaCi5HTyexVivxMureujQ5hXzal+YahPEBXxsoQiDuBxF2k7VQ/MM1YymQKaCKP/fD9Rte/mpwCeLKplhIjPVRiV/h35Mo76m/7eMWjMOTskz9mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824125; c=relaxed/simple;
	bh=g4XU2wgFHTyJ4oxFhUkT7SMvwgBdRvQg9Y9prOIP2z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6K3JSez4FpSzWUgu8bh6hQI01iXpmR3Dgp38mzEw8HYUHW+9RNGfi0Vm/LTGjGirSZKkGKH4RKxQlvUA4MJFzRihMMnsJ9ionVgVKb2nXmWSbmTLmyFotjfGVgsDfHlGIhtd3Jz4VFEJHbTFge6MgLrrhsAucwuKz5nIXJoFBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QayP3X/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QayP3X/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7DBC116D0;
	Tue, 11 Nov 2025 01:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824125;
	bh=g4XU2wgFHTyJ4oxFhUkT7SMvwgBdRvQg9Y9prOIP2z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QayP3X/F3fDnXpTQ49Zt9K7XH5RD6B5cpfECQxy6jKURc4+oFVASyv2fexm1WShvg
	 dXdFPSNiUi88kd9eCcZ0Jmna1x1d1GITOPq2Xyucy7ezzhHDYqTGsYT8TC4g4Sr895
	 O65gosvABAvYCV8CLUTiMIbWJMUk+I6F/Zy91z94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 392/565] drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()
Date: Tue, 11 Nov 2025 09:44:08 +0900
Message-ID: <20251111004535.690466842@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 81d195d366ceb..bed3083f317b8 100644
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



