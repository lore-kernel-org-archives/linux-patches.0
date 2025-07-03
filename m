Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA812EFD81;
	Thu,  3 Jul 2025 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554439; cv=none; b=olJFnh9lUSIDRMM++BvV2XEoISPDy7dx5Nfz066RcrDHvAGNMOLfLyzyBtJVH3gqQiVjNqkqidbLWxoZ75iBRtThrjQehKuIsKHTrGp3ooLP9TMMtcxDcjs2kyIhmdwqOHI8vkBXW+xEPpG0PGwzzk/kZqUZXrzylFCes9TXHG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554439; c=relaxed/simple;
	bh=3sY2zjUaBuVUaiRu+Az0IyREQAV8t6JB9y/hYyGtvkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G55LJf8f3UOJctyd8aJdHH4ttfYB92eA1Yn5lw9UHrbNaXeekVe/vNu4BGZTKQApbz8nPRb13Mbo5+TIqI365VTsomigagF0Hf4iZp2ozNCIQ5QE+Gg9sSqeNDA90drubVJIaeEz+3UejQthEb/XEYNZWR6WNqwfmYp4n3+B/kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvKdtIQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvKdtIQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2419CC4CEE3;
	Thu,  3 Jul 2025 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554439;
	bh=3sY2zjUaBuVUaiRu+Az0IyREQAV8t6JB9y/hYyGtvkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvKdtIQz2kKv82cYGV94Ad9LCKdbETwQFo3vu1KDofNqznNBRsIEocw0vQAocCGbJ
	 1UZ+CUHeHBIJx0Q0LQfSu8BfCNOgCQ6u9UIvE60BJ0P3WCl3TUMN9upwY5TPyta/MN
	 p0jyHhNzBqbMzvHNNnrtTNYjycgKaWJRWdo5rIeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Roy Tang (ErgoniaTrading)" <royonia@ergonia.io>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 187/218] io_uring/net: always use current transfer count for buffer put
Date: Thu,  3 Jul 2025 16:42:15 +0200
Message-ID: <20250703144003.664260027@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

A previous fix corrected the retry condition for when to continue a
current bundle, but it missed that the current (not the total) transfer
count also applies to the buffer put. If not, then for incrementally
consumed buffer rings repeated completions on the same request may end
up over consuming.

Reported-by: Roy Tang (ErgoniaTrading) <royonia@ergonia.io>
Cc: stable@vger.kernel.org
Fixes: 3a08988123c8 ("io_uring/net: only retry recv bundle for a full transfer")
Link: https://github.com/axboe/liburing/issues/1423
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 51a4598ad5d9eb6be4ec9ba65bbfdf0ac302eb2e)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -854,7 +854,7 @@ static inline bool io_recv_finish(struct
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = *ret - sr->done_io;
 
-		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, this_ret),
+		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
 				      issue_flags);
 		if (sr->retry)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);


