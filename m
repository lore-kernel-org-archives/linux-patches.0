Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E0111C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C9DC433C7;
	Mon, 28 Aug 2023 10:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218579;
	bh=Z7skcU9s9WwG2HqW1kmLNfS6OdXH0w6Wp09NFRflw4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbQfawcvnRxuM1kgliyspO4jDlgH/Nkku0UEtNWI0769oCLQik4ixJNSpsLKmi1mF
	 7x2tYs1HFSS4Ru8XJnHjL+maehcn6/9ifXyyvmT8gZhlWGX4MYiwBR0Yo80G+x32P2
	 HNSFQOJHtd0HB0G7VUw8VX2beyzrDwbplPdkCddw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/122] NFSv4.2: fix error handling in nfs42_proc_getxattr
Date: Mon, 28 Aug 2023 12:11:56 +0200
Message-ID: <20230828101156.528209711@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ecb428512fe1a..7c33bba179d2f 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -1359,7 +1359,6 @@ ssize_t nfs42_proc_getxattr(struct inode *inode, const char *name,
 	for (i = 0; i < np; i++) {
 		pages[i] = alloc_page(GFP_KERNEL);
 		if (!pages[i]) {
-			np = i + 1;
 			err = -ENOMEM;
 			goto out;
 		}
@@ -1383,8 +1382,8 @@ ssize_t nfs42_proc_getxattr(struct inode *inode, const char *name,
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



