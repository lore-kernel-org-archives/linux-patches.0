Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE65157A55;
	Tue, 23 Jul 2024 18:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759931; cv=none; b=mybsPniq1YJ+NbpBIA5lovIhbyD0SbBJUEZwhQDSPb4Kl4XD7j+1XFsNnqqB/HNcCYwKEAlZmYw5uglahsHCRfkkCP3cdv/6Az9u/HoaVB8+mX4r0cUd8BkbGRiG71qgMC+49DmMCpqdT+3cQkweaNKGp6W9hDkae8PnnZt7PIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759931; c=relaxed/simple;
	bh=J02oy/M3QEA5u5KbUvdonxw6kRaITUNO7B7pnFLxjKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwmHzORZT9hUr+w0c2J2WLDJa1aTCRQ4n0iJLwk2L+JGhHO6jZ4pkfWJgCM/fl2BsKCyLRVTq+dSIO3o/T877hz2rohyjeAenp7P8qe6hs+jdxdaZ89lX7opitpAar4Y/OaspGQ9yuduFfR2VqcwsUIrbSoNi8vpm+mCTiFywHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+ys9Z8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+ys9Z8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43908C4AF0A;
	Tue, 23 Jul 2024 18:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759931;
	bh=J02oy/M3QEA5u5KbUvdonxw6kRaITUNO7B7pnFLxjKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+ys9Z8pLLlXv7sPBAbREm8+ONf/l2HMCbVC+4oOJQpmR0nHAqLxYW74WJ4osBoJW
	 xS/sRoikj8L8nNEivhbrrAwQLduhABQ+593Qb6ilOYhHhvke02zkTWtDzhF+G8hnuf
	 cAK3Czv5kj2heHLE+T2eQtKURvLCidWVWYdddMQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 047/163] nfs: Avoid flushing many pages with NFS_FILE_SYNC
Date: Tue, 23 Jul 2024 20:22:56 +0200
Message-ID: <20240723180145.289432135@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit a527c3ba41c4c61e2069bfce4091e5515f06a8dd ]

When we are doing WB_SYNC_ALL writeback, nfs submits write requests with
NFS_FILE_SYNC flag to the server (which then generally treats it as an
O_SYNC write). This helps to reduce latency for single requests but when
submitting more requests, additional fsyncs on the server side hurt
latency. NFS generally avoids this additional overhead by not setting
NFS_FILE_SYNC if desc->pg_moreio is set.

However this logic doesn't always work. When we do random 4k writes to a huge
file and then call fsync(2), each page writeback is going to be sent with
NFS_FILE_SYNC because after preparing one page for writeback, we start writing
back next, nfs_do_writepage() will call nfs_pageio_cond_complete() which finds
the page is not contiguous with previously prepared IO and submits is *without*
setting desc->pg_moreio.  Hence NFS_FILE_SYNC is used resulting in poor
performance.

Fix the problem by setting desc->pg_moreio in nfs_pageio_cond_complete() before
submitting outstanding IO. This improves throughput of
fsync-after-random-writes on my test SSD from ~70MB/s to ~250MB/s.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pagelist.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 6efb5068c116e..040b6b79c75e5 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -1545,6 +1545,11 @@ void nfs_pageio_cond_complete(struct nfs_pageio_descriptor *desc, pgoff_t index)
 					continue;
 			} else if (index == prev->wb_index + 1)
 				continue;
+			/*
+			 * We will submit more requests after these. Indicate
+			 * this to the underlying layers.
+			 */
+			desc->pg_moreio = 1;
 			nfs_pageio_complete(desc);
 			break;
 		}
-- 
2.43.0



