Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A934846D;
	Tue, 16 Dec 2025 11:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885135; cv=none; b=c62bjAQcJeFata7wTfSbmVe0XSPM87dibPnOuo9TA6y+ChDEVUz/ngBh95wVcMRT5ieXf0hiOUg8sCCGjmTxypwLCTZQfvu5mVwl58ka5S8EENs4bZZ6YGGNZn+gzVT/C0r9HuL6n5DSwc4NM9yulM6hM8K9NmdajtTRXvEiskg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885135; c=relaxed/simple;
	bh=PXRP0gHfcJH+LZKYbbfL6zObz0yTMlBKj/Qw1WzU5Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UKClo2GVtKCCQ2tNBX6EbQaRi4IDyfuDU6Rpm4TEprGVp4o4Rtqsg9Hu6VR12Z0pzcENRY3buWWg1GuHlqIX8tBxCEs5tqEZmR+n4VX/O0JDpGD5IngAVLxioezXXSNxVSkb8r0EH3UFL753Tf16APL+/768gMtyrInhLwcv9e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJRDzi/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJRDzi/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C29C4CEF1;
	Tue, 16 Dec 2025 11:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885135;
	bh=PXRP0gHfcJH+LZKYbbfL6zObz0yTMlBKj/Qw1WzU5Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJRDzi/wjrOxR4dOkjyUOw0wSuh/ryFqUdaYrC9GL9lHeqS28dw21zmirVn8454z8
	 tmovmSoeZcQkX3TDv4uGPJLQm8Wemz+JUT4icIHC8yppsP2LiJ/xVIMdn1LNx9Iw8y
	 Pog2fjmV/Q5bkiT74gcfveRyz1cb5JnZsfITiKlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7a2ba6b7b66340cff225@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 048/507] ntfs3: fix uninit memory after failed mi_read in mi_format_new
Date: Tue, 16 Dec 2025 12:08:09 +0100
Message-ID: <20251216111347.284487705@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>

[ Upstream commit 73e6b9dacf72a1e7a4265eacca46f8f33e0997d6 ]

Fix a KMSAN un-init bug found by syzkaller.

ntfs_get_bh() expects a buffer from sb_getblk(), that buffer may not be
uptodate. We do not bring the buffer uptodate before setting it as
uptodate. If the buffer were to not be uptodate, it could mean adding a
buffer with un-init data to the mi record. Attempting to load that record
will trigger KMSAN.

Avoid this by setting the buffer as uptodate, if it’s not already, by
overwriting it.

Reported-by: syzbot+7a2ba6b7b66340cff225@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7a2ba6b7b66340cff225
Tested-by: syzbot+7a2ba6b7b66340cff225@syzkaller.appspotmail.com
Fixes: 4342306f0f0d5 ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index c7a2f191254da..5ae910e9ecbda 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1349,7 +1349,14 @@ int ntfs_get_bh(struct ntfs_sb_info *sbi, const struct runs_tree *run, u64 vbo,
 				}
 				if (buffer_locked(bh))
 					__wait_on_buffer(bh);
-				set_buffer_uptodate(bh);
+
+				lock_buffer(bh);
+				if (!buffer_uptodate(bh))
+				{
+					memset(bh->b_data, 0, blocksize);
+					set_buffer_uptodate(bh);
+				}
+				unlock_buffer(bh);
 			} else {
 				bh = ntfs_bread(sb, block);
 				if (!bh) {
-- 
2.51.0



