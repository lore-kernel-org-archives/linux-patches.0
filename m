Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3581BA294;
	Tue, 27 Aug 2024 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771029; cv=none; b=kdgM4KO6B12YktUQB7VrXOMxiE9X9VbxTsHIKUSbGvj+ibhjYrDqmshqumFbOjyZOVQkWFzXRfMfU6E617xBI7IqKXDGqTJ2BtPKvyFS+Ft4rjRwczIBUSbbIQgCC6wZrmFuxWszjBfMrV5zbr6IR1encvqI540PffkzmZ/7lNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771029; c=relaxed/simple;
	bh=evqOJihfgod0AbXq4l1hjeqrYix0Tqepgu6+fVnC5i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Je81XVNT9HWzMO418vj/IHqS2Lc7+Pl53NoyUuqOUK+YRJSL1Hp5/kiIiIYqF/y2Y/SYz9Jd3QN7F/TLXXl70BhBFmfy6avl2QU2iTr7dw4qiTiB19zly7SCu7cuATMqvbZ5DxOoIfgsc4O1oOPPOoInRnTva0gsyeBYKVxOxVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAAxktot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAAxktot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCBAC6104C;
	Tue, 27 Aug 2024 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771028;
	bh=evqOJihfgod0AbXq4l1hjeqrYix0Tqepgu6+fVnC5i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAAxktotU0JICUM5pFufuDdwVCEeArw0QyU4Szg2URkMyhPLJQoae40bl/hH2kmHt
	 gDlPIYkjL184P2O18E0U6TQE9YGlZ1D+wTRZW+c/Tm4flvwzGdT1UN9ICFH4J3X2eE
	 R1yPKkv7Irtyg9cVJ2l6QT9/6LLoLt4W81pRNacI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH 6.10 034/273] dm resume: dont return EINVAL when signalled
Date: Tue, 27 Aug 2024 16:35:58 +0200
Message-ID: <20240827143834.694310165@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khazhismel Kumykov <khazhy@google.com>

commit 7a636b4f03af9d541205f69e373672e7b2b60a8a upstream.

If the dm_resume method is called on a device that is not suspended, the
method will suspend the device briefly, before resuming it (so that the
table will be swapped).

However, there was a bug that the return value of dm_suspended_md was not
checked. dm_suspended_md may return an error when it is interrupted by a
signal. In this case, do_resume would call dm_swap_table, which would
return -EINVAL.

This commit fixes the logic, so that error returned by dm_suspend is
checked and the resume operation is undone.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1181,8 +1181,26 @@ static int do_resume(struct dm_ioctl *pa
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
-		if (!dm_suspended_md(md))
-			dm_suspend(md, suspend_flags);
+		if (!dm_suspended_md(md)) {
+			r = dm_suspend(md, suspend_flags);
+			if (r) {
+				down_write(&_hash_lock);
+				hc = dm_get_mdptr(md);
+				if (hc && !hc->new_map) {
+					hc->new_map = new_map;
+					new_map = NULL;
+				} else {
+					r = -ENXIO;
+				}
+				up_write(&_hash_lock);
+				if (new_map) {
+					dm_sync_table(md);
+					dm_table_destroy(new_map);
+				}
+				dm_put(md);
+				return r;
+			}
+		}
 
 		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);


