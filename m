Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F5224A047;
	Tue, 21 Oct 2025 20:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077145; cv=none; b=hZciSNc/x9kTD0FO55wX5j79ph8lroKjSthnUCVmkiztDTeuCnzMtBVyqsUlhOuaA4UUzU9c977DlJUlImul5gejKR9JwM0YtGGd2/4D1bG7rqXC6dgEZTI740ssyth3Rw4mGlPdxl7FchlEk9fCFptsW5s9xzPt0dGqq4rCGZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077145; c=relaxed/simple;
	bh=GqZ8h5YtzFtNJrAtioP+PGVX1CzRjhsaX33mSQT0bd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPJYw382Ra7psZZd0ZzRASO3Y9oHq9vcXUrZDmUsspJzpekjf3hrWkNBbDFWqpPESGbzs6j8wNnt0EwGg+8mjmHBvdXUJXubBFV0fkDuTUyZIEzrwsWm2azegBpWrFRH/oee6wmVx7Tp7PS/YiFENzTwPIdj5YJBLNgCxYumkBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4qDzM40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4qDzM40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21071C4CEF1;
	Tue, 21 Oct 2025 20:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077144;
	bh=GqZ8h5YtzFtNJrAtioP+PGVX1CzRjhsaX33mSQT0bd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4qDzM40dmtwTAoBcVKsZ8c9bRYnLihZ0QxIec4kYhfoKE7xImXX4l2lsAu/iiMzf
	 OKiCcVkQSle3g4yGtgtlXMYVtWApwefCSOy3S29R3a8HY33klGymrNVepgv2m91enU
	 Fz7H4Uaqd9nnW0N9o9Myve9AKUDhfttBcsgpJZog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	Kevin Lumik <kevin@xf.ee>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 014/159] Revert "io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()"
Date: Tue, 21 Oct 2025 21:49:51 +0200
Message-ID: <20251021195043.527058688@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 927069c4ac2cd1a37efa468596fb5b8f86db9df0 upstream.

This reverts commit 90bfb28d5fa8127a113a140c9791ea0b40ab156a.

Kevin reports that this commit causes an issue for him with LVM
snapshots, most likely because of turning off NOWAIT support while a
snapshot is being created. This makes -EOPNOTSUPP bubble back through
the completion handler, where io_uring read/write handling should just
retry it.

Reinstate the previous check removed by the referenced commit.

Cc: stable@vger.kernel.org
Fixes: 90bfb28d5fa8 ("io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()")
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Reported-by: Kevin Lumik <kevin@xf.ee>
Link: https://lore.kernel.org/io-uring/cceb723c-051b-4de2-9a4c-4aa82e1619ee@kernel.dk/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -540,7 +540,7 @@ static void __io_complete_rw_common(stru
 {
 	if (res == req->cqe.res)
 		return;
-	if (res == -EAGAIN && io_rw_should_reissue(req)) {
+	if ((res == -EOPNOTSUPP || res == -EAGAIN) && io_rw_should_reissue(req)) {
 		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
 	} else {
 		req_set_fail(req);


