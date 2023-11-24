Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488612EAEA;
	Fri, 24 Nov 2023 19:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVqHZVRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95DAC433C8;
	Fri, 24 Nov 2023 19:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853711;
	bh=hBT4e+KJf3xo1D6TfPTlhgMHnRMPggVbJdoj82hiU5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVqHZVRpzrjKPY2eG+eGiKK+Pr49KeHM/Jv9BhmLCJtprPM27+GeFTAL+soIptnNO
	 INIgGVfyxjiF53SO4MddszoPDCuUpzYNCnikq67RXSkUaXNyQi8FF39suVHr6eIuB4
	 ElKwKPIjyq+lzbioiHbICAzGYi2QZkTbtmZtjFmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 263/297] f2fs: avoid format-overflow warning
Date: Fri, 24 Nov 2023 17:55:05 +0000
Message-ID: <20231124172009.355800008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

commit e0d4e8acb3789c5a8651061fbab62ca24a45c063 upstream.

With gcc and W=1 option, there's a warning like this:

fs/f2fs/compress.c: In function ‘f2fs_init_page_array_cache’:
fs/f2fs/compress.c:1984:47: error: ‘%u’ directive writing between
1 and 7 bytes into a region of size between 5 and 8
[-Werror=format-overflow=]
 1984 |  sprintf(slab_name, "f2fs_page_array_entry-%u:%u", MAJOR(dev),
		MINOR(dev));
      |                                               ^~

String "f2fs_page_array_entry-%u:%u" can up to 35. The first "%u" can up
to 4 and the second "%u" can up to 7, so total size is "24 + 4 + 7 = 35".
slab_name's size should be 35 rather than 32.

Cc: stable@vger.kernel.org
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1906,7 +1906,7 @@ void f2fs_destroy_compress_inode(struct
 int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi)
 {
 	dev_t dev = sbi->sb->s_bdev->bd_dev;
-	char slab_name[32];
+	char slab_name[35];
 
 	sprintf(slab_name, "f2fs_page_array_entry-%u:%u", MAJOR(dev), MINOR(dev));
 


