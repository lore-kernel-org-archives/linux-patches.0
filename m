Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37613A7F43;
	Thu, 15 Jan 2026 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497321; cv=none; b=HJhw39YCZ6g6f0dZ2Ia/VH3q/D+Nc1Yc8r7q7Jo4ekXUducSWFvoltMRp+Xwa7PdBVZNLzmfmrNocowiCOEV8hYoy/bxlL/TuGP1o3BnvkQ0YsdtA8kKvczURsFr61MM7i+QaTRbitrtzQ5hTlF9cNF627ujIj6zJmV8ltUrI5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497321; c=relaxed/simple;
	bh=XoYkPAc83U7HM/0pO3kQxuT2Q5mxNIIFDjrMnrjuc9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ToJBTiA9rGTqbq4Lz54psRXwxjOHoObeeF6E23togaQHhXB77n0jvi75QiX/jZU1j0sb9BH7qMElC/CYI3Zj4vRQjawREh9d/isn1zhlqac1HZDs6NBF9AeOQMvx/SdbtOGW0cs+G756P9b6rrKIVtFPNfUUN+Zmrm5p/FRAijI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEMLgzB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEMLgzB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32949C116D0;
	Thu, 15 Jan 2026 17:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497321;
	bh=XoYkPAc83U7HM/0pO3kQxuT2Q5mxNIIFDjrMnrjuc9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEMLgzB1dK5704iBbW3S8iH7gal10Vny0v3V/sAMNUJgF3rVAfYMRqcXz3K736Ufe
	 cJHv5DbRM114OY4eTLJdcoGhvJRyyfRLfTPig1OrZk0gUB3RL1GKSy33U5a4DoActt
	 w2xnt+Beu/Ogj2mEULTm2bomLhRjxS+CxDMK9avI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7a2ba6b7b66340cff225@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/554] ntfs3: fix uninit memory after failed mi_read in mi_format_new
Date: Thu, 15 Jan 2026 17:41:47 +0100
Message-ID: <20260115164247.730858590@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index abf28c0db71a3..c82398194cd10 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1343,7 +1343,14 @@ int ntfs_get_bh(struct ntfs_sb_info *sbi, const struct runs_tree *run, u64 vbo,
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



