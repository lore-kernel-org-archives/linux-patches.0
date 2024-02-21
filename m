Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A607A708;
	Wed, 21 Feb 2024 13:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522191; cv=none; b=Jzt9JHcrOMyLmPpf0POpBOtm9JtkooJS2lOJSmNq4ACsw8JbujhAVqLVPrBuouhPOfLMnMNr7U6mhadYV2LECyby13LHuDmfPOAVxAoUtBv3wo+WmxYQn+qFZ0p89w6zu8TfJBj+ZZPszt9FJDwefbq2QsVvjtUkXnIYc7w18ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522191; c=relaxed/simple;
	bh=qs+LWfG3z++eRK/FxAU/yLHTgeGw5leXmEdxxcc7Gas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkpU8MmE/gwJ7ODGOPRE2M7Hj8SyIUhQVkdXGVjHjmhPYvJ1zG7noVhhaO6rurc1b3UsC+0Dl+9g+mxbHKhr2WrtVQpjFy7gJV4bL8+PkRUzU6ztwjeIkDkqTqnvvitqcOINBEbv0lf2J2waeFiZqo9weWAO1MZc4ggMjSc/G6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtvLWh7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtvLWh7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED746C43390;
	Wed, 21 Feb 2024 13:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522191;
	bh=qs+LWfG3z++eRK/FxAU/yLHTgeGw5leXmEdxxcc7Gas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtvLWh7KzIlHFNAZ059cHlIrSS8ZPvEErcIoIgWp9KshJZ/WzsDCWocFCKai/CAlh
	 h36Y/Ea8GTvPh4PFN4DWFgxp74Bdw2Yo4QAnNcnVK1c/pCFEALLPf1xsYGPTzewC1p
	 m7AbdRFo171rv8TAw7bEFgSZ0xym5doyzn40/lyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Lukas Schauer <lukas@schauer.dev>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/476] pipe: wakeup wr_wait after setting max_usage
Date: Wed, 21 Feb 2024 14:02:31 +0100
Message-ID: <20240221130011.680454310@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1a43948c0c36..a8b8ef2dae7b 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1300,6 +1300,11 @@ int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
 	pipe->tail = tail;
 	pipe->head = head;
 
+	if (!pipe_has_watch_queue(pipe)) {
+		pipe->max_usage = nr_slots;
+		pipe->nr_accounted = nr_slots;
+	}
+
 	spin_unlock_irq(&pipe->rd_wait.lock);
 
 	/* This might have made more room for writers */
@@ -1351,8 +1356,6 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 	if (ret < 0)
 		goto out_revert_acct;
 
-	pipe->max_usage = nr_slots;
-	pipe->nr_accounted = nr_slots;
 	return pipe->max_usage * PAGE_SIZE;
 
 out_revert_acct:
-- 
2.43.0



