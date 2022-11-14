Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4F44C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9E6C433D6;
	Mon, 14 Nov 2022 13:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431232;
	bh=+vCHEWyFmgUTaNb1ANF0gqZlZvTT7oEdSAMWO5+HkVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clupkZ1To4dW+VVwlXMCbE/1Gd6a9LqWqrwpSf95SEpxwyHMvttUgRGK3meK03CHG
	 f0W6fXZNgWEh/NaF4qyumZsLzUZtBeodLHpXLIydB4OmM+MW0YG6AlagG3S/oAoHc6
	 zmykuhChlJRikZ0fQ+gh2uI7J/st6Ll2cf7dA2pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Langlois <olivier@trillion01.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 150/190] io_uring: check for rollover of buffer ID when providing buffers
Date: Mon, 14 Nov 2022 13:46:14 +0100
Message-Id: <20221114124505.369457921@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 3851d25c75ed03117268a8feb34adca5a843a126 upstream.

We already check if the chosen starting offset for the buffer IDs fit
within an unsigned short, as 65535 is the maximum value for a provided
buffer. But if the caller asks to add N buffers at offset M, and M + N
would exceed the size of the unsigned short, we simply add buffers with
wrapping around the ID.

This is not necessarily a bug and could in fact be a valid use case, but
it seems confusing and inconsistent with the initial check for starting
offset. Let's check for wrap consistently, and error the addition if we
do need to wrap.

Reported-by: Olivier Langlois <olivier@trillion01.com>
Link: https://github.com/axboe/liburing/issues/726
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -346,6 +346,8 @@ int io_provide_buffers_prep(struct io_ki
 	tmp = READ_ONCE(sqe->off);
 	if (tmp > USHRT_MAX)
 		return -E2BIG;
+	if (tmp + p->nbufs >= USHRT_MAX)
+		return -EINVAL;
 	p->bid = tmp;
 	return 0;
 }


