Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41444471243;
	Tue, 21 Jul 2026 19:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660786; cv=none; b=Yz+XRkgkAy5bHUP9EoX2lWw02PNqI6mJnN8p+quKWmqFxFaFp/EyeX7zDy2rthAAMeDKj/+Cr/XuKMaEmVcZDnz9yytKFEiCTgta7BkSIdGtsgI1T91a8kPPCAxYPe46A9F2D6Uh69tjtuwnBtrCLs/5FZgBJWq/ntCYz1VYtrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660786; c=relaxed/simple;
	bh=/HItX9xFUld2ptNL29a8Q1HXUKBqrFLuyAODNJdvG5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhc4CbNQYF8rGJZBhLd5mfa9aVphdcc3g6ER1fxg7TYsSn3AAET9i0sZAzZHnbMpFHkijfs2L1gU1e5LuawBQgIsqjE7VmSbwa11PDRh6bqOmx8/mgYhaUzWtE8dxlZV7h3YZHUhyHDJyZI41BsyQ1kHsauhQ73MdKnv5IV3/iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QB/iFNR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QB/iFNR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A699E1F000E9;
	Tue, 21 Jul 2026 19:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660785;
	bh=Cs0eF2VQeG3eZDI23hjqHkhOjnjsG2eQgPb88FiBVMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QB/iFNR/ZIkZaV/EQsuJUcoKok2Q5hbNcH7+XgdR/cVh6bH7fCpNBTWno0PZjWoFw
	 Gy4UsCZQ5GddHcJ7aQk5D5WTyrWs1JI4bWDpEq/pVwmxjSFlknAq6tvMZ8NGKd3+sC
	 67pUfdxRlC/xF+fFRfYFDoy2E6rZlElibD+qwcBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Qiang Yu <Qiang.Yu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1104/2077] drm/amdgpu: initialize iter.start in amdgpu_devcoredump_format
Date: Tue, 21 Jul 2026 17:12:57 +0200
Message-ID: <20260721152618.858683382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <Qiang.Yu@amd.com>

[ Upstream commit 1c2d7a656655a50bd1b7227fb26d173959a1955d ]

This fixes read /sys/class/drm/cardN/device/devcoredump/data
return empty content sometimes.

amdgpu_devcoredump_format() leaves struct drm_print_iterator's
.start field uninitialized on the stack before passing it to
drm_coredump_printer(). __drm_puts_coredump() compares the running
.offset against .start to decide whether to skip or copy each
chunk:

	if (iterator->offset < iterator->start) {
		if (iterator->offset + len <= iterator->start) {
			iterator->offset += len;
			return;
		}
		...
	}

Fixes: 4bbba79a7f1d ("drm/amdgpu: move devcoredump generation to a worker")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Qiang Yu <Qiang.Yu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cd6397b7af8262a380e188dc32e9de11ff897ed2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
index 3d5a2abf27c634..f89f3a37a45b1f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
@@ -229,6 +229,7 @@ amdgpu_devcoredump_format(char *buffer, size_t count, struct amdgpu_coredump_inf
 
 	sizing_pass = buffer == NULL;
 	iter.data = buffer;
+	iter.start = 0;
 	iter.offset = 0;
 	iter.remain = count;
 
-- 
2.53.0



