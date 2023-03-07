Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16097BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF9CC433D2;
	Tue,  7 Mar 2023 17:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211323;
	bh=/GcI8ztlGClBKf6nyfA6O8NvDYgvK54NcPnfofWr7L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayCqkRJ1C0+SHyWznn7emzoO6R9SGbp4f7yZYmOGf/uzlbsled51CYJ5khIFKq4Gd
	 nhlcFa6cHT+x1hriEn7h4Hv6tTgJowbfjvIZum63I0BJMDm78JTIsNyvfcro9SUxty
	 1n5AE7E3uXjHoLFjoBAzndfApeeVKpIBsyHKxD/0=
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
Subject: [PATCH 6.2 0794/1001] exfat: fix unexpected EOF while reading dir
Date: Tue,  7 Mar 2023 17:59:26 +0100
Message-Id: <20230307170056.205564092@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
@@ -234,10 +234,7 @@ static int exfat_iterate(struct file *fi
 		fake_offset = 1;
 	}
 
-	if (cpos & (DENTRY_SIZE - 1)) {
-		err = -ENOENT;
-		goto unlock;
-	}
+	cpos = round_up(cpos, DENTRY_SIZE);
 
 	/* name buffer should be allocated before use */
 	err = exfat_alloc_namebuf(nb);


