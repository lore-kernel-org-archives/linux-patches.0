Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C55132129;
	Wed, 19 Jun 2024 13:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802462; cv=none; b=kwrB7nrbz7G0gMVTsFX00SdwFs2/7sogZvoV7ficWMCf19V5b04AeYhtQ6xdIwglcoZ0RNfQcrigt0GiYXe2NbNtwy+f58wghWpGozjDMNFZgoRv1IeLf/fEcKCMRA3KZwabXq3G2bnwxk7OeAy2bWF6gO2yPouloFC/ZlzAXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802462; c=relaxed/simple;
	bh=PXm8EP/poJkcMQFpxkDsJEQ25m9bMWKGHF9pRDX9o/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlNNUid/CplE//0g0p0SvbBcPv3BcRhSP7RxmHfg30h0RLvWKzng2jewc6t+0pPRpIL5OLr7hIslKWqnFn9HgHhwsZ4pTvswNQIq4Dp55R5LorQ0aJ4/dSgCsqnrX+7yu1NSZi1oWFRaoxEUEsA4htqk7FKEB63uJjqzrdQm/bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hv2S6Wmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hv2S6Wmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE54DC2BBFC;
	Wed, 19 Jun 2024 13:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802462;
	bh=PXm8EP/poJkcMQFpxkDsJEQ25m9bMWKGHF9pRDX9o/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv2S6Wmcp6eW86ZnRwZxcZAwjpphSOl8++LVDanKh1+vYvCAiO02e5LyM4tga4OC0
	 g6g9qDx1/7nA8jBxnpHg5Y4uTVzFyE5FAaampazxlvpsbqc6mXP4TXkuzIKvQQkkNu
	 BHhq192QyNLuW9enVvkdCQu2d9jUa2oYEqUTm8Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 204/267] ocfs2: use coarse time for new created files
Date: Wed, 19 Jun 2024 14:55:55 +0200
Message-ID: <20240619125614.159743081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Su Yue <glass.su@suse.com>

commit b8cb324277ee16f3eca3055b96fce4735a5a41c6 upstream.

The default atime related mount option is '-o realtime' which means file
atime should be updated if atime <= ctime or atime <= mtime.  atime should
be updated in the following scenario, but it is not:
==========================================================
$ rm /mnt/testfile;
$ echo test > /mnt/testfile
$ stat -c "%X %Y %Z" /mnt/testfile
1711881646 1711881646 1711881646
$ sleep 5
$ cat /mnt/testfile > /dev/null
$ stat -c "%X %Y %Z" /mnt/testfile
1711881646 1711881646 1711881646
==========================================================

And the reason the atime in the test is not updated is that ocfs2 calls
ktime_get_real_ts64() in __ocfs2_mknod_locked during file creation.  Then
inode_set_ctime_current() is called in inode_set_ctime_current() calls
ktime_get_coarse_real_ts64() to get current time.

ktime_get_real_ts64() is more accurate than ktime_get_coarse_real_ts64().
In my test box, I saw ctime set by ktime_get_coarse_real_ts64() is less
than ktime_get_real_ts64() even ctime is set later.  The ctime of the new
inode is smaller than atime.

The call trace is like:

ocfs2_create
  ocfs2_mknod
    __ocfs2_mknod_locked
    ....

      ktime_get_real_ts64 <------- set atime,ctime,mtime, more accurate
      ocfs2_populate_inode
    ...
    ocfs2_init_acl
      ocfs2_acl_set_mode
        inode_set_ctime_current
          current_time
            ktime_get_coarse_real_ts64 <-------less accurate

ocfs2_file_read_iter
  ocfs2_inode_lock_atime
    ocfs2_should_update_atime
      atime <= ctime ? <-------- false, ctime < atime due to accuracy

So here call ktime_get_coarse_real_ts64 to set inode time coarser while
creating new files.  It may lower the accuracy of file times.  But it's
not a big deal since we already use coarse time in other places like
ocfs2_update_inode_atime and inode_set_ctime_current.

Link: https://lkml.kernel.org/r/20240408082041.20925-5-glass.su@suse.com
Fixes: c62c38f6b91b ("ocfs2: replace CURRENT_TIME macro")
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -566,7 +566,7 @@ static int __ocfs2_mknod_locked(struct i
 	fe->i_last_eb_blk = 0;
 	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
 	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
-	ktime_get_real_ts64(&ts);
+	ktime_get_coarse_real_ts64(&ts);
 	fe->i_atime = fe->i_ctime = fe->i_mtime =
 		cpu_to_le64(ts.tv_sec);
 	fe->i_mtime_nsec = fe->i_ctime_nsec = fe->i_atime_nsec =


