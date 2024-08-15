Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387AF63D5;
	Thu, 15 Aug 2024 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732435; cv=none; b=idzd+GwVrW0Z3wsEhjAjzKm0/wQ6lITsLAnZnadjqbBjDuC2WzSDErKhUSK744tbs9WCozVOVXPp+mEH3vL+J2BM3W2aHNVi17UTNLcbrWYhFtrJ5ul7AWk3YZoWELyHTue/O2u/c+SUkrB7O9UQNswCur41eWILJDbo/munkSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732435; c=relaxed/simple;
	bh=Mfh+UzMoeD08v3ehw3DuV1kdsbKriD+VtiAbcdTwczs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVjnkDS6u3vgcLqehVOz14LngHSygM2tyCWuDPfKMMkgRHSU82tlW2mdz9a2FshxN4lh+9z05Hg9qCVKCLl9cbSPHbXc4eXlXmv/1cdLrckHiqr/XKACyXcpkBMeckkcguSWNsTpeZCWHheJJWo12bvMXM2i54ciuWbJiYp911E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vl4/g5Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vl4/g5Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0B8C32786;
	Thu, 15 Aug 2024 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732435;
	bh=Mfh+UzMoeD08v3ehw3DuV1kdsbKriD+VtiAbcdTwczs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vl4/g5Mdm/9pk7gZcbAwAJQqQBNosulJEbsHq8ARhoGVpUDxZbrYDwRcW2iZr9rf2
	 /2C2d2vVHZOsG5zGhHtrKiNler+Vv2bE3YZFVHbEMzr1NDCBu/25mG7b7OUUrrKqYC
	 3SUgwfOpo/uoMe2nBTZh8A/JPwYIHDP3b8Okt+bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 5.10 177/352] rbd: dont assume rbd_is_lock_owner() for exclusive mappings
Date: Thu, 15 Aug 2024 15:24:03 +0200
Message-ID: <20240815131926.119113485@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 3ceccb14f5576e02b81cc8b105ab81f224bd87f6 upstream.

Expanding on the previous commit, assuming that rbd_is_lock_owner()
always returns true (i.e. that we are either in RBD_LOCK_STATE_LOCKED
or RBD_LOCK_STATE_QUIESCING) if the mapping is exclusive is wrong too.
In case ceph_cls_set_cookie() fails, the lock would be temporarily
released even if the mapping is exclusive, meaning that we can end up
even in RBD_LOCK_STATE_UNLOCKED.

IOW, exclusive mappings are really "just" about disabling automatic
lock transitions (as documented in the man page), not about grabbing
the lock and holding on to it whatever it takes.

Cc: stable@vger.kernel.org
Fixes: 637cd060537d ("rbd: new exclusive lock wait/wake code")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6660,11 +6660,6 @@ static int rbd_add_acquire_lock(struct r
 	if (ret)
 		return ret;
 
-	/*
-	 * The lock may have been released by now, unless automatic lock
-	 * transitions are disabled.
-	 */
-	rbd_assert(!rbd_dev->opts->exclusive || rbd_is_lock_owner(rbd_dev));
 	return 0;
 }
 


