Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F597145B1A;
	Thu, 11 Apr 2024 10:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831281; cv=none; b=EC34O9r4qS/bG0XV97yrCLztXaCHYnpOTSvU9gG8flJV/joKYcD+6M7hhjvyIaAr9kQd6U5vjBGYgC5MoQhant4LO4nl0epNnIiHEHjfaCyykvKFDsNxcyw3uu7zTOwXaS3qIt215AVmpD+WAxzt2cewri+q7OGz0jeyfuZOGbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831281; c=relaxed/simple;
	bh=eVARYfAQbhii3AYDkJGCN589Xw2NRLhAjDQODHI9N/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiHi+VfOs50GBgaAX7LUtvo/eug+SU5KDGjPdhNA3uMo/8tkmtepF0zdfhEUk4EPSvGSREy/Upk1R5SgtvAaBHGdfJ64fWPpoa29vZYsNOqL9ey+pdeUGQaKBiPkQn7h05w4vOWxbNQd4QeSwyzkwQZixL4e0DsvLLIoMumDbNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8iPAOsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8iPAOsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2597C433F1;
	Thu, 11 Apr 2024 10:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831281;
	bh=eVARYfAQbhii3AYDkJGCN589Xw2NRLhAjDQODHI9N/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8iPAOslfiAbAcM/p/ZYai8wsHt0M0TJRbJ+oe2nUlx9Mkdgji6INP/Fa8gfV3+hD
	 49nOchHGAwWHx6O7sUlsVgvXG/f2TiX+yWj8sNdWQJ5gC30GWBD7PHp3SHb+TJ1E08
	 r6MNn9KdXxbIRsq7s+S9GbYjOQYlCBIES/LSUeJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/114] ext4: add a hint for block bitmap corrupt state in mb_groups
Date: Thu, 11 Apr 2024 11:56:29 +0200
Message-ID: <20240411095418.758339846@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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
index 257b70c5ded45..a8a3ea2fd690f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3060,7 +3060,10 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
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



