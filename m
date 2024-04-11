Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B5F1E48E;
	Thu, 11 Apr 2024 10:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832619; cv=none; b=r3rL3DoiZEaOkDufzvJpeLrXr5YeBq0rqhZnvejqp2rJtWRKFzKtNBg6QX+IrI3npthjHZzjRIk6F8huEsb+DGOcILjPKDjq3YFwXg6Ta87Xv7611tlV6iosRUl43vb019hVNMw3Tx1IxygGh3HczNqgi3nMfpP3c+353/3I7W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832619; c=relaxed/simple;
	bh=7JXnnl8hh1r7ePjHsK+zX2q9gc2qbp/UDV/skSD7NmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5ge7DqkZ2XjNHUqLH420KcYyfti1t0iVJqblPFmzZgYdNWwSGCX9jUB7k3k7oA/P1c9NVK12BWva9X+bS6MWOKhicQYZkgmn3kSY93nibQLax3sbIOXAWb6V1/ZqFf/pMJy+6NhZWC9VnGNmv9l+xQmy7NhBWL+vIhTuhxWNI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVDvakcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVDvakcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A51CC43330;
	Thu, 11 Apr 2024 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832619;
	bh=7JXnnl8hh1r7ePjHsK+zX2q9gc2qbp/UDV/skSD7NmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVDvakcjX7aCH6QCp5ItR1QXkXTsGRz0KKrKRg9jesJrBdzXLyQU3SGsPYmdLAbGP
	 xq/q71WMFqweh1U8yntq2DNcK26u6yB0LDMw/kDWLnsiWzXzAVTfrLTq8Gkvn3gZB0
	 kHYX/o64jdt0y9HY1moChIyKCeme6DcgqyHfa+sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/57] ext4: add a hint for block bitmap corrupt state in mb_groups
Date: Thu, 11 Apr 2024 11:57:35 +0200
Message-ID: <20240411095408.816557396@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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
index d13d669f90fd5..8dba416aa6c1e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2950,7 +2950,10 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
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



