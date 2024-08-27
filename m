Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73EA17C96;
	Tue, 27 Aug 2024 15:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771901; cv=none; b=CWVcaqW0DT4QRvbySTo5BUV1RRZr/qdkPM2sO8a+R4Z+i0TcuBLmWLa84Fs6Ny8PAIukxqP64AIcu+jR3rAVxdNxdwDWopPb2elmR2HMFfKpd9hZGfgUEuH1/RClvuBuqJirrpplT7DqS3xB8wPmP9x2e8zud3ymOtWEcKp0ucE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771901; c=relaxed/simple;
	bh=0PsNdS8ySdwRu7F5uBCLs48Qc2e+uDFkNRAwQUwumtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZEcKwwnuUOLMr6QFmhp8xATxjyP7GXEfBpxoxe6xqTs8trLmS2Ajlzq1poUICcTtD0EPNebTQLg7IBJ8G+oH3JSXJ3fXqup9jGX8hw3ncaHgZmqOW4EmZDbnZdAr8cZljKaJj26koKv6oURcwwX0ZHXSdht3/9CYm/7QRtEgyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4it8JR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4it8JR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF43C61067;
	Tue, 27 Aug 2024 15:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771901;
	bh=0PsNdS8ySdwRu7F5uBCLs48Qc2e+uDFkNRAwQUwumtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4it8JR/Jqi2hrLlg7a++dZr62ekKBvkP7c9tyq1KNXZ0tAkk/s+MP/mHCs4a7J6g
	 XhJ2b6FyxmdefIBUe+08Mmgw0fBdw/O9wM/h40oi/HT9NcDldIr+Gq/EYnkTojHoUf
	 t7/byr8zHQZrqBeThEnqUFm/YakpKSabGdEPgu80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32d3767580a1ea339a81@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/321] squashfs: squashfs_read_data need to check if the length is 0
Date: Tue, 27 Aug 2024 16:36:02 +0200
Message-ID: <20240827143840.291699459@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit eb66b8abae98f869c224f7c852b685ae02144564 ]

When the length passed in is 0, the pagemap_scan_test_walk() caller should
bail.  This error causes at least a WARN_ON().

Link: https://lkml.kernel.org/r/20231116031352.40853-1-lizhi.xu@windriver.com
Reported-by: syzbot+32d3767580a1ea339a81@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000000526f2060a30a085@google.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 833aca92301f0..45ea5d62cef42 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -198,7 +198,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 		TRACE("Block @ 0x%llx, %scompressed size %d\n", index - 2,
 		      compressed ? "" : "un", length);
 	}
-	if (length < 0 || length > output->length ||
+	if (length <= 0 || length > output->length ||
 			(index + length) > msblk->bytes_used) {
 		res = -EIO;
 		goto out;
-- 
2.43.0



