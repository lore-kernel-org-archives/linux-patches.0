Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F51BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FF0C433EF;
	Tue,  7 Mar 2023 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211107;
	bh=a30CykW6YykybRzJUgVbj82sbmewX3xLsAzMmIApp0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lnq6eexuC/1lYjbrbFBGgU5ET9slJNY1aVY0jqSFvtpw9sZaI4078N+G5m0o2icxM
	 QoxxB6CXwEgJcPb98RvC5SJJf6J5AUH2yq1KbG7pguZ6WcHJlmDPw7zwFhiJ1h3+Fk
	 xiHDipz0uYWszdbTvqCDxWJfU84A2v4A/MPXjLYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	io-uring@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.2 0754/1001] io_uring: Replace 0-length array with flexible array
Date: Tue,  7 Mar 2023 17:58:46 +0100
Message-Id: <20230307170054.429075050@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

commit 36632d062975a9ff4410c90dd6d37922b68d0920 upstream.

Zero-length arrays are deprecated[1]. Replace struct io_uring_buf_ring's
"bufs" with a flexible array member. (How is the size of this array
verified?) Detected with GCC 13, using -fstrict-flex-arrays=3:

In function 'io_ring_buffer_select',
    inlined from 'io_buffer_select' at io_uring/kbuf.c:183:10:
io_uring/kbuf.c:141:23: warning: array subscript 255 is outside the bounds of an interior zero-length array 'struct io_uring_buf[0]' [-Wzero-length-bounds]
  141 |                 buf = &br->bufs[head];
      |                       ^~~~~~~~~~~~~~~
In file included from include/linux/io_uring.h:7,
                 from io_uring/kbuf.c:10:
include/uapi/linux/io_uring.h: In function 'io_buffer_select':
include/uapi/linux/io_uring.h:628:41: note: while referencing 'bufs'
  628 |                 struct io_uring_buf     bufs[0];
      |                                         ^~~~

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: stable@vger.kernel.org
Cc: io-uring@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20230105190507.gonna.131-kees@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/io_uring.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -625,7 +625,7 @@ struct io_uring_buf_ring {
 			__u16	resv3;
 			__u16	tail;
 		};
-		struct io_uring_buf	bufs[0];
+		__DECLARE_FLEX_ARRAY(struct io_uring_buf, bufs);
 	};
 };
 


