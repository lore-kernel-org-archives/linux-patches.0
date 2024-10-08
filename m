Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BA21DF270;
	Tue,  8 Oct 2024 13:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393730; cv=none; b=YALMEkRpH4LPblGsziB4MU5p1tcImjoc5ISpvoCBCVgaOrGJVIkslZzldZpEHuL7BVQph5V58hJ1AiZfOXDfVn/Au5TeI4gr/Acdo/AN5NE9mEXWaUHwh9d34Xn7SbzUcOI4i1wVnqhopTpGGTE0dA+sKoI42ZCSC03phwfPI+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393730; c=relaxed/simple;
	bh=u9BelKbeix7UMvf2/KQwhvcJGImWZVqkh/lKzRkprmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tV+wW3FKM6UVdFuC70F35nXHL1bfXDIg96OVPgaphJ2H2dGSZF0PTbsDsuplovhi851TO5iQghYLhB8QcQlGLcwwyJJz6gBHUwsPddQ1BYFQU+hwlmEuKXqS+iMoNCRrhNNZtWyRGC3o5jAD+HJxQAYe8iY7CB1jBYRftwCPelI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9zlOioT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9zlOioT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141DEC4CEC7;
	Tue,  8 Oct 2024 13:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393729;
	bh=u9BelKbeix7UMvf2/KQwhvcJGImWZVqkh/lKzRkprmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9zlOioTY7X4zJzpQ5VcDxuBJvtEhBiqZlEkULSYF1oIIq+NE7i4JS4ZuFUTg5bXD
	 qws2dWhcN+em7YOgz26p/novMDn53l5CgmMv+7NGv195cbw0HQW8NDCdK5Wx1VPOHj
	 9D9tG/fPoYvYy0VETR+I2FcKws4A8eljLK/Kn3UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 239/386] ext4: aovid use-after-free in ext4_ext_insert_extent()
Date: Tue,  8 Oct 2024 14:08:04 +0200
Message-ID: <20241008115638.803907785@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit a164f3a432aae62ca23d03e6d926b122ee5b860d upstream.

As Ojaswin mentioned in Link, in ext4_ext_insert_extent(), if the path is
reallocated in ext4_ext_create_new_leaf(), we'll use the stale path and
cause UAF. Below is a sample trace with dummy values:

ext4_ext_insert_extent
  path = *ppath = 2000
  ext4_ext_create_new_leaf(ppath)
    ext4_find_extent(ppath)
      path = *ppath = 2000
      if (depth > path[0].p_maxdepth)
            kfree(path = 2000);
            *ppath = path = NULL;
      path = kcalloc() = 3000
      *ppath = 3000;
      return path;
  /* here path is still 2000, UAF! */
  eh = path[depth].p_hdr

==================================================================
BUG: KASAN: slab-use-after-free in ext4_ext_insert_extent+0x26d4/0x3330
Read of size 8 at addr ffff8881027bf7d0 by task kworker/u36:1/179
CPU: 3 UID: 0 PID: 179 Comm: kworker/u6:1 Not tainted 6.11.0-rc2-dirty #866
Call Trace:
 <TASK>
 ext4_ext_insert_extent+0x26d4/0x3330
 ext4_ext_map_blocks+0xe22/0x2d40
 ext4_map_blocks+0x71e/0x1700
 ext4_do_writepages+0x1290/0x2800
[...]

Allocated by task 179:
 ext4_find_extent+0x81c/0x1f70
 ext4_ext_map_blocks+0x146/0x2d40
 ext4_map_blocks+0x71e/0x1700
 ext4_do_writepages+0x1290/0x2800
 ext4_writepages+0x26d/0x4e0
 do_writepages+0x175/0x700
[...]

Freed by task 179:
 kfree+0xcb/0x240
 ext4_find_extent+0x7c0/0x1f70
 ext4_ext_insert_extent+0xa26/0x3330
 ext4_ext_map_blocks+0xe22/0x2d40
 ext4_map_blocks+0x71e/0x1700
 ext4_do_writepages+0x1290/0x2800
 ext4_writepages+0x26d/0x4e0
 do_writepages+0x175/0x700
[...]
==================================================================

So use *ppath to update the path to avoid the above problem.

Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Closes: https://lore.kernel.org/r/ZqyL6rmtwl6N4MWR@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com
Fixes: 10809df84a4d ("ext4: teach ext4_ext_find_extent() to realloc path if necessary")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240822023545.1994557-7-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2103,6 +2103,7 @@ prepend:
 				       ppath, newext);
 	if (err)
 		goto cleanup;
+	path = *ppath;
 	depth = ext_depth(inode);
 	eh = path[depth].p_hdr;
 


