Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980146FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217FAC433D2;
	Mon,  3 Apr 2023 14:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532839;
	bh=VDIKByrjFwJadvxCfIMimiwD56vO1+SxUkRXlmpWgjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyPH8ZDC3bKpvhwi4VMY9jBHAR0IpjUJJou9AwuyHBDLm5a+ETWnz5nzfpa6/bMiP
	 vCvLb1zpqMn9YP2Qm0jnim26WVpMood1GwyGEavLA1aUI0P4tiLKfPjm+gjKZ4DJh+
	 yewWlmcvQvCNxOp6geE1OxX2T3M3Kzk59igIdrpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 136/181] io_uring/rsrc: fix rogue rsrc node grabbing
Date: Mon,  3 Apr 2023 16:09:31 +0200
Message-Id: <20230403140419.492634637@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit 4ff0b50de8cabba055efe50bbcb7506c41a69835 upstream.

We should not be looking at ctx->rsrc_node and anyhow modifying the node
without holding uring_lock, grabbing references in such a way is not
safe either.

Cc: stable@vger.kernel.org
Fixes: 5106dd6e74ab6 ("io_uring: propagate issue_flags state down to file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1202ede2d7bb90136e3482b2b84aad9ed483e5d6.1680098433.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -143,15 +143,13 @@ static inline void io_req_set_rsrc_node(
 					unsigned int issue_flags)
 {
 	if (!req->rsrc_node) {
-		req->rsrc_node = ctx->rsrc_node;
+		io_ring_submit_lock(ctx, issue_flags);
 
-		if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-			lockdep_assert_held(&ctx->uring_lock);
+		lockdep_assert_held(&ctx->uring_lock);
 
-			io_charge_rsrc_node(ctx);
-		} else {
-			percpu_ref_get(&req->rsrc_node->refs);
-		}
+		req->rsrc_node = ctx->rsrc_node;
+		io_charge_rsrc_node(ctx);
+		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
 


