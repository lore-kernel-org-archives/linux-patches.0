Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7259326FA77;
	Tue, 12 Aug 2025 19:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025645; cv=none; b=E/O2d3YUHoDcf96ItMzdxvL/SHpPOZO5eH0QJxih0DMy6wRfpskmrbeja1kergELUhSINtMPUK4jQZtl4KZw8U1uITd6EyVfY2W8RvwwUtwf1t7vKFqjRcsyCW3EFhIfkp4an/ud//LGMjYWIvgZyidwvtLJga7s+c+ivv+XxFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025645; c=relaxed/simple;
	bh=8g3VmHmRLwa2NnvL4U+bIcKcAVYDLU4SIU5xetDL/a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RMUOPB/k04hPQk+rV6HenUDdJWEqxD1Km7Yjku3BgZCGyT8hWZ+qjDsu16bujIzjSC9LDDxc00GucXsFe1Pm5ZbdaK0haWdLbLimDNnFFgxglVvIy3wpFkBlhtyPIm0apEDFtDLngYCn9hoW/EWcQMALS3MnvYjLNTRntS8O1TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IP3A0bAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IP3A0bAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2773C4CEF0;
	Tue, 12 Aug 2025 19:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025645;
	bh=8g3VmHmRLwa2NnvL4U+bIcKcAVYDLU4SIU5xetDL/a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IP3A0bASnhvj+4an0dM3jcCkrjOAFHUOyx2rE6sa+EJegJ8m5cTK4Ru2Q0scLUhR5
	 /Ual6WJguVzPe0kyYL+PY6LtErNOSg7WCB7cbEMFdd+kiD8xpFitKCGd1pPfE1ic4e
	 Yyan/6LvP1xqZQsntwZ0mACvSox7f5K+QnkX6D/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 102/480] drm/panthor: Add missing explicit padding in drm_panthor_gpu_info
Date: Tue, 12 Aug 2025 19:45:10 +0200
Message-ID: <20250812174401.673878399@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 97e2c4510e69..dbb907eae443 100644
--- a/include/uapi/drm/panthor_drm.h
+++ b/include/uapi/drm/panthor_drm.h
@@ -293,6 +293,9 @@ struct drm_panthor_gpu_info {
 	/** @as_present: Bitmask encoding the number of address-space exposed by the MMU. */
 	__u32 as_present;
 
+	/** @pad0: MBZ. */
+	__u32 pad0;
+
 	/** @shader_present: Bitmask encoding the shader cores exposed by the GPU. */
 	__u64 shader_present;
 
-- 
2.39.5



