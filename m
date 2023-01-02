Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C402F28EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC7FC433EF;
	Mon,  2 Jan 2023 11:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658969;
	bh=SNCb75FWjVMjGAdEby7dYpMFZdLTjQlTzOev/JJbCl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilOK1ZX3srDZxxXXVQjDaWPZVcVlAu48oOBhQgDRJ0nhGqqB0EdOmMQw6Nwe8df/x
	 dv7xdcXi3pw8c5ddx9B3IzTeHlXywLLMXq5Ut0RKW25kMoS1XFtd895MOGRqeGlBDq
	 78Fz8nZJDOeX92cXzLf3dsf9f2DgHFl1Psr0Ho5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.0 67/74] f2fs: allow to read node block after shutdown
Date: Mon,  2 Jan 2023 12:22:40 +0100
Message-Id: <20230102110554.948181931@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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
@@ -1358,8 +1358,7 @@ static int read_node_page(struct page *p
 		return err;
 
 	/* NEW_ADDR can be seen, after cp_error drops some dirty node pages */
-	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR) ||
-			is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)) {
+	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR)) {
 		ClearPageUptodate(page);
 		return -ENOENT;
 	}


