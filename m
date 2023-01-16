Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E60A33F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A11C433D2;
	Mon, 16 Jan 2023 16:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884890;
	bh=2eWK9Bya3zVxBKeULaiGcl6iyTRxEp7ta9AlV+kxhZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOsrYb68bBQ0iRQSLJnI2+IxzHS0YXofttDSg8I2ItFgcchDqYt3O8KNQo6R3Zsek
	 Nn9KaoB+QPeP6aMtPX1x4xem4bG663JKb+hX07IQRiy1YxqYZC0WIzUcB65AOJgkBN
	 LkiDvTYX9XqFegyEqtsjgS1krk3dcWB0XHcDPE1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=A7=84=ED=98=B8?= <wnwlsgh98@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 179/183] io_uring/io-wq: free worker if task_work creation is canceled
Date: Mon, 16 Jan 2023 16:51:42 +0100
Message-Id: <20230116154810.852514721@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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
@@ -1230,6 +1230,7 @@ static void io_wq_cancel_tw_create(struc
 
 		worker = container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
+		kfree(worker);
 	}
 }
 


