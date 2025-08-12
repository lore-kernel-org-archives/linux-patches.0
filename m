Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD703F9D2;
	Tue, 12 Aug 2025 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022263; cv=none; b=PTFb21JvvTQeJlQLqELcoKtLOWGkxO6h3BQPP9MmG6m1Cms16dHkAh5T1+xXwXwRJ/wBuvocCHqf5XxA2Ac7fnCtVCED81z1oT+w2Xxarc38DTUFPKoVhqrZWrDzcgOxfHcp3ZwOLwi1RzrVct26qZRP09DzCTgTZsr4+UFpuUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022263; c=relaxed/simple;
	bh=NzZBpfAwegDoOEv+ZnXhx2l/ZxguPrZZ7Y1t1tmWY/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eh/SNhCNWZfeWsZeQCyCM21iQFCWIy8wIvUXS62OluIYVbYPGBJseI87taDo6AO1kor5deRjavmpg6cHNciPKHKibnHsuYUeMH2XG4P6rh4tFAOyzB9QM8xvaEhWhHuxU/COZ4i2NedVae9HyW5QC+Ti9otwQdsbllgaXYaPbaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoH0b7Al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoH0b7Al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5877AC4CEF0;
	Tue, 12 Aug 2025 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022263;
	bh=NzZBpfAwegDoOEv+ZnXhx2l/ZxguPrZZ7Y1t1tmWY/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoH0b7AlI4XadG6F3k7/86l9V8cgC4KCIKkkrBth54SEF+X/fG3Uo2jB+jlZgfh6A
	 r6mwY8vqNLqScOSFr25PRTrOYUL48J8nSzPxMVBuJ56RmFQrXO4Udde2XyxM4sTQvN
	 s/iKEeJOmfk6ZQ8dKV+AYHVS8c3pxd+Z1CrqmiBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/369] drm/panthor: Add missing explicit padding in drm_panthor_gpu_info
Date: Tue, 12 Aug 2025 19:26:07 +0200
Message-ID: <20250812173017.407406077@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 95cbab48782bf62e4093837dc15ac6133902c12f ]

drm_panthor_gpu_info::shader_present is currently automatically offset
by 4 byte to meet Arm's 32-bit/64-bit field alignment rules, but those
constraints don't stand on 32-bit x86 and cause a mismatch when running
an x86 binary in a user emulated environment like FEX. It's also
generally agreed that uAPIs should explicitly pad their struct fields,
which we originally intended to do, but a mistake slipped through during
the submission process, leading drm_panthor_gpu_info::shader_present to
be misaligned.

This uAPI change doesn't break any of the existing users of panthor
which are either arm32 or arm64 where the 64-bit alignment of
u64 fields is already enforced a the compiler level.

Changes in v2:
- Rename the garbage field into pad0 and adjust the comment accordingly
- Add Liviu's A-b

Changes in v3:
- Add R-bs

Fixes: 0f25e493a246 ("drm/panthor: Add uAPI")
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250606080932.4140010-2-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/panthor_drm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/drm/panthor_drm.h b/include/uapi/drm/panthor_drm.h
index e23a7f9b0eac..21af62e3cc6f 100644
--- a/include/uapi/drm/panthor_drm.h
+++ b/include/uapi/drm/panthor_drm.h
@@ -327,6 +327,9 @@ struct drm_panthor_gpu_info {
 	/** @as_present: Bitmask encoding the number of address-space exposed by the MMU. */
 	__u32 as_present;
 
+	/** @pad0: MBZ. */
+	__u32 pad0;
+
 	/** @shader_present: Bitmask encoding the shader cores exposed by the GPU. */
 	__u64 shader_present;
 
-- 
2.39.5



