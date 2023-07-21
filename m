Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BE220F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE956C433C7;
	Fri, 21 Jul 2023 19:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967193;
	bh=LAr34rb7JfArDBk9hjK5iK7YMYug1OFMWLBvAAzwQh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6JzUheLa0RA61zOYvQQrU66dQYloNMbDhkuLdoySyDq/o8ksKFw7OisXLfZjknbP
	 zCm9lY0k1boUXgPS+P3yk97H1DCjCKUiOg4sB3/e18o0JopfVYWxUn8z9xrMe86LVw
	 gbZx6u3t/7/9XjWOlaaXZSxZmgJIjBTWNA8jWWmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 075/223] f2fs: fix the wrong condition to determine atomic context
Date: Fri, 21 Jul 2023 18:05:28 +0200
Message-ID: <20230721160524.061454230@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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

commit 633c8b9409f564ce4b7f7944c595ffac27ed1ff4 upstream.

Should use !in_task for irq context.

Cc: stable@vger.kernel.org
Fixes: 1aa161e43106 ("f2fs: fix scheduling while atomic in decompression path")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -764,7 +764,7 @@ void f2fs_decompress_cluster(struct deco
 		ret = -EFSCORRUPTED;
 
 		/* Avoid f2fs_commit_super in irq context */
-		if (in_task)
+		if (!in_task)
 			f2fs_save_errors(sbi, ERROR_FAIL_DECOMPRESSION);
 		else
 			f2fs_handle_error(sbi, ERROR_FAIL_DECOMPRESSION);


