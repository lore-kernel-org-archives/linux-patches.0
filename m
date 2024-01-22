Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F1A130E3B;
	Tue, 23 Jan 2024 00:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968096; cv=none; b=IPYP/ug/g0MBUpVgcvcLWybqrif576Fs9LnozSUCH1FGE1fBRWnNLNWZM5C/sNWtw3zy8BQdF9PplzX3aw4qK7VaCjUtKT2DizFG/tU2DkncHycLCmjSyu5MfBhg9cwAKP3DOdZlizaNP0lu4Hx5WBgfOxT//fRQoBFZEKrZLFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968096; c=relaxed/simple;
	bh=rWaXDadMo6bzkcy7PvTqT5GNXlgohuENfoIRi5Jvra0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXB7CF/7Z/RfZ+twMT0UfGhybxmwW9AXAoP6ViH69isxuSLri/Tik/Bq5WSsKnIAj3sPerlTi04oQcIvButPih+NSoHFspDjHu74T7D3aj+HDx/0iDgcx52LmUrckRGvEZ4Y5QUcnb5g61y5RhPH4wvP/5uw9uBQOzt8A50qMNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqBbLuXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqBbLuXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E2DC433F1;
	Tue, 23 Jan 2024 00:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968095;
	bh=rWaXDadMo6bzkcy7PvTqT5GNXlgohuENfoIRi5Jvra0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqBbLuXff5qGxdWZpS/M5E19TIk6guQcQHVwoZb28F1IM0NUxbB4VR1xHF2ox4E/O
	 A5+k8tXrDi09BD+O8kRJ7g78XYh3aLU4A6bNm2nr+GPJcjJgtc2KzuzWuY0eyWCez4
	 x2z80PaKyJ1m8/JvXwE57tKSpjMheEoPW+rAvp0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/148] jbd2: correct the printing of write_flags in jbd2_write_superblock()
Date: Mon, 22 Jan 2024 15:56:06 -0800
Message-ID: <20240122235712.848182261@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8a50722bca29..629928b19e48 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1375,9 +1375,11 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
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



