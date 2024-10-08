Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8601CCB32;
	Tue,  8 Oct 2024 12:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390808; cv=none; b=NY0p78fLewCUGVofRlZSrBxBmdVHRDry4sw3MDZ6k8dQE2GPDBzMFSzb7lGC9qEfeUytEIsT5hapRJgQJEb/jb3bDQAshMVhoeT9gZSZ7ZIkVS2sg71s3jDyIZ4JHAK4hhedqhB6VdfrVmcfyY5C1JuOkK7AyBFKxlIrwNwxWTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390808; c=relaxed/simple;
	bh=7hiKeLaEmWKIQtwn/0OYgGmU+Fh1Svk5X1QtqwH4F6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLQkcL6W6/Irn1/or89lTIU1qHNFM9QyZxr4Woz9pTaNFMTEGZTK2ZH8KyzbjU2oPIXJ9Ex4GDUCJFhzKlpz1+svGBgmHYOkZAGW9hMYgBpDRuPKu/IyPXV4XMwmR768cIvu+RtJtbo0aiI55W6TyvvSFoQ5IWDCZwUMcyJDdZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7gReDi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7gReDi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1B0C4CEC7;
	Tue,  8 Oct 2024 12:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390808;
	bh=7hiKeLaEmWKIQtwn/0OYgGmU+Fh1Svk5X1QtqwH4F6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7gReDi2kBhIzOhvRCAJhggTHUKXwLPFuN4/cgE+Z13Xg9lKpo0Yl2Ccx1H00aS/c
	 rr54zCS9G/5G2WqKqDO5B31LLLJ+O8lDXh8eYlmUISLuKUvQqxbGwNFZ83tloY7kdL
	 YA82Kgehni+dpI26X5xquc4Tpi89ZdDjNihZjxWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 358/482] ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
Date: Tue,  8 Oct 2024 14:07:01 +0200
Message-ID: <20241008115702.509915220@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

commit 33b525cef4cff49e216e4133cc48452e11c0391e upstream.

When doing cleanup, if flags without OCFS2_BH_READAHEAD, it may trigger
NULL pointer dereference in the following ocfs2_set_buffer_uptodate() if
bh is NULL.

Link: https://lkml.kernel.org/r/20240902023636.1843422-3-joseph.qi@linux.alibaba.com
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/buffer_head_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -388,7 +388,8 @@ read_failure:
 		/* Always set the buffer in the cache, even if it was
 		 * a forced read, or read-ahead which hasn't yet
 		 * completed. */
-		ocfs2_set_buffer_uptodate(ci, bh);
+		if (bh)
+			ocfs2_set_buffer_uptodate(ci, bh);
 	}
 	ocfs2_metadata_cache_io_unlock(ci);
 


