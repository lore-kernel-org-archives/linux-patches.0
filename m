Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380C2213E6B;
	Thu, 12 Dec 2024 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018911; cv=none; b=dUCNM+ox+ACDRSjyGRXTGZsMVB4nMwbaaU0qZsJct4CiftHqDKX19/JlHBvHBM4zMrcfN922O3Ztp+bKV8RyiBkoBGCrnEOvhkkQcB39PBGEkp7W6+hbFrmY4Az5ZGUPy9B1P9KMjj/eEgTfYrifmsEF91W4jfAuhZWpeorLFXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018911; c=relaxed/simple;
	bh=l2703YuL4XgbXL98QG1+7i0+BwY/6/Zgqz6TaOW1Gxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auEDSxG/XP3ftA06VBZ03oX9quyk2uvMbBV7uPqDgcFZeaQk0Wnn18iblSbZVvZyY6eniBLAHec2ogU91xDB3CzPSb5EQCg+FQJ7Bot/c6QjVm9cltfFpmvQ7Hv2pVQ0XMVFlMdxVgwn5akYOLFkAyFZ8pcVpyYDNFWwl0nGE9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0I/FxCOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0I/FxCOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99053C4CECE;
	Thu, 12 Dec 2024 15:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018911;
	bh=l2703YuL4XgbXL98QG1+7i0+BwY/6/Zgqz6TaOW1Gxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0I/FxCOjTizphmSg8GtwF99Oakw29h28R0hH2i7l+s/vtP6dVUMZWmu3faXGPEefh
	 Y34yGOCBmdTRX4tswQgGfgwuHT4kclz7Ng5qA6IJfl02cjXKrhACcNnfG84rRlL/7L
	 NFdtdYrNIA0NVg38iHD8gxFpmnKQA78a6F7EpTNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/772] cachefiles: Fix missing pos updates in cachefiles_ondemand_fd_write_iter()
Date: Thu, 12 Dec 2024 15:50:05 +0100
Message-ID: <20241212144352.428669960@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 56f4856b425a30e1d8b3e41e6cde8bfba90ba5f8 ]

In the erofs on-demand loading scenario, read and write operations are
usually delivered through "off" and "len" contained in read req in user
mode. Naturally, pwrite is used to specify a specific offset to complete
write operations.

However, if the write(not pwrite) syscall is called multiple times in the
read-ahead scenario, we need to manually update ki_pos after each write
operation to update file->f_pos.

This step is currently missing from the cachefiles_ondemand_fd_write_iter
function, added to address this issue.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://lore.kernel.org/r/20241107110649.3980193-3-wozizhi@huawei.com
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 2185e2908dba8..d1a0264b08a6c 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -78,8 +78,10 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 
 	trace_cachefiles_ondemand_fd_write(object, file_inode(file), pos, len);
 	ret = __cachefiles_write(object, file, pos, iter, NULL, NULL);
-	if (!ret)
+	if (!ret) {
 		ret = len;
+		kiocb->ki_pos += ret;
+	}
 
 	return ret;
 }
-- 
2.43.0



