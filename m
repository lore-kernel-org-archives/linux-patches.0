Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4603A46B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF17DC433F0;
	Mon, 16 Jan 2023 16:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885121;
	bh=OPAaUWss3kggRsLZ9Cx/clbiMcyzfs3WLyn5KB1BSUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gu86muIONjRq8OBJe3FBRAkHT8jGTZZbcqoPOIppOW5tfHJd/hM96JfWG/tVZiXDy
	 m5nmTGE+866DA5TTrXYba6VJ+ZFBzKpuKHTlO/qEHQmYlVi+6Pr5EnOXCvXfPI5a3H
	 UG1xtxeZWrtH3soR3NFVuvhHWDS1DPSdMufJr3N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=A7=84=ED=98=B8?= <wnwlsgh98@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 82/86] io_uring/io-wq: free worker if task_work creation is canceled
Date: Mon, 16 Jan 2023 16:51:56 +0100
Message-Id: <20230116154750.448709266@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

commit af82425c6a2d2f347c79b63ce74fca6dc6be157f upstream.

If we cancel the task_work, the worker will never come into existance.
As this is the last reference to it, ensure that we get it freed
appropriately.

Cc: stable@vger.kernel.org
Reported-by: 진호 <wnwlsgh98@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1217,6 +1217,7 @@ static void io_wq_cancel_tw_create(struc
 
 		worker = container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
+		kfree(worker);
 	}
 }
 


