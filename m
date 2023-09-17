Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387587461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABDEC43391;
	Sun, 17 Sep 2023 20:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980835;
	bh=dIdplIjUgxEjiHRyfzGLGVHV8R+19hclroVL09+JGrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfyne+kmS+QC/ZJVbRk752Kgc71KURGL7JjMip83E/tM2gaPjkkgIbEHNSY4jqKDb
	 IKmkCLH9EtKCcP4K/tYYnDaXuxfRsjJMDRx+mpRcxCE8NX+hat8gyNrUqju/poAuSu
	 hom702ZPVNvetn8s2JiAsbbyhw/qTpCJCsmr6WBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 006/219] io_uring/net: dont overflow multishot accept
Date: Sun, 17 Sep 2023 21:12:13 +0200
Message-ID: <20230917191041.195126484@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit 1bfed23349716a7811645336a7ce42c4b8f250bc ]

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
@@ -1339,7 +1339,7 @@ retry:
 
 	if (ret < 0)
 		return ret;
-	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, true))
+	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, false))
 		goto retry;
 
 	return -ECANCELED;


