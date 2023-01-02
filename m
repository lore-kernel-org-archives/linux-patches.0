Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8618428EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1042EC433EF;
	Mon,  2 Jan 2023 11:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658771;
	bh=G1ionXDaPtgg288RrhvFcOJak9FZg0RxZCNVRLPN71E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/F+nZblZ5dph3fjgbOmWxDIjjXqx7GiiPld9FdCM3MHNaFdmQrMOi8g9CKTfiqDS
	 IBeT2+9I4pXKvvL4fS/f6phNzOyu3zhWWNQEVpe0Lt0szGYoEi8rFa1NwOTVwvkrD9
	 R4fC40K8GdMTWYspNILZSPEo/meVqz9NeL0Cr8Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 64/71] f2fs: allow to read node block after shutdown
Date: Mon,  2 Jan 2023 12:22:29 +0100
Message-Id: <20230102110554.172564790@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit e6ecb142429183cef4835f31d4134050ae660032 upstream.

If block address is still alive, we should give a valid node block even after
shutdown. Otherwise, we can see zero data when reading out a file.

Cc: stable@vger.kernel.org
Fixes: 83a3bfdb5a8a ("f2fs: indicate shutdown f2fs to allow unmount successfully")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1360,8 +1360,7 @@ static int read_node_page(struct page *p
 		return err;
 
 	/* NEW_ADDR can be seen, after cp_error drops some dirty node pages */
-	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR) ||
-			is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)) {
+	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR)) {
 		ClearPageUptodate(page);
 		return -ENOENT;
 	}


