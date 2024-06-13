Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9FD1442EF;
	Thu, 13 Jun 2024 12:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280691; cv=none; b=HaBwVuCfyjqQNg3vwO/z1WJCx2T9YVArL4ZQDDH1Yh2i13BEwbmrc85/H+VoaKQw6MmDXzqGHtpVNCRyxmUV0W//cLeuoukDf9yurfhumMTp41cSavrimjQK78vDcjDFQT9lARZmx86WBrIWJoGPUYkV/RPy77VCRZVlDCSy6yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280691; c=relaxed/simple;
	bh=k46ZFuWGEz6lxXNzNUXSrhM1OhLo6F1ErX4BoIR6vMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erNQs5BWlsFzSjyOrkz+qOqB6E4QTWSNyQCJNo+LzsdUvGdbpc7MpilCybeSbxjD1/A0mdEEczuDxf1WVS4s4pUjjE3mmSROdRy9TFyfhr2Ny7xEsAnGRHrxgHOb48pslA3fcxSS0P+hTsPI4wJ+P7P8xLnJ33/doV6hOibFfWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMv763I3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMv763I3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014CEC2BBFC;
	Thu, 13 Jun 2024 12:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280691;
	bh=k46ZFuWGEz6lxXNzNUXSrhM1OhLo6F1ErX4BoIR6vMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMv763I3pveylSmrO8FMVdkEPEcEASMRTb7F41QRRP+IB8IQrz/6lUkvXF+V+UnW1
	 E6jDPnpq1Rani7n9x/BKSGLEncgMHfdRH02QDx/xJR4Qse4kEdpi2bx8SXghIFvvYy
	 nB7EZ32ChriPZUvhiLyfk2Gw8NZp6KhwGMYxE1Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dd43bd0f7474512edc47@syzkaller.appspotmail.com,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 109/137] ext4: fix mb_cache_entrys e_refcnt leak in ext4_xattr_block_cache_find()
Date: Thu, 13 Jun 2024 13:34:49 +0200
Message-ID: <20240613113227.527511422@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

commit 0c0b4a49d3e7f49690a6827a41faeffad5df7e21 upstream.

Syzbot reports a warning as follows:

============================================
WARNING: CPU: 0 PID: 5075 at fs/mbcache.c:419 mb_cache_destroy+0x224/0x290
Modules linked in:
CPU: 0 PID: 5075 Comm: syz-executor199 Not tainted 6.9.0-rc6-gb947cc5bf6d7
RIP: 0010:mb_cache_destroy+0x224/0x290 fs/mbcache.c:419
Call Trace:
 <TASK>
 ext4_put_super+0x6d4/0xcd0 fs/ext4/super.c:1375
 generic_shutdown_super+0x136/0x2d0 fs/super.c:641
 kill_block_super+0x44/0x90 fs/super.c:1675
 ext4_kill_sb+0x68/0xa0 fs/ext4/super.c:7327
[...]
============================================

This is because when finding an entry in ext4_xattr_block_cache_find(), if
ext4_sb_bread() returns -ENOMEM, the ce's e_refcnt, which has already grown
in the __entry_find(), won't be put away, and eventually trigger the above
issue in mb_cache_destroy() due to reference count leakage.

So call mb_cache_entry_put() on the -ENOMEM error branch as a quick fix.

Reported-by: syzbot+dd43bd0f7474512edc47@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dd43bd0f7474512edc47
Fixes: fb265c9cb49e ("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240504075526.2254349-2-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -3126,8 +3126,10 @@ ext4_xattr_block_cache_find(struct inode
 
 		bh = ext4_sb_bread(inode->i_sb, ce->e_value, REQ_PRIO);
 		if (IS_ERR(bh)) {
-			if (PTR_ERR(bh) == -ENOMEM)
+			if (PTR_ERR(bh) == -ENOMEM) {
+				mb_cache_entry_put(ea_block_cache, ce);
 				return NULL;
+			}
 			bh = NULL;
 			EXT4_ERROR_INODE(inode, "block %lu read error",
 					 (unsigned long)ce->e_value);


