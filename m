Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AFD135A6D;
	Tue, 23 Jan 2024 01:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972116; cv=none; b=auzcMCWG0hcKrad4F0DQhDEMiT7O/kJs6P1DIpe1+iJ8diJUpcDFSCoa0l2LKisBg36wXPegXXGc3o0oNwjGCg/a1PpMlG9RO+JGQxTE+HzcTDkp8DDVsxQrerFs3n/3d+Mof+g4MrDSI8ZsHenBI/KkPg7xRTMqkX1aDeX1+Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972116; c=relaxed/simple;
	bh=+v/yGSuGCAuTWo1/YpyhOmhgo1BMtyNAr/NecI4Ld2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeYOQCMBY3AIVmiPa3NEiGT5D/zRIdKuBr6R2v6SjdT4lqLTj2ut1/kE7sJSZ5QYpJXseCFoqgqIJWoWxh2VPoVYsC0RedirEGDWpCRCeTRLT64oA77OBcZr9+BYAsl8aeIp5j89m65lQjNMvGxGU2UFuH3Le0l4S8gi17hWg7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzruWbVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzruWbVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04F3C43399;
	Tue, 23 Jan 2024 01:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972116;
	bh=+v/yGSuGCAuTWo1/YpyhOmhgo1BMtyNAr/NecI4Ld2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzruWbVoe/n9saGzPsWPm7PyzkNpfEV0TqcmvSn5jCCslOn4FKJEflxpS68fAr7un
	 Glh8BYT25mERxRIwuxSN6+St9py5VEICuD5lpTKdO33/JIILuDYn29QKUapMEkPVYc
	 oWtr7mPs8o605yGKg6czVeenIQqR8vVPD+f0svPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/374] jbd2: correct the printing of write_flags in jbd2_write_superblock()
Date: Mon, 22 Jan 2024 15:54:42 -0800
Message-ID: <20240122235745.545191398@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index 11fbc9b6ec5c..b7af1727a016 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1616,9 +1616,11 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
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



