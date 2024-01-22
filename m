Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEBE129A99;
	Tue, 23 Jan 2024 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968726; cv=none; b=ZijHOLmNOuc0VSkqPCv3j1qjjeGhMnt+jwQT6usgcjyjUvEGH11EeTvJbwMmC4wTg5Z2mk8FnlihoLImwWBJ4Ogoddqe6QSML4JnSxgElCfpdBttcfSENy5vwWOUO5aWbcFgKDWsp9NVx+5a3Shp6qxDOmB681EsHGAhikozq7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968726; c=relaxed/simple;
	bh=GDOrNxZxxUXN2ybFeZ3+lc3Qn8e6XEvIhn5eLIPlLiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJLGtDuT07XPQhlI9pr6pfDOtEqPGzdHG9U/azsC8S9oIqi35Lxc0P1ec+K26GtI0zaw5cUKLHZ9mqAhAJLGTKjvYrBRfKZVXVZy+K4e4pT+mPkcXeweyzzlhKjqad7smRBobU4qzfHnsCJZjdVMxeFoEKbtB4Yzhw0LeDInCwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5f6kAt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5f6kAt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0B5C433F1;
	Tue, 23 Jan 2024 00:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968726;
	bh=GDOrNxZxxUXN2ybFeZ3+lc3Qn8e6XEvIhn5eLIPlLiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5f6kAt4gjWqLXmMI4/QNBXxfA2ds/1ChVex14eD6Ud6iUcQgm2H1STftLMbkL43k
	 58vXPfAvWi5u3yILhcWdmTYcVneSPstU6iAy9JMULuIywp8fwXi89SV5dfWeK0yLw5
	 Gp/G7LpQnIOMQwVhYWOxhEnYue5xOo1XDe1gRxj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/194] jbd2: correct the printing of write_flags in jbd2_write_superblock()
Date: Mon, 22 Jan 2024 15:55:47 -0800
Message-ID: <20240122235719.950247434@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index eeebe64b7c54..81bd7b29a10b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1355,9 +1355,11 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
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



