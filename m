Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF991170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BC7C433C8;
	Mon, 11 Sep 2023 14:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442144;
	bh=M4tTHqXx16nFH5ld0f22lfW56bAGgQ8MCTIMHIZZn+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCcoQIgdJbj20HmW/SztMUcr+1Pg/NqqcnFzZIsjULlJelD5TjEPZNfmw8FSLxraF
	 MaG6ta3xbywStymDhBp0ikUknoAe1G2JK/6sTWx0f9ferf3+FEPAY7FQnkLCs1SsEH
	 wWueCNRePMOrlRokuCI+gP7PQFMo0I7zOsRd8NPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 661/739] io_uring/net: dont overflow multishot recv
Date: Mon, 11 Sep 2023 15:47:40 +0200
Message-ID: <20230911134709.571713867@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit b2e74db55dd93d6db22a813c9a775b5dbf87c560 upstream.

Don't allow overflowing multishot recv CQEs, it might get out of
hand, hurt performance, and in the worst case scenario OOM the task.

Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55c ("io_uring: multishot recv")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0b295634e8f1b71aa764c984608c22d85f88f75c.1691757663.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -642,7 +642,7 @@ static inline bool io_recv_finish(struct
 
 	if (!mshot_finished) {
 		if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
-			       *ret, cflags | IORING_CQE_F_MORE, true)) {
+			       *ret, cflags | IORING_CQE_F_MORE, false)) {
 			io_recv_prep_retry(req);
 			/* Known not-empty or unknown state, retry */
 			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||


