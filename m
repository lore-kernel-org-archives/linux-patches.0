Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209199;
	b=ztxcphGLVmut5JQzKynUOnsqw0ZvuQgrKDwJHArBSSaCxzKe2upCSt+oYHAihh4wCyOb
	 U7ThtEcQwdKwvTZ9dEfT6QoKYML5JwkIZl/7/dsqlsg7pWld1NqWqkIkRM4yO+0BHuqTj
	 7x013xEl9b/87x6GNhGulggLzFcRwHayFG5w69I6YtuV9juRJCj8o7Tpi76ci8z5zeGLg
	 x+O4RcDsSSWH0gsXhrj34XveHWpx83LkAtnAwslXdfTEzdA1/PSAP3DKhv/xgAVYrUDXg
	 L4H8VGZFAk5iK1B1I/UO0CeCBzX9REOjDXMBtKNUoQZR3FLlOI9BMBjgZ0OHRgNSPUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cA8t1N97T6IhqPtmzx67TXHO96RmlqqF3pfFPIMSh28=;
	b=OKGKS/2Dcn+7p1+drP4GgP8OZL/C2wQ16aTdfUs1jXXZHOHL7GrGBo/5xnaa7UJXjDvg
	 CgGvIBt8ZtEig3p1PYqoNR7O0+dYalcNzxdVAT341i+6Gf0aJAg6FM2h4KWzi+5nWf34y
	 1T/5XTtY5sUoeevjL5ix+wsDPs1v8RfKSTpHNBXkI7SZF+wPiQHCmsGB1ZuB45lPGRw9d
	 y6NlJFg6bKYGD3s70jGA/qIeBcZaApqceVoOwj9NMLsTbjNfyDE/zTvkZhlIqxtjbsjDL
	 GUxTW4Mj0oyB4sPu9oPR56JgSEm7jY6ROv9z566McxfTv7tFuWl0AlkI70AJCZdQhZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HOyF3/il";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8B7606A31A;
	Wed, 28 Oct 2026 17:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOyF3/il
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619EE1F01825;
	Wed, 28 Oct 2026 17:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209198;
	bh=cA8t1N97T6IhqPtmzx67TXHO96RmlqqF3pfFPIMSh28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOyF3/ilBN6irtFbo87V3Nz3nA31Aj6D3udGebrF72o3qK9Gz14NIrBWRt5UZh1zR
	 w5OHqHimQkG/lte6nTyfebsf2/dvP92Hj2ecMCCJ4eQOcOAD9BlNcuOfKaXKRr8dQ3
	 b21NYui/cJQAqowfrKTKT/NorHlbYzk7omyihcPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 388/516] dm: fix reading free memory in do_resume
Date: Wed, 28 Oct 2026 17:59:00 +0100
Message-ID: <20261028170012.673640845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit c9417c1c5269e2bd0570fbe53e4ec03a8d31f008 ]

When do_resume calls dm_table_get_mode(new_map), the call is done without
holding any locks (it only holds a reference to the md). It may be
possible that another concurrent ioctl on the same device will swap table
after dm_swap_table and before dm_table_get_mode. In this case,
dm_table_get_mode(new_map) reads freed memory.

This race condition was triggered by syzbot.

This commit fixes the race by reading mode of the new table before
dm_swap_table. Note that new_map is also passed to dm_ima_need_measure,
but this function doesn't attempt to dereference it, so this call should
be safe.

Note that this is not a security bug because only root can trigger it and
the commonly used tools such as lvm or cryptsetup do not call the ioctls
concurrently, so that they can't trigger it acceidentally.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
[ sashal: Replaced blk_mode_t/BLK_OPEN_WRITE with fmode_t/FMODE_WRITE to match the existing API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 12bc13bde0af5..d067006285e64 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1065,6 +1065,8 @@ static int do_resume(struct dm_ioctl *param)
 
 	/* Do we need to load a new map ? */
 	if (new_map) {
+		fmode_t new_map_mode;
+
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
@@ -1091,6 +1093,7 @@ static int do_resume(struct dm_ioctl *param)
 			}
 		}
 
+		new_map_mode = dm_table_get_mode(new_map);
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
 			dm_sync_table(md);
@@ -1099,7 +1102,7 @@ static int do_resume(struct dm_ioctl *param)
 			return PTR_ERR(old_map);
 		}
 
-		if (dm_table_get_mode(new_map) & FMODE_WRITE)
+		if (new_map_mode & FMODE_WRITE)
 			set_disk_ro(dm_disk(md), 0);
 		else
 			set_disk_ro(dm_disk(md), 1);
-- 
2.53.0



