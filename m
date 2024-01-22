Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D4860252;
	Tue, 23 Jan 2024 00:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970872; cv=none; b=g5KspelnHfaGt/dD3ZHpBi46b7maLh30Fs6KZF09UT7a8QqkV+wHvI0/mKmbwisAsWkU7tYK7VJxdViNCfYFN7tw3F83MZ0g8rv6KPvkbDOReMK8Zdx/U4JqC6EQ/OuEaSZzrCH0uLvOrD8N9WF1b6bhzkSMPqZ0AeWgIJZXcIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970872; c=relaxed/simple;
	bh=32FVLNSflBK19pwYKX0xf5TXlB32Q3BJkWl6PK6TZmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt0picLmfAA4hhVkLPCb1XsoRc5o3xd/2n+2wCb6A58zocTPk7a9dLH4Hanb39dnm8dA2K04GS4aGRvgPJDPnr6O4gtuGeLgzsTfHWlCAqLofJ44S3MOKjlKpjrwPldb/nU1TGpYkGpnq/Lb2x0miiyeDEFt4yA/VkRunMiy8jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0LZCrpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0LZCrpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B84C433C7;
	Tue, 23 Jan 2024 00:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970872;
	bh=32FVLNSflBK19pwYKX0xf5TXlB32Q3BJkWl6PK6TZmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0LZCrpx3mISU4hmTMkmsvJ3/LVHrZTCclIMnHk3ghuyV399CpI6eRmFmcu1zm2Bp
	 D7cBAFOcUmvJMk41Uv1BjR0bpOgaLGu8qlwk9lKBZtv0BupvIai8rxEvWNadEiQQF2
	 5woZKmxXcDFCZksNAvMkh4Q+rl04QRtQg1kw2QBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/286] jbd2: correct the printing of write_flags in jbd2_write_superblock()
Date: Mon, 22 Jan 2024 15:55:28 -0800
Message-ID: <20240122235732.878853464@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fee325d62bfd..effd837b8c1f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1568,9 +1568,11 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
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



