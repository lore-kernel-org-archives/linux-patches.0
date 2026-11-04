Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831452;
	b=ZqKravhnOAWsYX2D75QnDnfEpo5IqbmG9fiTZOPRDkzfWtXv+ZBvWNHFR2DjSE5kE4We
	 7cgaVg4MhLD5B2Ee7ZxUledfuu3G8lSnLWQsZDrdRSPJcMnAwMALheoW0ccrKise5yrrG
	 HvAN2+V1vLbIskfilG4KlmN5UkceaVXEBEyLyQY858ty2D2ouLI7U5iiZM4o8VB21gbhB
	 vDkdLRj9f2RpPYgAQUAfFnK8oytwZc7ZjXEwFzNN+R2D1pbtEViiaELlOQ9k+BIbt+jZ4
	 TrESLo4JyYnFGFLoC1VYwNJpl9KxUlb2sv6xj6Wv4rWY6O02PSRAEQpZjnyFuu5gnaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uuBLJdtzuRcJngeSrlWUsIz5hyhxCxOl5bgpgATbaxQ=;
	b=XOREmEdpsxQVXkmjRzGs53N93MEkItPyaHpnTd9XZ3AhW678Ip+KwvaTCfluEDN+GsdG
	 EJf71qtOdR1J9ip0jpQ7A8AWvUaOnkUGv1pysYcoL+daQLPoJ7+ptSnJyjBn7yGqAKfmi
	 9X78LfgR4SoxoYRplXcDazPTUfiisKd4KUgXgAnll4tx7R9ice9PpGdh3Tg46mjKAh2XE
	 6oz320b1xvqTiL2422aIyAirBQ87z2w1lgVnmbCARJohMnnJ87UgFQxu3mvnslJthWEu6
	 Qc2CD2CKPzrUhhAyKpW7daNFIj6TSsrHIdkdalzH1y1how9RTUs5qtw1iWdUYl3Y7DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=koGQEv7Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83084606A328;
	Wed,  4 Nov 2026 22:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=koGQEv7Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0691F000C1;
	Wed,  4 Nov 2026 22:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831452;
	bh=uuBLJdtzuRcJngeSrlWUsIz5hyhxCxOl5bgpgATbaxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koGQEv7YD3VaWJwaAyL45sPIW2CkBy7liss0Wmvy21zqJOoF1Hr5nJx8Hy3FuwINO
	 Pjf7P3jBRnIPVnQcrbfS5+qrI2TBwSfEEaz0j4KwSGy7tdmNaUtoWgH7DZtpA3OuIB
	 xJdCDLG/YVDPvHqeGlWyTCjYSLSi6Ajr8V1lkZ/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.18 0710/1005] drm/panthor: Fix TOCTOU race between GROUP_REGISTERED check and erase
Date: Wed,  4 Nov 2026 16:07:23 -0500
Message-ID: <20261104211103.450324721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3664,12 +3664,18 @@ int panthor_group_destroy(struct panthor
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
 


