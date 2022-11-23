Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819077B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB90AC433D7;
	Wed, 23 Nov 2022 08:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193813;
	bh=Ae8EYFn2Me9WGxC8wMAvFS4+yGKTqzB+QiZmXtJq9vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghNgm3QMg+7tgCuIiglj9nKmLho+Jumt9PhynvbR0T/8DVZrA6kAqPU19VO1KiJru
	 UZpqGKoqgUEzPhXptYJgH4qmN8T1ujBbi505ipWQg107sBTXqJ0XJfOUcU0aQiwYM4
	 66s0nNP98azHBFLxAFdyLBVqpkmROVtJHDeBz684=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com,
	Dominique Martinet <asmadeus@codewreck.org>,
	Schspa Shi <schspa@gmail.com>
Subject: [PATCH 4.9 69/76] 9p: trans_fd/p9_conn_cancel: drop client lock earlier
Date: Wed, 23 Nov 2022 09:51:08 +0100
Message-Id: <20221123084549.005072250@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dominique Martinet <asmadeus@codewreck.org>

commit 52f1c45dde9136f964d63a77d19826c8a74e2c7f upstream.

syzbot reported a double-lock here and we no longer need this
lock after requests have been moved off to local list:
just drop the lock earlier.

Link: https://lkml.kernel.org/r/20220904064028.1305220-1-asmadeus@codewreck.org
Reported-by: syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Tested-by: Schspa Shi <schspa@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/trans_fd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -215,6 +215,8 @@ static void p9_conn_cancel(struct p9_con
 		list_move(&req->req_list, &cancel_list);
 	}
 
+	spin_unlock(&m->client->lock);
+
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
@@ -222,7 +224,6 @@ static void p9_conn_cancel(struct p9_con
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
 }
 
 static int


