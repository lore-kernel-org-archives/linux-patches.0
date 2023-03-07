Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9494CBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089ACC4339B;
	Tue,  7 Mar 2023 17:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210802;
	bh=LeQHH3A/YVVZ58VA0ghtE+gGqnsXTxc4CFRT2Hs5Ukw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gcyqtS6qNaq4Ip3pLV2Ye3RiQF8tU1VewsXO8Fmb8o3xzeYFn7Me2+IceGyfCNeE
	 IFilnnxYxR2TZ5ZID6ficdj6JY74o0YGuziXn4PzRVcJPJr7LuCG4UpCV+S74VHGQq
	 v/hue8EpI2Yr7mFo9JsmjXvYBPeUOOFT5KCXseB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0628/1001] trace/blktrace: fix memory leak with using debugfs_lookup()
Date: Tue,  7 Mar 2023 17:56:40 +0100
Message-Id: <20230307170048.806712929@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 83e8864fee26f63a7435e941b7c36a20fd6fe93e ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230202141956.2299521-1-gregkh@linuxfoundation.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 918a7d12df8ff..5743be5594153 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -320,8 +320,8 @@ static void blk_trace_free(struct request_queue *q, struct blk_trace *bt)
 	 * under 'q->debugfs_dir', thus lookup and remove them.
 	 */
 	if (!bt->dir) {
-		debugfs_remove(debugfs_lookup("dropped", q->debugfs_dir));
-		debugfs_remove(debugfs_lookup("msg", q->debugfs_dir));
+		debugfs_lookup_and_remove("dropped", q->debugfs_dir);
+		debugfs_lookup_and_remove("msg", q->debugfs_dir);
 	} else {
 		debugfs_remove(bt->dir);
 	}
-- 
2.39.2



