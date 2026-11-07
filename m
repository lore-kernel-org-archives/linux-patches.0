Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061550;
	b=Ye43pmhHfYKbMfpqLZXhBa4KaRVa7dc775Le+2C82JwISlutE98yhAvaLUZ9DV9ZEi3r
	 hoyUXDogepDzNzXJb8TbA6ABydymHtPlmIMLGKRJscgDpvPOlEoj9G+kcHcmLC8eQv33I
	 ITCGVSVRxdYYZszvzssCAbCj4CW6Fht//MVy0ZbV1tUr6MonV9WQtWGDvUe+oggsKLAu5
	 XDT8P9BKwQPzcvUvv55SdMrjbPLpKKUhzfQ+AvD9SJ0pBF75x4pPv4IfpZDFjH7+nnwb6
	 2davgmRFy+exDo2bmujaxDmrrqEIfPb3FvP0F0pDUv/wnEQg9jl5sf9gI8jrYytxCEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BgT4bi2LEpRLq/JMLJhK94cvxngsXmNv4uVdH8iLCug=;
	b=g6muwZ0QaGefDAJj11TsBCOd9Hzm9HiF6ZMK1VeSsR97yZ2ewf7cDLIOAC0nLfOATthI
	 BPewWvLTHFcADhq7DlYkulsheXqCVLQIYCaQG5bOrSF1ptZaXCnypxIcIIjd11d2exo4O
	 1dDPHq8uXZpY1dodPiaCTjjpEolujk16RPpBbIGsck+g0ausTT6DAfmMRkj7m7uoaRJsW
	 4b2Zr63gdXJsiNVOnlauEzv1i8jJG3UgVF74HXH47cQqBXqNKJ68o+bhde9T7fWRdWPCC
	 DVdX7a8dLTcn4f4euOqTnDwvA91FpZDzevrgtUx5AzFUvknIVtCnmkEzYR4BtFURZcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GBYm8IW/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86227606A326;
	Sat,  7 Nov 2026 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBYm8IW/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7E71F0089F;
	Sat,  7 Nov 2026 14:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061550;
	bh=BgT4bi2LEpRLq/JMLJhK94cvxngsXmNv4uVdH8iLCug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBYm8IW/XBEnx4rzB43JQ0fQGxHqtMb1aw1x9ygPa/FJDQyheD5huUtrt2OaGv264
	 S+NGf8MTQMthRQnOFmpLsUSNY4l0ZIWixVO7dtDlvU5MScfabjkUW7wIw94zz9DFQE
	 TbfLpipbkb4Xa3Ysx9JrzSHFKPwohsEms7+rNXdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.12 0634/1536] drm/panthor: Fix TOCTOU race between GROUP_REGISTERED check and erase
Date: Sat,  7 Nov 2026 08:44:10 -0500
Message-ID: <20261107135015.340492065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 7764289d76a38c3a2f9b093bf17e193ab54acd70 upstream.

panthor_group_destroy() checks the GROUP_REGISTERED mark and then calls
xa_erase() without holding the xarray lock across both. If the handle is
destroyed by another thread in between, and a concurrent GROUP_CREATE
reuses the freed ID, the first destroy erases and releases the new,
still-initializing group, leading to a use-after-free in
panthor_group_create().

Do the mark check and erase atomically under xa_lock().

Fixes: eec7e23d848d ("drm/panthor: Prevent potential UAF in group creation")
Assisted-by: Claude:claude-opus-5.5
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20261008100935.3059587-1-osama.abdelkader@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3533,12 +3533,18 @@ int panthor_group_destroy(struct panthor
 	struct panthor_group_pool *gpool = pfile->groups;
 	struct panthor_device *ptdev = pfile->ptdev;
 	struct panthor_scheduler *sched = ptdev->scheduler;
-	struct panthor_group *group;
+	struct panthor_group *group = NULL;
 
-	if (!xa_get_mark(&gpool->xa, group_handle, GROUP_REGISTERED))
-		return -EINVAL;
+	/*
+	 * Check the mark and erase the entry atomically, so a concurrent
+	 * destroy + create can't make us erase a group that's still being
+	 * initialized and happens to reuse the same handle.
+	 */
+	xa_lock(&gpool->xa);
+	if (xa_get_mark(&gpool->xa, group_handle, GROUP_REGISTERED))
+		group = __xa_erase(&gpool->xa, group_handle);
+	xa_unlock(&gpool->xa);
 
-	group = xa_erase(&gpool->xa, group_handle);
 	if (!group)
 		return -EINVAL;
 


