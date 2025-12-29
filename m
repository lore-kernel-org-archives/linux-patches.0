Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDE73346BD;
	Mon, 29 Dec 2025 16:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026044; cv=none; b=CiWW0QnaHBsLk37ZtsHzsx0DOpMNnxucUtdmN2Zhnxdk+aXXY+cM4RyNPY06xPUDzUlpZzZ/TmDmA5oY/sb4oVtfj6l4uNhm8480US4Un6MiKZUzlv139p7XbByvTe4foNOa91qfPR+Jjjyjl0AkSn0ND2gigNeS2bKwnXNDQYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026044; c=relaxed/simple;
	bh=ibi+Pf2i7YCM4i7tJL6b+U+ojseE33FxGVAg/2DlN6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrUmEAJ75UjiGh3A+xUnqzdum1Lutpqye8NS3N4kWCA9NqSVjgcXxFxm9fIlDqDVDyCUsWLEQIsMxjqETkOQV4JLWBAJq7LCg2MKqKoc6qAv7zR6SLy6qEzNyaMIp+0cZfmYVIMtvNKtorw8I4/jI1u+NDBHxkjyt6SXoAh8AxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJLLGWk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJLLGWk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0336BC4CEF7;
	Mon, 29 Dec 2025 16:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026044;
	bh=ibi+Pf2i7YCM4i7tJL6b+U+ojseE33FxGVAg/2DlN6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJLLGWk7bCl8YdpyHYeYu/2IeLW9+djxFqDvIaivPz5qEpShw55YmN+0HugN0VD7j
	 iVT0g6i/zNUjuksNlp/vq/2oJp6480DFy5Vl4Zzw9mkTIVTQT/ksAcfXG7aDKkK1Lc
	 Lm89zihPEyS2h/QAoeC7tCJtjuHOOMLm/bYfsoHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 428/430] fuse: fix io-uring list corruption for terminated non-committed requests
Date: Mon, 29 Dec 2025 17:13:50 +0100
Message-ID: <20251229160740.062173546@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit 95c39eef7c2b666026c69ab5b30471da94ea2874 upstream.

When a request is terminated before it has been committed, the request
is not removed from the queue's list. This leaves a dangling list entry
that leads to list corruption and use-after-free issues.

Remove the request from the queue's list for terminated non-committed
requests.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Fixes: c090c8abae4b ("fuse: Add io-uring sqe commit and fetch support")
Cc: stable@vger.kernel.org
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 0066c9c0a5d5..7760fe4e1f9e 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -86,6 +86,7 @@ static void fuse_uring_req_end(struct fuse_ring_ent *ent, struct fuse_req *req,
 	lockdep_assert_not_held(&queue->lock);
 	spin_lock(&queue->lock);
 	ent->fuse_req = NULL;
+	list_del_init(&req->list);
 	if (test_bit(FR_BACKGROUND, &req->flags)) {
 		queue->active_background--;
 		spin_lock(&fc->bg_lock);
-- 
2.52.0



