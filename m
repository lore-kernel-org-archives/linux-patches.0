Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA0DE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9A0C433EF;
	Thu,  1 Jun 2023 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625733;
	bh=7gAUeDBuAEwBbWXLfgD4+4tlWntu2cygakOOQJajQvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2B2Geh9VcL25y9U2/bn22PtHc8hjgjiki7SPuwFAFoTfbxyUZrAHdYJSnqxDUspnn
	 nP5LUJYpIzEV/hEzHu1WQFjLSGG9bMJeOwZzJNsTuPo/N/QtU0pJOSsFhjB/E9of13
	 8kQz+JmSanIYt91yGJeM6zDErvzJEdN/pc5PONQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.4 12/16] io_uring: have io_kill_timeout() honor the request references
Date: Thu,  1 Jun 2023 14:21:07 +0100
Message-Id: <20230601131932.526569560@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131931.947241286@linuxfoundation.org>
References: <20230601131931.947241286@linuxfoundation.org>
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

No upstream commit exists for this patch.

Don't free the request unconditionally, if the request is issued async
then someone else may be holding a submit reference to it.

Reported-and-tested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -551,7 +551,8 @@ static void io_kill_timeout(struct io_ki
 		atomic_inc(&req->ctx->cq_timeouts);
 		list_del(&req->list);
 		io_cqring_fill_event(req->ctx, req->user_data, 0);
-		__io_free_req(req);
+		if (refcount_dec_and_test(&req->refs))
+			__io_free_req(req);
 	}
 }
 


