Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFC01F7578;
	Tue,  3 Dec 2024 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237914; cv=none; b=BEm+SsNryqHViw2bhsuSSvUX1wn9eRZvyje1G7o85WKlRvt1ddxdbgBIVDusGfEdXQKhq5l2Ddgb+iYtk74GxZcx588tBjCAUYs2PcSgiSIu0kcx0codKbQrYd8qvGSgb4AXEUTbekWTSSgBZAXO8VdNhF92wgUiIS9jEqETlHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237914; c=relaxed/simple;
	bh=JCR5vY5Rrs2wf6PtVBaQPAYh22IGFQzjjcEblULdf0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4xUkonxWgiL8UY0cpWXI/B7UZxwiSQ7oYNQMezeKnqG56xerHU0ulK1+a56hs7p2KIh+cANDdu7+TeVfuIP5bgIIuUeo0Sq4PWo3EwFS6ArXpJOBrI/1ikMMhmehBl1sqrBN1fJtnReWSaqe4UhFCA9+kobArDcuLrMNO9EIxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpi2qaPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpi2qaPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB7EC4CED6;
	Tue,  3 Dec 2024 14:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237914;
	bh=JCR5vY5Rrs2wf6PtVBaQPAYh22IGFQzjjcEblULdf0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpi2qaPI8be6ye7Rp+531+VD2Xba5vqzQhpv8ZO9DYPwIaQX8pNbnoxQHzE4Lzujt
	 an9W6yrEoG7dV7foRBv8nRUxIPi40NcaOT2Tw4Z3neeI8FyjsQIbdfl2arN4X5mXKy
	 Bge6BmNNNMJr05UdbRg25rqz0WGG0HMcPnueK7a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 074/817] cachefiles: Fix missing pos updates in cachefiles_ondemand_fd_write_iter()
Date: Tue,  3 Dec 2024 15:34:06 +0100
Message-ID: <20241203143958.578369675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index bdd321017f1c4..38ca6dce8ef29 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -77,8 +77,10 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 
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



