Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1584239A;
	Mon, 18 Dec 2023 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6Ose48q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50ADC433C8;
	Mon, 18 Dec 2023 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908128;
	bh=YxNfbC/fRLqmcAn2+mVCOdHTiwyhzHX1cqZfdf38B3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6Ose48qGqDIvm1Etc0zHxkoaIsTPVZrI1CocvMTbLGjIijkYhZszPUugbuYG7iP5
	 MhxDkWazbFAMAgGfF2CrAEa4iWmv30DQZedDbw4GohzdRk6C+//zzYqlp62fhLRgea
	 XZcusXuUSubB7+/H9ILxJ7OID+aNH9ZTTfG/0yXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 064/166] fuse: dax: set fc->dax to NULL in fuse_dax_conn_free()
Date: Mon, 18 Dec 2023 14:50:30 +0100
Message-ID: <20231218135107.902613235@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangyu Hua <hbh25y@gmail.com>

commit 7f8ed28d1401320bcb02dda81b3c23ab2dc5a6d8 upstream.

fuse_dax_conn_free() will be called when fuse_fill_super_common() fails
after fuse_dax_conn_alloc(). Then deactivate_locked_super() in
virtio_fs_get_tree() will call virtio_kill_sb() to release the discarded
superblock. This will call fuse_dax_conn_free() again in fuse_conn_put(),
resulting in a possible double free.

Fixes: 1dd539577c42 ("virtiofs: add a mount option to enable dax")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # v5.10
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dax.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -1222,6 +1222,7 @@ void fuse_dax_conn_free(struct fuse_conn
 	if (fc->dax) {
 		fuse_free_dax_mem_ranges(&fc->dax->free_ranges);
 		kfree(fc->dax);
+		fc->dax = NULL;
 	}
 }
 


