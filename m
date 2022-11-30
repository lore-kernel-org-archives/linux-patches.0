Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1585E79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D916C433D6;
	Wed, 30 Nov 2022 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834201;
	bh=r5jUQdIdGL8qjebpnHZ0vAMo1ct7Y2c30IQknelIS3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A946m5hWkjC3pErnM7HwGNhrOlhC9lTrMP8Qm8UWvxtvSEQ9amumIje0I5xNSHekc
	 J8HGO0Owe12LK94rXBHkwa6SJP2Xs8Nw/pQzmlyZhmzFsiiOE53VEJMalPgOv1HwRA
	 676J+9tH39olCaoj8wTDp/X2e4Z+FATSU/OcKXUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 166/289] cifs: fix missing unlock in cifs_file_copychunk_range()
Date: Wed, 30 Nov 2022 19:22:31 +0100
Message-Id: <20221130180547.895182244@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong2@huawei.com>

commit 502487847743018c93d75b401eac2ea4c4973123 upstream.

xfstests generic/013 and generic/476 reported WARNING as follows:

  WARNING: lock held when returning to user space!
  6.1.0-rc5+ #4 Not tainted
  ------------------------------------------------
  fsstress/504233 is leaving the kernel with locks still held!
  2 locks held by fsstress/504233:
   #0: ffff888054c38850 (&sb->s_type->i_mutex_key#21){+.+.}-{3:3}, at:
                        lock_two_nondirectories+0xcf/0xf0
   #1: ffff8880b8fec750 (&sb->s_type->i_mutex_key#21/4){+.+.}-{3:3}, at:
                        lock_two_nondirectories+0xb7/0xf0

This will lead to deadlock and hungtask.

Fix this by releasing locks when failed to write out on a file range in
cifs_file_copychunk_range().

Fixes: 3e3761f1ec7d ("smb3: use filemap_write_and_wait_range instead of filemap_write_and_wait")
Cc: stable@vger.kernel.org # 6.0
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1252,7 +1252,7 @@ ssize_t cifs_file_copychunk_range(unsign
 	rc = filemap_write_and_wait_range(src_inode->i_mapping, off,
 					  off + len - 1);
 	if (rc)
-		goto out;
+		goto unlock;
 
 	/* should we flush first and last page first */
 	truncate_inode_pages(&target_inode->i_data, 0);
@@ -1268,6 +1268,8 @@ ssize_t cifs_file_copychunk_range(unsign
 	 * that target is updated on the server
 	 */
 	CIFS_I(target_inode)->time = 0;
+
+unlock:
 	/* although unlocking in the reverse order from locking is not
 	 * strictly necessary here it is a little cleaner to be consistent
 	 */


