Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FC3171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85753C433EF;
	Mon,  8 May 2023 11:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545974;
	bh=blUy9C1Tt+dysK/2ZSW197bQ/v2Ol0kLFgl9O0itrHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGlTPXMW//M4lMsPkQJnG6c7KtFXSDo3I3IAUY02MX+EKKu17VrUXrzEeM+NOTLto
	 soIpOYQy1/GYsCGeHjJii6EEaftIgCtL1LgrhA8X5LE6VwhNk7Al6mZDb0TlvoM+l8
	 NdCdoI4lWf8+v91C5QnnlYZQu+4DXFTTJOGgH57U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/371] jdb2: Dont refuse invalidation of already invalidated buffers
Date: Mon,  8 May 2023 11:46:56 +0200
Message-Id: <20230508094820.600063375@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit bd159398a2d2234de07d310132865706964aaaa7 ]

When invalidating buffers under the partial tail page,
jbd2_journal_invalidate_folio() returns -EBUSY if the buffer is part of
the committing transaction as we cannot safely modify buffer state.
However if the buffer is already invalidated (due to previous
invalidation attempts from ext4_wait_for_tail_page_commit()), there's
nothing to do and there's no point in returning -EBUSY. This fixes
occasional warnings from ext4_journalled_invalidate_folio() triggered by
generic/051 fstest when blocksize < pagesize.

Fixes: 53e872681fed ("ext4: fix deadlock in journal_unmap_buffer()")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230329154950.19720-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/transaction.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 55232064cab21..ce4a5ccadeff4 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2378,6 +2378,9 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 			spin_unlock(&jh->b_state_lock);
 			write_unlock(&journal->j_state_lock);
 			jbd2_journal_put_journal_head(jh);
+			/* Already zapped buffer? Nothing to do... */
+			if (!bh->b_bdev)
+				return 0;
 			return -EBUSY;
 		}
 		/*
-- 
2.39.2



