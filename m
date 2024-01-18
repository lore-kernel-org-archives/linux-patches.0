Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631BC22EF7;
	Thu, 18 Jan 2024 10:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575268; cv=none; b=Iq9kMDMr7d8WlP77YkwN2yEyuHcXiMA0+YCWnby3gCPxurACFqFQmja4EZzmwGJbcyqpRW7kjOXk4/nvnT51EFicVK9GTMg0FuQUrYF61kmtUoN9vIKSTPIJIJFSFc/3ee1Llop2+gdkZ8lKm+8v2Js+rtQgwajOB1lX+72m5XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575268; c=relaxed/simple;
	bh=PD16FJR6FoTRMcaj+bwfraLUfyozYEBfowL+TMfz3+w=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=Cg7l3nW3ZQWeBUgNg3VIwGqHzacibzulRFkGgdtccC2JulrFJelf2j5iPX4zp+RcnUs2Uvwh5DjDL9fneMf3oLOZs9uS4JBLU42SSqaKZUjb617VFg6eElJIw9UG+jbpa/SEZQk6FTcAca1RnzRdwj7x9Ah7QypvV/kRqGgKHaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuP7mzuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuP7mzuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEDDC433F1;
	Thu, 18 Jan 2024 10:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575268;
	bh=PD16FJR6FoTRMcaj+bwfraLUfyozYEBfowL+TMfz3+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuP7mzuUe5LgiGL18R2H57bd9vcPmEfF1UAszmCfk/DZzUeC/fUcJrvdygP/TraQb
	 MYj6Wrt15wPuR+yseV334P204pDl9KBSx8DvfsgH+MgRV/rc7ZVhjzSq3XLqNXzrBY
	 GvgttPpv6a2MhSuaobP8nGaQrfZaBZUhf+k38rOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/150] jbd2: correct the printing of write_flags in jbd2_write_superblock()
Date: Thu, 18 Jan 2024 11:48:14 +0100
Message-ID: <20240118104323.306521698@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 85559227211020b270728104c3b89918f7af27ac ]

The write_flags print in the trace of jbd2_write_superblock() is not
real, so move the modification before the trace.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231129114740.2686201-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 30dec2bd2ecc..e7aa47a02d4d 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1791,9 +1791,11 @@ static int jbd2_write_superblock(journal_t *journal, blk_opf_t write_flags)
 		return -EIO;
 	}
 
-	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
+
+	trace_jbd2_write_superblock(journal, write_flags);
+
 	if (buffer_write_io_error(bh)) {
 		/*
 		 * Oh, dear.  A previous attempt to write the journal
-- 
2.43.0



