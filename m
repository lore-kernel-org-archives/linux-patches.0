Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9F2157048;
	Mon, 29 Jan 2024 17:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548034; cv=none; b=TneBzpMnDAftgkZEYXWXYaqBxWqc5/5V//PDbueGUhc9HKzhUWyv7/0bAcNhkyCi6LljOdHEchfOtkTuRn4LDDPQ7rPSnt99cYpMKjXy6GXvvqu8DvQ5oXREUmnJghF8/P/o46tpM0FRgk7twRtxfJA2QnGX+x0eBU11mpUGn9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548034; c=relaxed/simple;
	bh=i7sHc9wSEu7QlR3VSFx67Kvvu7PBooPc9WFxy0SaHOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2uXfd6JNXWEj61E1iyDgMZoCtLUvY/Q7aE2+jM4qv0wdgp4x2O3BASgsdYhtRXMurGUQsQQNrRsdkW6Zcq5/A6s3bX7Mw3+IAcgzqgf115eZSzcbD2YZP0HiHaUx/4ucNMtvoERVT2ym3QvEW4sfcQG+4lqSAQiXgmVDzZHU2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iktEiFR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iktEiFR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C039EC433A6;
	Mon, 29 Jan 2024 17:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548033;
	bh=i7sHc9wSEu7QlR3VSFx67Kvvu7PBooPc9WFxy0SaHOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iktEiFR+heFrA/JSl/ixcpowv0TLnDhLTgFCELsL3vXeeIb5kbH48TGuO8yTG1NZV
	 WI56JJHm+nvCZTM7vgXZyiXyjiAfzgn26amYnKoTUz7JQg9aV3JoyB5tBHHjxI6E8V
	 3Gf4G7vTJg/86l+lMuTjffhY39Ub2fCcB9hPePDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Lukas Schauer <lukas@schauer.dev>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.7 005/346] pipe: wakeup wr_wait after setting max_usage
Date: Mon, 29 Jan 2024 09:00:36 -0800
Message-ID: <20240129170016.517171134@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Schauer <lukas@schauer.dev>

commit e95aada4cb93d42e25c30a0ef9eb2923d9711d4a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pipe.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1324,6 +1324,11 @@ int pipe_resize_ring(struct pipe_inode_i
 	pipe->tail = tail;
 	pipe->head = head;
 
+	if (!pipe_has_watch_queue(pipe)) {
+		pipe->max_usage = nr_slots;
+		pipe->nr_accounted = nr_slots;
+	}
+
 	spin_unlock_irq(&pipe->rd_wait.lock);
 
 	/* This might have made more room for writers */
@@ -1375,8 +1380,6 @@ static long pipe_set_size(struct pipe_in
 	if (ret < 0)
 		goto out_revert_acct;
 
-	pipe->max_usage = nr_slots;
-	pipe->nr_accounted = nr_slots;
 	return pipe->max_usage * PAGE_SIZE;
 
 out_revert_acct:


