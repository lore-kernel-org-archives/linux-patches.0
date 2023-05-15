Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891BBFC1C
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22F1C4339B;
	Mon, 15 May 2023 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172833;
	bh=2GUXyi+STzdWTvYBhOvhqbTon2oBV3ejsSUcUTYS+Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rox/sDTTVSj1fJfXBupAX4u+cOqVk2Q5zNfbPLKKXKbUuUDgBa5Lw+qUjGcXCBxDL
	 YLUG6WwSwMIeqJUFamkvJGNSCC9dm0iR79L+4foSQXm6Wj4oj+/rF1zYScmpu+7Gs5
	 R55TuDAZVZvUu5dKDDw4F5MWbMu8g0rRbqbmXmh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Haberland <sth@linux.ibm.com>,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 281/381] s390/dasd: fix hanging blockdevice after request requeue
Date: Mon, 15 May 2023 18:28:52 +0200
Message-Id: <20230515161749.463777166@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Haberland <sth@linux.ibm.com>

commit d8898ee50edecacdf0141f26fd90acf43d7e9cd7 upstream.

The DASD driver does not kick the requeue list when requeuing IO requests
to the blocklayer. This might lead to hanging blockdevice when there is
no other trigger for this.

Fix by automatically kick the requeue list when requeuing DASD requests
to the blocklayer.

Fixes: e443343e509a ("s390/dasd: blk-mq conversion")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Link: https://lore.kernel.org/r/20230405142017.2446986-8-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -3000,7 +3000,7 @@ static int _dasd_requeue_request(struct
 		return 0;
 	spin_lock_irq(&cqr->dq->lock);
 	req = (struct request *) cqr->callback_data;
-	blk_mq_requeue_request(req, false);
+	blk_mq_requeue_request(req, true);
 	spin_unlock_irq(&cqr->dq->lock);
 
 	return 0;


