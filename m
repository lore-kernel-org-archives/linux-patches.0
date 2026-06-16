Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899E843D4E9;
	Tue, 16 Jun 2026 17:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629477; cv=none; b=YDnjjT+Y1KvGv40spRV12yVr9VfsONQauvRyz7crlboo/XNYJLSk0rQ/UPfQq3jxEWWCvUwGIEBbVwRkaqGCbCnxkbbdcouf8/CYD8XbS2YZwEctzMkH1bzs9pYGg4t8K2TBPmkFvJL5/uVb6ZK2Tq82h2FICB5KrVvv23ttl48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629477; c=relaxed/simple;
	bh=r6rUNuOS2PVcKs/babf8pHQYub6DUj/dbkkPaGRKI70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2WsU5RTQgwh7J+E0BoXkWKoVJnzAvZH8kmFvvmp1kB3nq1PsuR6etwMdNCEMIFsJMLytyQXhqfdx7S9LWT21tc2dtuOH22EtW7ALfRk8W+8vuyLUBHgT0dvX9uecg/iD35ayVZLs70W5dlViW23qPwSPxShJK/GJ5kpXUQs+RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBNrGNZT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBNrGNZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906F31F000E9;
	Tue, 16 Jun 2026 17:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629476;
	bh=KWaALYKuMAdZRoRXi8ooIUdxqNLor/It75yeScZCYLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBNrGNZTUURGPuhsNITndNVEFq9vKYpVyN3NLYlqusay4s9rpTOaSZmjxa1g7rvtw
	 p8SIfB6PsT2z5oeo6nmgGUQxapVb8EFprzvJDe5E/a+kmxsAHavfCK1lEsjfpjzZ4x
	 G1MACEyYMgOWvlRP/oZdLGfEZc8ZJAJtDb5iufDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregg Leventhal <gleventhal@janestreet.com>,
	Eric Hagberg <ehagberg@janestreet.com>,
	Brian Foster <bfoster@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/452] iomap: dont revert iov_iter on partially completed buffered writes
Date: Tue, 16 Jun 2026 20:28:06 +0530
Message-ID: <20260616145131.226590444@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

Gregg reports that the iomap retry behavior for nonblocking (nowait)
append writes is broken. The problem occurs when an append write is
first submitted in non-blocking mode (i.e. via io_uring), partially
completes before hitting -EAGAIN, and then is resubmitted from
blocking context.

The specific problem is that at least one iteration of the loop in
iomap_write_iter() completes in non-blocking context and thus has
bumped i_size. The next iteration hits -EAGAIN, reverts the iov_iter
and returns. io_uring retries the entire append write from blocking
context, but since i_size has already been increased, the data that
was partially written on the first attempt is rewritten at the new
i_size. This is essentially an intra-write data corruption since the
data written to the file does not reflect the write from userspace.

This problem is already fixed on master as of commit 1a1a3b574b97
("iomap: advance the iter directly on buffered writes"). That commit
was primarily intended to clean up iomap iter state tracking, but it
also happened to remove the iov_iter revert and thus accidentally
fix this problem as well. Without the revert, iomap will commit
partial progress internally and loop once more before it more than
likely hits -EAGAIN and returns partial progress consistent with the
inode updates. This means the blocking retry from io_uring will pick
up where the first attempt left off at the current i_size and
perform the remainder of the write correctly.

Cc: <stable@vger.kernel.org>
Fixes: 18e419f6e80a ("iomap: Return -EAGAIN from iomap_write_iter()")
Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
Reported-by: Eric Hagberg <ehagberg@janestreet.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index c5d439f8e2254e..4bc57934aa52df 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -974,10 +974,6 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		}
 	} while (iov_iter_count(i) && length);
 
-	if (status == -EAGAIN) {
-		iov_iter_revert(i, written);
-		return -EAGAIN;
-	}
 	return written ? written : status;
 }
 
-- 
2.53.0



