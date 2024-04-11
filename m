Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5209D134CC2;
	Thu, 11 Apr 2024 10:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832207; cv=none; b=NIrX145xWBVCue92WdgCVg1gjgHDS1D9Sa4gyLEpO1X1z519efQeSZzny19pqDcyOhcP+RS7T9LvleVo7Gvc8mbmx7s0tN9WKpI/LRIxpuS+hAIkIscMi3AF3DbJm7D7AdrpLorkHbXkuI2ZIAx3XQo9E25D+g4mu57qnzJL3IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832207; c=relaxed/simple;
	bh=NMGXe5D8d0ppPz4jpZcLFzL7nsj2N27quu/lDGUxm2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M14bXuVKbJzOcpSgm8jrAJ8UpqCShlP1sJYc4ODfVYHBdGH3lwqxIhyrPkg6vVPVg6p6fT1/n0PJ8M+3D/OqX2mp8g8lIGdguMkgHpn2robdXqUDju4G+9PJlSU0sfTwS2kHnmqdGeLhJvBnsGcPaszTfom08jzRb1ywfO2koeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6+2pxro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6+2pxro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F12C43394;
	Thu, 11 Apr 2024 10:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832206;
	bh=NMGXe5D8d0ppPz4jpZcLFzL7nsj2N27quu/lDGUxm2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6+2pxro+Aaq2RqMEuPRsgCtSbH8MFQG2TyMrZ+PbgdKSMOgqi5HsXswHA3qnU1gt
	 U+80xaJe6iTNwP5wpehbRgL+VrqToma1D3H4xyHufLM/ceN/AxBTw1CH/dikHrxemQ
	 85rSDYVRQTkIT9v2ycx5I8OmzeO64He3bVKMPsB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 264/294] ext4: add a hint for block bitmap corrupt state in mb_groups
Date: Thu, 11 Apr 2024 11:57:07 +0200
Message-ID: <20240411095443.504842704@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

[ Upstream commit 68ee261fb15457ecb17e3683cb4e6a4792ca5b71 ]

If one group is marked as block bitmap corrupted, its free blocks cannot
be used and its free count is also deducted from the global
sbi->s_freeclusters_counter. User might be confused about the absent
free space because we can't query the information about corrupted block
groups except unreliable error messages in syslog. So add a hint to show
block bitmap corrupted groups in mb_groups.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240119061154.1525781-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6ce59e2ac2d47..c1d632725c2c0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2591,7 +2591,10 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 	for (i = 0; i <= 13; i++)
 		seq_printf(seq, " %-5u", i <= blocksize_bits + 1 ?
 				sg.info.bb_counters[i] : 0);
-	seq_puts(seq, " ]\n");
+	seq_puts(seq, " ]");
+	if (EXT4_MB_GRP_BBITMAP_CORRUPT(&sg.info))
+		seq_puts(seq, " Block bitmap corrupted!");
+	seq_puts(seq, "\n");
 
 	return 0;
 }
-- 
2.43.0



