Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E22B1DA62E;
	Sat, 12 Sep 2026 11:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213113; cv=none; b=deJ0WxjrUenSUSFAf7N4rEWE7qKlrNVmA2nOWxSTogNcg0sseukoUyAgyS7ikIq2pi8Fj7gG39+YE+6T6QaAkoe3QiaNpX+DByn2c1a1yeHqrG3cN6k12hMcSw666F6n3Q78FJ+Kexck2GEdhJC2UtMtdXYineyYo/Xov0i3tZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213113; c=relaxed/simple;
	bh=0zGibCCSQ5earzOqGOFC0781OBX+KwO1YF4MKM9b7OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1owGAyuL0xe51ZpcPplZh/yTjCK8Bwh8594A7LwLG6pV/cuatrA/W4iyfUNGPQPPnk5+/C3E6KgM3bQLf7jbyapTuKTuUf/qXOdeqV1bL6YL3Mf/bNzmsWrSpCEFSoLtOg/kdYz5zYQO6KvdT3gfz3ZcWgLkmB/GojlnmlrJlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chT/1UyC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chT/1UyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67551F000FF;
	Sat, 12 Sep 2026 11:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213112;
	bh=2v/daN+8ACioMGapTaZccxD/GT9/UgEEbfWOsWkcs8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chT/1UyCtU+HwATcf2+bntwbyYDhsiK6IVoni5u+4rHF/sClDtwHiylJ29PoYv+z1
	 PDsJJhfWAC5T3ZgVeWWQpuACTV11BWVEilta9j1fYNoEa+iXNUyrclPIjtykeCvf7K
	 FvYLAPuMBML5uztm5Ar+T19dzVxmdH+WH82Amsug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 0056/1376] dm: fix resume-vs-remove race
Date: Sat, 12 Sep 2026 08:41:22 +0200
Message-ID: <20260912065608.806798635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 44b43ec132f1cf3275ecc182d0c82f50c3c4c3d5 upstream.

If the user issues the resume ioctl and the remove ioctl at the same
time, it may be possible that the device is resumed after it is suspended
in __dm_destroy. The result is that the table is destroyed without
calling the postsuspend method.

Dm targets expect that they may be removed only after the postsuspend
method method was called. If we break this expectation, it can cause
misbehavior in various targets. For example - in the dm-integrity target,
the reboot notifier is not unregistered, leading to use-after-free.

Fix this bug by refusing to resume if the device is being destroyed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3112,7 +3112,7 @@ retry:
 	r = -EINVAL;
 	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
 
-	if (!dm_suspended_md(md))
+	if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
 		goto out;
 
 	if (dm_suspended_internally_md(md)) {


