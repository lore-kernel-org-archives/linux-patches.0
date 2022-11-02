Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D347E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF87C433D6;
	Wed,  2 Nov 2022 02:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356677;
	bh=nbCUjuha6icmp6jA4yrHzhXRYbin0B7XAwpCSVTS+og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozww3ZP4c+H0PePl+XHNQc6wJvGmduklpiI6TgTwmHp0/cDXWtwdlLgLAqz42GBDo
	 NJdifebIOyLBX+yRQtEbJjeyu/goyqZAvkK93lEfCTG6FPgnwGXypqVgKpXiPczO3Y
	 PhSsL230tqWCpJs46AEnFrvCU9l1VBaqcKnkVHuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Marc Miltenberger <marcmiltenberger@gmail.com>,
	Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Slade Watkins <srw@sladewatkins.net>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 041/240] squashfs: fix buffer release race condition in readahead code
Date: Wed,  2 Nov 2022 03:30:16 +0100
Message-Id: <20221102022112.331394720@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Phillip Lougher <phillip@squashfs.org.uk>

commit e11c4e088be4c39d17f304fcf331670891905f42 upstream.

Fix a buffer release race condition, where the error value was used after
release.

Link: https://lkml.kernel.org/r/20221020223616.7571-4-phillip@squashfs.org.uk
Fixes: b09a7a036d20 ("squashfs: support reading fragments in readahead call")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reported-by: Marc Miltenberger <marcmiltenberger@gmail.com>
Cc: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Slade Watkins <srw@sladewatkins.net>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index f0afd4d6fd30..8ba8c4c50770 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -506,8 +506,9 @@ static int squashfs_readahead_fragment(struct page **page,
 		squashfs_i(inode)->fragment_size);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	unsigned int n, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
+	int error = buffer->error;
 
-	if (buffer->error)
+	if (error)
 		goto out;
 
 	expected += squashfs_i(inode)->fragment_offset;
@@ -529,7 +530,7 @@ static int squashfs_readahead_fragment(struct page **page,
 
 out:
 	squashfs_cache_put(buffer);
-	return buffer->error;
+	return error;
 }
 
 static void squashfs_readahead(struct readahead_control *ractl)
-- 
2.38.1



