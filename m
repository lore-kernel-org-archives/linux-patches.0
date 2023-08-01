Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6033200A7
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E89C433C7;
	Tue,  1 Aug 2023 09:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883468;
	bh=b2vX+9Aej4/+tHWd3qLzJGnYcZmg0ccTNaIOibTA2sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfUmeon8iXsnocRGV1H0edYONVA0hYB8B6w8s5ao9poPYZRlwuIzhNqfrDspiVhX0
	 WwY0Vw5cqscvqjddwei0ho8aSiTYbYDl0wz8lQeaCPmsd5CXDvTThnPlkCEgXAz/xT
	 iof0TJSdnmN1oFAE8V2exVVkBkwmeg/tpHFPTdA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Eric Van Hensbergen <ericvh@kernel.org>
Subject: [PATCH 6.4 217/239] fs/9p: remove unnecessary and overrestrictive check
Date: Tue,  1 Aug 2023 11:21:21 +0200
Message-ID: <20230801091933.739976804@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Van Hensbergen <ericvh@kernel.org>

commit 75b396821cb71164dac3a1ad51dda4781ea8dbad upstream.

This eliminates a check for shared that was overrestrictive and
prevented read-only mmaps when writeback caches weren't enabled.

Cc: stable@vger.kernel.org
Fixes: 1543b4c5071c ("fs/9p: remove writeback fid and fix per-file modes")
Reported-by: Robert Schwebel <r.schwebel@pengutronix.de>
Closes: https://lore.kernel.org/v9fs/ZK25XZ%2BGpR3KHIB%2F@pengutronix.de
Reviewed-by: Dominique Martinet <asmadeus@codewreck.org>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_file.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -483,9 +483,7 @@ v9fs_file_mmap(struct file *filp, struct
 	p9_debug(P9_DEBUG_MMAP, "filp :%p\n", filp);
 
 	if (!(v9ses->cache & CACHE_WRITEBACK)) {
-		p9_debug(P9_DEBUG_CACHE, "(no mmap mode)");
-		if (vma->vm_flags & VM_MAYSHARE)
-			return -ENODEV;
+		p9_debug(P9_DEBUG_CACHE, "(read-only mmap mode)");
 		invalidate_inode_pages2(filp->f_mapping);
 		return generic_file_readonly_mmap(filp, vma);
 	}


