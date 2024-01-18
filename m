Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FF924B5F;
	Thu, 18 Jan 2024 11:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575613; cv=none; b=JSKUDhwxtvOkzT3/4p7oFlP1JehPbEVdjuYsnFior+snfWXS7lObXHZAFXEh8C79879yc2bxYVc3eHnRCxcx7SIedjKaz+lyUd/rl5ztlS7f3yqmH6zd8lWG+ZuX53AZc55nrX0am/tk3HckOakLETgkBdLC9zEQSg0pTAo/QXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575613; c=relaxed/simple;
	bh=mJF92q/mRy0Sw5S8dXPGrtJbG4dNjjkbyH6GqVCXzDg=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=aL7ZO9F7WQW5x/t/FzCGvGk83y6WdeuJitsZnIDWUyuku1wk1EurPsL2318uUG12iHmEe0HU5klaYJzv7mGTyOR4miyymK9aFH1CwtCnAUAd4eXmjgYuKsn/eE3HNdXw+AaXJTpvoxBNLBRLKVffRzgbrqjjxz0xxLkUIUKAORI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WljIQNwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WljIQNwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66120C43390;
	Thu, 18 Jan 2024 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575612;
	bh=mJF92q/mRy0Sw5S8dXPGrtJbG4dNjjkbyH6GqVCXzDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WljIQNwmoh8917uv8CspKfHW9guJdWWlv1GPAB/GCllrq9LwwcJ7FQQX0WAEIAMxJ
	 lEV4b6rC6wH5HXFKPhe5s4R3R7mRk0cR5c1+nnqZWM8hcdZ1PCceEp19sxu9vCtG6b
	 5pL+IgGhZbnyoEHGqAIjhYgAN1S/DMbsoLbOZubQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/100] jbd2: correct the printing of write_flags in jbd2_write_superblock()
Date: Thu, 18 Jan 2024 11:48:52 +0100
Message-ID: <20240118104312.818658981@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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
index 2696f43e7239..611337b0b5ad 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1620,9 +1620,11 @@ static int jbd2_write_superblock(journal_t *journal, blk_opf_t write_flags)
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



