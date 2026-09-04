Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCA7415B71;
	Fri,  4 Sep 2026 05:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500354; cv=none; b=LxkaUv2cmqyqdu6sf2R8g15OvV6f9F3gUZKy9Erl51AYAdxXmr1KUb/jlksOw4za1bSGwbQXdBEInE8GcHqGYqia9Z9NXsGkHzql1HCP2MW+CvZ0SgzHt5oIHID27p97U6Q2TXVNtPeLo2NQYucP0jeG04tBwUBsoXp2nu7ubU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500354; c=relaxed/simple;
	bh=/XtW6y8rkAVNr6wCmbj9JAiOaTpTcLsZLCTRo400at4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eig/L2jtZb7jyLo2yumE8p+v4F7Nnvwh86k7x2h4bHKNe8h5Hf8mmFQjtMPvp1Sq1TfVkqiNYJqZV/157PqBx7ZkwbK+HDJ4+6o4UfEnzbRPgajE/LkwACbI2FEPyUSWgdRwvAup3PQbLXGKhHqsHu/2wAcJ6l6BGIkL/9pd65o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNM9AeoB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNM9AeoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4BA1F00A3D;
	Fri,  4 Sep 2026 05:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500349;
	bh=t765zvqbm4P/g+A8QZAT3TaXhpXzyDfv17b7+KLPIzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNM9AeoBJgy6mP6xZjUZ4J64F3Kc/vQv6sFGOF5tvmpPWKLHJxYe1i0jVnSM4ORKO
	 6Y/I4pCW1ZP0RqqkVOSh1TM+nt7UGRk8K+vlZUr1EDdA5CjodR0AYTooB9WjP1RqO0
	 ildy3t4pY8JhAIGhJwe/v2et8Dt+e8Of77STv/Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d6540a3fa1626e11360d@syzkaller.appspotmail.com,
	Rochan Avlur <rochan.avlur@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/552] fuse: wait for FR_FINISHED on abort_on_kill to prevent use-after-free
Date: Fri,  4 Sep 2026 06:52:41 +0200
Message-ID: <20260904045747.922444777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Rochan Avlur <rochan.avlur@gmail.com>

[ Upstream commit 64b0b5cacbd2fea88001464cb712c9dfc795b26e ]

The abort_on_kill path in request_wait_answer() calls fuse_abort_conn()
and returns without waiting for FR_FINISHED.  If fuse_dev_do_write() is
concurrently processing the same request (FR_LOCKED set), the caller
frees req->args while it is still being accessed, causing a
use-after-free.

Fix this by jumping to the existing wait_event(FR_FINISHED) instead of
returning early.  The wait will not hang because fuse_abort_conn()
ensures all requests are ended.

Reported-by: syzbot+d6540a3fa1626e11360d@syzkaller.appspotmail.com
Fixes: 204aa22a686b ("fuse: abort on fatal signal during sync init")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Rochan Avlur <rochan.avlur@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 77c3982bca3d7..e5559d28031bc 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -580,7 +580,7 @@ static void request_wait_answer(struct fuse_req *req)
 
 		if (req->args->abort_on_kill) {
 			fuse_abort_conn(fc);
-			return;
+			goto wait_for_finish;
 		}
 
 		if (test_bit(FR_URING, &req->flags))
@@ -591,6 +591,7 @@ static void request_wait_answer(struct fuse_req *req)
 			return;
 	}
 
+wait_for_finish:
 	/*
 	 * Either request is already in userspace, or it was forced.
 	 * Wait it out.
-- 
2.53.0



