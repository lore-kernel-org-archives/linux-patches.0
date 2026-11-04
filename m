Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827139;
	b=vdoFBNROZHT2T7pmopWFCVYLV+0YpVpBK/IJXPjtOKO968dFZb4TiNqUO6YfkWwaJWyQ
	 b8XRrpJYWczvcsNpB+KlQZchXS/CZG4tvQRz5wdYOTX00hrCHJolbHEjOm/oDVdIjIwW8
	 Z6qX4EWhDboJPy+/1tvvpYg1WbERzfN7gmQrr11tQFwtPj5lIWUdJg+NuP1KTIVrROIIH
	 GT5ddIc7alDgsm3R3nVeNddtANpmOncJkJ7U6Hfnq4ite855tb9NZWgR1a8C86/7mJoQi
	 3m3Q6Gq5QOgMS/MKsy76xdmGytzQOPMGbHgZH7S5ndNdDBf5dBNvs4tcUCMFEzYizwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9fw/U31n6btOD0Y4yLRslCGlklzxbbmvwvZeogP9L64=;
	b=YnEQnZqZOVY0wCSk/yGEyEkl1Zm4qQh2tzL6NU1MmrgTR4peWCGZhiwa8SeqmZwhPlkF
	 y1n13swAe8ETQIhqKqKefnLTOOXYs3Z64j3YXzYd1yB2v1f3Sy7AW+8umgA2POkUOxzPA
	 ci4SE3wTiuHn+/m8d+l7CRK2gnNvxvruOuhms5eUnF4AWjtbiOtLRmbWT1MYMYGC/39Cr
	 tad7W8TI2n/nHVTKiPLXKN3okswgL9Bl3AlIdssk/rkkndWO3NnfdIYbS2UR7PU++Xg3d
	 EZ4I5gc5FIkzoFEGB9QErBs6KIf/pN3qf3Ao9rcg413t64KZpd7TRZTXfbcXsGk1hKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSPhbZfk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17309606A87D;
	Wed,  4 Nov 2026 21:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSPhbZfk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C511F000C1;
	Wed,  4 Nov 2026 21:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827139;
	bh=9fw/U31n6btOD0Y4yLRslCGlklzxbbmvwvZeogP9L64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSPhbZfkIJ2rgYgUH3js+bjlBN3w0/GF3LoVp/IJN1tS62CUP62H61dbQS/DKh6qM
	 xY/29IUEyir3ClNSOXjcwu9KaOblhNyE7pQDPONgZ4Xefm+tNs/lzBuf5rl7FgNBn1
	 5Ye1xwJ6QkVqA/3RIM3xduTAPMynw80IIZLcuyGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 7.3 210/547] drm/panthor: Fix TOCTOU race between GROUP_REGISTERED check and erase
Date: Wed,  4 Nov 2026 16:06:34 -0500
Message-ID: <20261104211044.116449022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -3794,12 +3794,18 @@ int panthor_group_destroy(struct panthor
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
 


