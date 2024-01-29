Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3917415AAC4;
	Mon, 29 Jan 2024 17:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548381; cv=none; b=lCIYmvCQxjG6V8l5eu+1Xanl6Q6tGQ7KpSx9gId0DXSzCj1VOEEiNHb88ejjcB84cW91DNZTxurMk3AkNsRov0pogQjseIlugvctDER5Ai8DFmU9+6PfAH5Y8gH896jwHEISjjKpVdTsY4HdqyFcV2QUE27g24XSWFnT/fSjjac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548381; c=relaxed/simple;
	bh=Tbsx4bjFSlnL54UuKzbqRW5k0eJCkzy8FAc19DoSPbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9Qs0ofIlBkdKH++zUqm1u6oUdU5qA+/GmHjXi9ilezbEga/8A5189F+myTwmBOS3tfKLr3ZXc5XenC+IcC3nBfUPFsmVMYj2ClK+q4rRVN0GObPc2W2wqYd0oLWMrUdWlXiG28KuD+U+d90auV6hZPdM43Rx6Q9MPiZjdYeyCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEoxG80H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEoxG80H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009D1C433C7;
	Mon, 29 Jan 2024 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548381;
	bh=Tbsx4bjFSlnL54UuKzbqRW5k0eJCkzy8FAc19DoSPbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEoxG80HZPk6kfHLKfVFOFVgtcPuVJjOQ9mrRBQlSaIvEvDRY4SGun/V1uZzbyLKW
	 YvkpPi6OQGH2aHCYzZLWDlqYDiuRGqPAdNxPQ6dN68Aj28g4iI5PQY1xw1x3YCFzU1
	 8nDNvyDUA7y1eNimpneNJE6LyA8RXG0Pb14+LFaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Lukas Schauer <lukas@schauer.dev>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/185] pipe: wakeup wr_wait after setting max_usage
Date: Mon, 29 Jan 2024 09:05:52 -0800
Message-ID: <20240129170003.473522749@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Lukas Schauer <lukas@schauer.dev>

[ Upstream commit e95aada4cb93d42e25c30a0ef9eb2923d9711d4a ]

Commit c73be61cede5 ("pipe: Add general notification queue support") a
regression was introduced that would lock up resized pipes under certain
conditions. See the reproducer in [1].

The commit resizing the pipe ring size was moved to a different
function, doing that moved the wakeup for pipe->wr_wait before actually
raising pipe->max_usage. If a pipe was full before the resize occured it
would result in the wakeup never actually triggering pipe_write.

Set @max_usage and @nr_accounted before waking writers if this isn't a
watch queue.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=212295 [1]
Link: https://lore.kernel.org/r/20231201-orchideen-modewelt-e009de4562c6@brauner
Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Lukas Schauer <lukas@schauer.dev>
[Christian Brauner <brauner@kernel.org>: rewrite to account for watch queues]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pipe.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index e8082ffe5171..9873a6030df5 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1301,6 +1301,11 @@ int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
 	pipe->tail = tail;
 	pipe->head = head;
 
+	if (!pipe_has_watch_queue(pipe)) {
+		pipe->max_usage = nr_slots;
+		pipe->nr_accounted = nr_slots;
+	}
+
 	spin_unlock_irq(&pipe->rd_wait.lock);
 
 	/* This might have made more room for writers */
@@ -1352,8 +1357,6 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 	if (ret < 0)
 		goto out_revert_acct;
 
-	pipe->max_usage = nr_slots;
-	pipe->nr_accounted = nr_slots;
 	return pipe->max_usage * PAGE_SIZE;
 
 out_revert_acct:
-- 
2.43.0



