Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A157F8821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C03DC4339C;
	Fri, 10 Mar 2023 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460461;
	bh=tW6PRi4Ld7Bh2v0f3icgnKsZmf+eVcix7iSwQY3kB1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7s3l4B3yJ47Oz8wpkvTgbPq8j49a+IY4YOCyzO3XwIGUAiFoBv8t2EZn1HhQb4w0
	 h2GNe0GmKG+sllffL3eVZSozVL1GGHrztY+P1NqsWac5bAScmpKPv5hYxOIxJyexDD
	 6TTDKg+401V/hay+/1D72dVvlG7AbjKW2uAkWU6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yugui <wangyugui@e16-tech.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Andy Wu <Andy.Wu@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.10 341/529] exfat: fix unexpected EOF while reading dir
Date: Fri, 10 Mar 2023 14:38:04 +0100
Message-Id: <20230310133820.817597096@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

commit 6cb5d1a16a51d080fbc1649a5144cbc5ca7d6f88 upstream.

If the position is not aligned with the dentry size, the return
value of readdir() will be NULL and errno is 0, which means the
end of the directory stream is reached.

If the position is aligned with dentry size, but there is no file
or directory at the position, exfat_readdir() will continue to
get dentry from the next dentry. So the dentry gotten by readdir()
may not be at the position.

After this commit, if the position is not aligned with the dentry
size, round the position up to the dentry size and continue to get
the dentry.

Fixes: ca06197382bd ("exfat: add directory operations")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -236,10 +236,7 @@ static int exfat_iterate(struct file *fi
 		fake_offset = 1;
 	}
 
-	if (cpos & (DENTRY_SIZE - 1)) {
-		err = -ENOENT;
-		goto unlock;
-	}
+	cpos = round_up(cpos, DENTRY_SIZE);
 
 	/* name buffer should be allocated before use */
 	err = exfat_alloc_namebuf(nb);


