Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47F63358B0;
	Tue, 16 Dec 2025 11:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883918; cv=none; b=BpDIROFEtchnRQzPoY+FaiDmBybv/J7NSKNhivxsjhdoAux2e01vkvQagm4bc/kdd8j4gBRnINB5zIJUBwUoXpr/sDQgvyYx1btZGLkDYaGSdb5zn2zfChu6nO7V+5YSDZ/eZeBU3IoQbON2zHexr8AdCPnYmS5tRSWcHvy4kK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883918; c=relaxed/simple;
	bh=RU5jHjNsplbT3KXwJBKCoOy9FklilujuUAyvv6KAgPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGAxZBv48ZZp0ng+Fbrq7en5ZEjCz0j+FxhOIEFxtaXI5K641FiDl5/8tZRddvsPYvwDKMB8fbjLB1/qV2C65DXHFwB5V2ZhBsqT+Tv5WUigllfuHxbROu3aq56k4YzSZWfSp1fmhYnEpxMlKT1IzttADeHy+gZ6bV2NRJjjLmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRtqtRkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRtqtRkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09463C4CEF1;
	Tue, 16 Dec 2025 11:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883918;
	bh=RU5jHjNsplbT3KXwJBKCoOy9FklilujuUAyvv6KAgPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRtqtRkUDngJ25Rz7z7GRK4CFP7hEQ/wFRCxqg3mCyCD0A0DDejc529jZzaB70rhp
	 jxO1UFHeo+OiV1BgDsbsZOj8NpMWeithe2zabux6/PWKPpceJWuv6rkIEnyn/qt2C0
	 lbCUEfWX8Kcu+AXIsAa8ERJ8uTSnojEYO3FYb2eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7a2ba6b7b66340cff225@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/354] ntfs3: fix uninit memory after failed mi_read in mi_format_new
Date: Tue, 16 Dec 2025 12:10:05 +0100
Message-ID: <20251216111322.295188376@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6c73e93afb478..57933576212bb 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1373,7 +1373,14 @@ int ntfs_get_bh(struct ntfs_sb_info *sbi, const struct runs_tree *run, u64 vbo,
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



