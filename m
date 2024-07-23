Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38BA42067;
	Tue, 23 Jul 2024 18:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759518; cv=none; b=UIDbPlMUtINN0VqrT+KyDnr8BCdy196tRNaAqM4iGYNeouYr/mP8v+SoRhh0ov8xuLU5r21IrF7lNDL42JE8LnZTrIQXlKJJRxFLMbqIccDZ9dfYYT4tAvvrWLD8KpdMotVCZKQqJEYeKw6YokA/t9kKUS6joocxRzAc0EJhcIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759518; c=relaxed/simple;
	bh=/a9DLCo0WcWIr3M4XIq7yyVqOQY+F2RTukaz21+uIDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5XQw9ER4vescUWFXLi3efkZtmipWW6b9UA3WpmRm9Qs9NX01Yg2ksGLq+iBO1F9O8xZRFxzkgBAWLMCHTp7S1RY0TK6nk5OxKNpYsavj8T2PK7dLQDWeHb0eQJkU7DMyXza9dpPpAL3qmp/9t+TRRoYXI71zaFvFEZTVXrI/ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxR6g5ab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxR6g5ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395B7C4AF09;
	Tue, 23 Jul 2024 18:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759518;
	bh=/a9DLCo0WcWIr3M4XIq7yyVqOQY+F2RTukaz21+uIDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxR6g5abT1yMCpqnsGnFqrDimFiIknfmmenr3I/iZP6kSsHPoQ3Oi5BtATI7UFvqk
	 WPH0vFdLi0Pr9IGiuTviyq6ej1tvqIxsCkmm3SyaYgJeyJW0drdyqpIIInTraPSOiI
	 1jDGOIiXIAO9Bdcf2DNmWLSaOZNy5tJIbahCesME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/129] nfs: Avoid flushing many pages with NFS_FILE_SYNC
Date: Tue, 23 Jul 2024 20:23:06 +0200
Message-ID: <20240723180406.261727331@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



