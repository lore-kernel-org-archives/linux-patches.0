Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCCC1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5081CC433C8;
	Mon, 11 Sep 2023 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442147;
	bh=AvOpcfc29CajKSYRwpFUugaxM6+M8KtxXa76JIKIUDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfcjU2BqLr4D1wrekjt5nO17NpmOzkYO6g5ZnKt+3yefpwg/T7WaHPoEAvhoY0dy0
	 gdKPF6+YJAKJAtJn1dajxKkHrBfpuU4HVunhgmBZE0twidguAG5y8EYlH4gEnAxkKP
	 uumJaGjsq5VJJarJf2V6c/d3g+oEXEZR7TNppaRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 662/739] io_uring/net: dont overflow multishot accept
Date: Mon, 11 Sep 2023 15:47:41 +0200
Message-ID: <20230911134709.597636464@linuxfoundation.org>
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

commit 1bfed23349716a7811645336a7ce42c4b8f250bc upstream.

Don't allow overflowing multishot accept CQEs, we want to limit
the grows of the overflow list.

Cc: stable@vger.kernel.org
Fixes: 4e86a2c980137 ("io_uring: implement multishot mode for accept")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7d0d749649244873772623dd7747966f516fe6e2.1691757663.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1367,7 +1367,7 @@ retry:
 	if (ret < 0)
 		return ret;
 	if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER, ret,
-		       IORING_CQE_F_MORE, true))
+		       IORING_CQE_F_MORE, false))
 		goto retry;
 
 	return -ECANCELED;


