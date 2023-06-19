Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A5D10952
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73977C433CA;
	Mon, 19 Jun 2023 10:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170879;
	bh=v/K2K951N1AllIDWWWztB0U6RFdbO/hSvfoFqcqQKC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UP6BE1Lj/wV9i8ASl2ZZllcQGmSqjyvORws/Wsn3c8Xzt39POnc383XJGRJlJPkw0
	 gpnB9wZQseNMo2C5cnVIJrSA6C+KjA80zrKPNcu7pOrjPWNh0/wgAcpGrM9Jgl46hP
	 dzBtKbEJMPWQea7ntLk5gWQoqHO+KUMxU3lLBh8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanchan Joshi <joshi.k@samsung.com>,
	Wenwen Chen <wenwen.chen@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 042/187] io_uring: unlock sqd->lock before sq thread release CPU
Date: Mon, 19 Jun 2023 12:27:40 +0200
Message-ID: <20230619102159.648686439@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wenwen Chen <wenwen.chen@samsung.com>

[ Upstream commit 533ab73f5b5c95dcb4152b52d5482abcc824c690 ]

The sq thread actively releases CPU resources by calling the
cond_resched() and schedule() interfaces when it is idle. Therefore,
more resources are available for other threads to run.

There exists a problem in sq thread: it does not unlock sqd->lock before
releasing CPU resources every time. This makes other threads pending on
sqd->lock for a long time. For example, the following interfaces all
require sqd->lock: io_sq_offload_create(), io_register_iowq_max_workers()
and io_ring_exit_work().

Before the sq thread releases CPU resources, unlocking sqd->lock will
provide the user a better experience because it can respond quickly to
user requests.

Signed-off-by: Kanchan Joshi<joshi.k@samsung.com>
Signed-off-by: Wenwen Chen<wenwen.chen@samsung.com>
Link: https://lore.kernel.org/r/20230525082626.577862-1-wenwen.chen@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9db4bc1f521a3..5e329e3cd4706 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -255,9 +255,13 @@ static int io_sq_thread(void *data)
 			sqt_spin = true;
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
-			cond_resched();
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
+			if (unlikely(need_resched())) {
+				mutex_unlock(&sqd->lock);
+				cond_resched();
+				mutex_lock(&sqd->lock);
+			}
 			continue;
 		}
 
-- 
2.39.2



