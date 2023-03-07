Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEEFBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53272C433EF;
	Tue,  7 Mar 2023 18:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214009;
	bh=9q2CjSzVFzF+6ST2/NI9U+Wb5Hesf4447CQCQOBdN/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3ZBnnf0e4Dsiru12uxS11/41aqu9/bXIcBJDWzrT0T2EZGVVIFKlX20z+i0ANiF8
	 noTwvzWSLl61q1ygZ7mKv6XUyNJhQER3EE/9tg5KBIkbSrQRMZSBqoLQqub6sPV+b1
	 ABYUkTNIOaqqgbVt9cGkmrOC0MC3tS5V96A1vSYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Andy Wu <Andy.Wu@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 691/885] exfat: fix reporting fs error when reading dir beyond EOF
Date: Tue,  7 Mar 2023 18:00:25 +0100
Message-Id: <20230307170032.130487134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit 706fdcac002316893434d753be8cfb549fe1d40d upstream.

Since seekdir() does not check whether the position is valid, the
position may exceed the size of the directory. We found that for
a directory with discontinuous clusters, if the position exceeds
the size of the directory and the excess size is greater than or
equal to the cluster size, exfat_readdir() will return -EIO,
causing a file system error and making the file system unavailable.

Reproduce this bug by:

seekdir(dir, dir_size + cluster_size);
dirent = readdir(dir);

The following log will be printed if mount with 'errors=remount-ro'.

[11166.712896] exFAT-fs (sdb1): error, invalid access to FAT (entry 0xffffffff)
[11166.712905] exFAT-fs (sdb1): Filesystem has been set read-only

Fixes: 1e5654de0f51 ("exfat: handle wrong stream entry size in exfat_readdir()")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -102,7 +102,7 @@ static int exfat_readdir(struct inode *i
 			clu.dir = ei->hint_bmap.clu;
 		}
 
-		while (clu_offset > 0) {
+		while (clu_offset > 0 && clu.dir != EXFAT_EOF_CLUSTER) {
 			if (exfat_get_next_cluster(sb, &(clu.dir)))
 				return -EIO;
 


