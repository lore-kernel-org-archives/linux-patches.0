Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ECB611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CC7C433C7;
	Mon, 28 Aug 2023 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219382;
	bh=9HTwGfkCOerCcr/mTh0H9Gr3lHBrS+iBZzfIbrnG15k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fJKK9R9ieKAt8kWwKG/t+2+ZQ4EbgYSQNsCFt1yiQ8PtPG6H6cbWmYbeXT5rK1rR
	 yGB0f4ajJGf7ml1/4EAeCZ2KZRjvMKjb4K+Pl0xy+J6SmqCQrX2thNOGPQmRcH9moq
	 UXFpwCVqyazlqKBIW0vBGvmCNtvewYvY5dxdLFKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/89] NFSv4.2: fix error handling in nfs42_proc_getxattr
Date: Mon, 28 Aug 2023 12:13:03 +0200
Message-ID: <20230828101150.262766639@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 4e3733fd2b0f677faae21cf838a43faf317986d3 ]

There is a slight issue with error handling code inside
nfs42_proc_getxattr(). If page allocating loop fails then we free the
failing page array element which is NULL but __free_page() can't deal with
NULL args.

Found by Linux Verification Center (linuxtesting.org).

Fixes: a1f26739ccdc ("NFSv4.2: improve page handling for GETXATTR")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index da94bf2afd070..bc07012741cb4 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -1339,7 +1339,6 @@ ssize_t nfs42_proc_getxattr(struct inode *inode, const char *name,
 	for (i = 0; i < np; i++) {
 		pages[i] = alloc_page(GFP_KERNEL);
 		if (!pages[i]) {
-			np = i + 1;
 			err = -ENOMEM;
 			goto out;
 		}
@@ -1363,8 +1362,8 @@ ssize_t nfs42_proc_getxattr(struct inode *inode, const char *name,
 	} while (exception.retry);
 
 out:
-	while (--np >= 0)
-		__free_page(pages[np]);
+	while (--i >= 0)
+		__free_page(pages[i]);
 	kfree(pages);
 
 	return err;
-- 
2.40.1



