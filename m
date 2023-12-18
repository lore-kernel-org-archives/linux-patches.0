Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B862B22091;
	Mon, 18 Dec 2023 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4HE28gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E325FC433C9;
	Mon, 18 Dec 2023 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908801;
	bh=CpRh089F0I47ugIQU8H8tSRjHdOWLxaUm0lWfec3YWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4HE28gDsXDU4uudb4AD2ozFhJNXGb7qxNdwhJGFHO2iB8PeWBcGvYnU3nqUwYWrY
	 ms7YxjwzIDPHQSnjJ5CtZ7+MhKnWFOKUjC2TeqUNQ0jvFvuXr2ih+gKCkj61QhSMh/
	 wXG/Y5sNXSbqJ3nbOBQCYXzVHHm2HkAqKIEReOMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 39/83] fuse: dax: set fc->dax to NULL in fuse_dax_conn_free()
Date: Mon, 18 Dec 2023 14:52:00 +0100
Message-ID: <20231218135051.472736313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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
@@ -1227,6 +1227,7 @@ void fuse_dax_conn_free(struct fuse_conn
 	if (fc->dax) {
 		fuse_free_dax_mem_ranges(&fc->dax->free_ranges);
 		kfree(fc->dax);
+		fc->dax = NULL;
 	}
 }
 


