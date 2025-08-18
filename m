Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD964288C1F;
	Mon, 18 Aug 2025 14:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526174; cv=none; b=NFntsPIfuX80r73tYUlMocTHcH36xWPqL2opEwjWz9HtcHKPgBwNSCDHWDohWQwTQvoVXGJURmP9kEvQ7avGVUyEp+MWlQwDJEM4ZZQnJ3ihSV6l6+MWQ4ND0BvqqDFOKjtxHfzJbhAMnHggOuUp2FPi1xDn/PvX36jMAGwv9Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526174; c=relaxed/simple;
	bh=18dyHLGKObF4UVpn7vAHB09KUAPDoQtGBud/FLaeptM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hc+y1B21S2t3UCt90aHYq1xxvGaxch/3hcbkz8K+e6SJhGunLz3MvHeRU73J0j1vy1TGW6mV1OYsGf0hcQrldvyQWjgCMUK83QFgUtjs3ZjM1R79LvYPwPgU66R1O7tCAm+DkyNeecRbez4PITdHomT7cxt6pSa3nEqf4h7ith8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0fPYlHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0fPYlHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3D6C4CEEB;
	Mon, 18 Aug 2025 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526173;
	bh=18dyHLGKObF4UVpn7vAHB09KUAPDoQtGBud/FLaeptM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0fPYlHBTfyrfR/uvfoCBaZYp/dks4tsVq1uDhHfcDymKA7+6yNp6wjaupTz0ckAj
	 ToMEBHjStS+LwCEZrCwx6KTuZEMq3qGCPwzJDEvlVkCa92ZlXM29dlJWzZRUifdLak
	 49Aq+jfUOtDKR6kWkWK3kvIFFb7xKEWC2kJ92YEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Maciej Patelczyk <maciej.patelczyk@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 478/570] drm/xe/migrate: dont overflow max copy size
Date: Mon, 18 Aug 2025 14:47:45 +0200
Message-ID: <20250818124524.299490278@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 4126cb327a2e3273c81fcef1c594c5b7b645c44c ]

With non-page aligned copy, we need to use 4 byte aligned pitch, however
the size itself might still be close to our maximum of ~8M, and so the
dimensions of the copy can easily exceed the S16_MAX limit of the copy
command leading to the following assert:

xe 0000:03:00.0: [drm] Assertion `size / pitch <= ((s16)(((u16)~0U) >> 1))` failed!
platform: BATTLEMAGE subplatform: 1
graphics: Xe2_HPG 20.01 step A0
media: Xe2_HPM 13.01 step A1
tile: 0 VRAM 10.0 GiB
GT: 0 type 1

WARNING: CPU: 23 PID: 10605 at drivers/gpu/drm/xe/xe_migrate.c:673 emit_copy+0x4b5/0x4e0 [xe]

To fix this account for the pitch when calculating the number of current
bytes to copy.

Fixes: 270172f64b11 ("drm/xe: Update xe_ttm_access_memory to use GPU for non-visible access")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250731093807.207572-7-matthew.auld@intel.com
(cherry picked from commit 8c2d61e0e916e077fda7e7b8e67f25ffe0f361fc)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index c0e2656a14d2..02c0a4a7372c 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -1887,6 +1887,12 @@ int xe_migrate_access_memory(struct xe_migrate *m, struct xe_bo *bo,
 		else
 			current_bytes = min_t(int, bytes_left, cursor.size);
 
+		if (current_bytes & ~PAGE_MASK) {
+			int pitch = 4;
+
+			current_bytes = min_t(int, current_bytes, S16_MAX * pitch);
+		}
+
 		if (fence)
 			dma_fence_put(fence);
 
-- 
2.50.1



