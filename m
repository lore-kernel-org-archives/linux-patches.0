Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020617;
	b=SU09d/0RUzqIrsqgK57ecFEeP2euBWWl0wuGVfOkzT2kdVKoXkyV3koVexTrMVsZeHqZ
	 50eNpsj11qoxM/hyR9WLH81sf80UOnpHlyTAG35jW/LHugEiHxvTMBj43uW91ADiq/wNv
	 u0YaDMkiYuWMuIuzAJ9tUsuhZiIY+wFeKXJS+v4j1iB+l5qZxOnvsMZzf9PbOfyWDdjtP
	 jlroI8u17Voo6c2tDXifIx0iBbv/p5kPf55J5gzZ8XNTP/TUPgPC07NPodRlm1su32SXw
	 Kq63JQ0mLT6bsdvx7prgrvJfFy7He+mnueRBh4xF+93Q45yxMEqkTN3sV25idylRVtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YYVYDNU4RmeSbvMdpYtJZnXgHvcdlkD8w3tebLzp7uE=;
	b=k9uP7XPHi4ophGTYLyMY1LSxSoMqTng4ey4383QBBs3L+1wcErs1T6qBa2LFgy0tBzJt
	 gxEGge05qKoDWwu6uPl7JHZZR187GE8UhBxEe9nycVsdy8ORqMlwXu1EC2b/AX83NchF/
	 Ps/nq1atnhw12kUQfw5wYzZ0TbabmhjGiFUsVTo0q18lAHm2GyvpJb9mC7UvdTl2yqJJs
	 zEUMn24uyiofrmEzUQoWPR1q0HdaPY2vMP1cnovBxs3TaoMTzPBzYKrGsy7IYmIaNsYTr
	 3bIXgmRfLE1Q5EKXYFU3WidNKsVI5th7e28k7Eq6cx0CCXTut/TSXO8uOnUDUU7EepA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEKh8NlD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AC1606A31C;
	Wed, 18 Nov 2026 16:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEKh8NlD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E0A1F000CA;
	Wed, 18 Nov 2026 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020616;
	bh=YYVYDNU4RmeSbvMdpYtJZnXgHvcdlkD8w3tebLzp7uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEKh8NlDx0SCZyM5bjtfZYDXNovduDBvKLEq7SO11ed1sL57oBQ931x2BPugFm74y
	 TVw2LfTz7MT5Y5za1vde92+Hx3jQnjIIT022saS8eRWVFfoT0KmbkRsidO9trAwWUf
	 SVYcV8uTwbOMI/jnu6GiqiOoLdt0N8DTUBRlD08w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Akash Goel <akash.goel@arm.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1965/2651] drm/panthor: Fix handling of NO_MMAP BOs
Date: Wed, 18 Nov 2026 15:53:25 +0100
Message-ID: <20261118150357.243800441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit 9a07b36a511fe998f46372331758ef355273bdfb ]

The BOs created with DRM_PANTHOR_BO_NO_MMAP flag are not supposed to be
mmappable by the Userspace. But after the rework to support shrinker,
it became possible to mmap NO_MMAP BOs. Userspace could second guess
the file offset range, allocated unconditionally at the BO creation
time, and create a CPU mapping. There may not be any adverse effect of
such a CPU mapping though.
This commit adds a check in the mmap callback of Panthor driver to
fail the mmap() attempts on BOs created with NO_MMAP flag. The check
covers private BOs as well as the prime exported BOs that are mmapped
using prime fd.

v2:
 - Fix breakage of mmap() on exported BOs that didn't have
   BO_MMAP_OFFSET ioctl invoked for them.

Fixes: 68cbf96b1e9b ("drm/panthor: Part ways with drm_gem_shmem_object")
Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Akash Goel <akash.goel@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20261013125433.26432-1-akash.goel@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 72908be5e144f..75d462f20b6c8 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -744,6 +744,9 @@ static int panthor_gem_mmap(struct drm_gem_object *obj, struct vm_area_struct *v
 	struct panthor_gem_object *bo = to_panthor_bo(obj);
 	int ret;
 
+	if (bo->flags & DRM_PANTHOR_BO_NO_MMAP)
+		return -EINVAL;
+
 	if (drm_gem_is_imported(obj)) {
 		/* Reset both vm_ops and vm_private_data, so we don't end up with
 		 * vm_ops pointing to our implementation if the dma-buf backend
-- 
2.53.0



