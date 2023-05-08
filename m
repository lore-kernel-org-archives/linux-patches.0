Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684AE168DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7686C433D2;
	Mon,  8 May 2023 11:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545490;
	bh=/3rlLhmMAvHeAsdHIsHAOpAxcq2GEp/Sku0FfycaN+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6b/wv2U5EbZ/swqZEEQ702jALz2suc/xlV4XY8tHdYMgayh41VFs36Ct4jcWqLV+
	 iO2CvR7j0okTLnhDKTzUc+IuQXNLklg5PiwHJfGDC4wGRaCtg5DD4JEvny85XTJK2z
	 8ZKylGxDHci0ZMZSs4t9lIm4Es9CHOKcTwvhB2CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 056/371] ubifs: Free memory for tmpfile name
Date: Mon,  8 May 2023 11:44:17 +0200
Message-Id: <20230508094814.289587105@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mårten Lindahl <marten.lindahl@axis.com>

commit 1fb815b38bb31d6af9bd0540b8652a0d6fe6cfd3 upstream.

When opening a ubifs tmpfile on an encrypted directory, function
fscrypt_setup_filename allocates memory for the name that is to be
stored in the directory entry, but after the name has been copied to the
directory entry inode, the memory is not freed.

When running kmemleak on it we see that it is registered as a leak. The
report below is triggered by a simple program 'tmpfile' just opening a
tmpfile:

  unreferenced object 0xffff88810178f380 (size 32):
    comm "tmpfile", pid 509, jiffies 4294934744 (age 1524.742s)
    backtrace:
      __kmem_cache_alloc_node
      __kmalloc
      fscrypt_setup_filename
      ubifs_tmpfile
      vfs_tmpfile
      path_openat

Free this memory after it has been copied to the inode.

Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -488,6 +488,7 @@ static int ubifs_tmpfile(struct user_nam
 	unlock_2_inodes(dir, inode);
 
 	ubifs_release_budget(c, &req);
+	fscrypt_free_filename(&nm);
 
 	return 0;
 


