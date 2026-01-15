Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66419280327;
	Thu, 15 Jan 2026 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497544; cv=none; b=jOs7Eu1DU+O2fsKXcDd/D12UGFBs/Z1LDOF/vncGOLD6fDDoMReI8QlyKCmkDThujUajhAzNnl0IvLamnWnVU8JMYM5ez893i0iW8rtLrVNDrvZbxD7WDsWIrCNHfh6bDi7IsrrGLzysHhteC5UTyElsZ9cXojMQ+UxlqdUUWlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497544; c=relaxed/simple;
	bh=JQxVxRaKys3MbcvoCWY4Ilq6iuK1w1dLNAP1nhHcAwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKZE7Syu66QY7FD20GS13GnXsvcY+P9+HEhlAOh1K5vQnEiGQ/LNDQvWi2SGkeno7FT9fjJtVFZZH6rbZZ9oIsCjqpblVaT3oiE/DluuNtM2Xky/9gzqKXjCDjxXe53pgD6sRJl0p0raeN5HtbtajlVcrrO/dBKfyALSWfk6DiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uy48MkLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uy48MkLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9767DC116D0;
	Thu, 15 Jan 2026 17:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497544;
	bh=JQxVxRaKys3MbcvoCWY4Ilq6iuK1w1dLNAP1nhHcAwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uy48MkLYvtpHgs59Pph6+Sr9LZLXpvygHAwltk6otAUQmpm5YPYujtxbTPK42mu5S
	 NbmJbTMBw10SmBBT6q7aNEXsr4LYEJOBmA9wMpK20gqB2do3tK3EMzXPPyalYYzb9z
	 yT1aWb3wegYBMsxxWbjTLJTsmcn2VzgbiL4pvv04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3932ccb896e06f7414c9@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/554] fs/ntfs3: Prevent memory leaks in add sub record
Date: Thu, 15 Jan 2026 17:43:04 +0100
Message-ID: <20260115164250.522818695@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit ccc4e86d1c24260c18ae94541198c3711c140da6 ]

If a rb node with the same ino already exists in the rb tree, the newly
alloced mft_inode in ni_add_subrecord() will not have its memory cleaned
up, which leads to the memory leak issue reported by syzbot.

The best option to avoid this issue is to put the newly alloced mft node
when a rb node with the same ino already exists in the rb tree and return
the rb node found in the rb tree to the parent layer.

syzbot reported:
BUG: memory leak
unreferenced object 0xffff888110bef280 (size 128):
  backtrace (crc 126a088f):
    ni_add_subrecord+0x31/0x180 fs/ntfs3/frecord.c:317
    ntfs_look_free_mft+0xf0/0x790 fs/ntfs3/fsntfs.c:715

BUG: memory leak
unreferenced object 0xffff888109093400 (size 1024):
  backtrace (crc 7197c55e):
    mi_init+0x2b/0x50 fs/ntfs3/record.c:105
    mi_format_new+0x40/0x220 fs/ntfs3/record.c:422

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: syzbot+3932ccb896e06f7414c9@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 89ee218706678..62874e7f8d8f1 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -376,8 +376,10 @@ bool ni_add_subrecord(struct ntfs_inode *ni, CLST rno, struct mft_inode **mi)
 
 	mi_get_ref(&ni->mi, &m->mrec->parent_ref);
 
-	ni_add_mi(ni, m);
-	*mi = m;
+	*mi = ni_ins_mi(ni, &ni->mi_tree, m->rno, &m->node);
+	if (*mi != m)
+		mi_put(m);
+
 	return true;
 }
 
-- 
2.51.0



