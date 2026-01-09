Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E146622F77B;
	Fri,  9 Jan 2026 11:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959610; cv=none; b=lNC/zC2fGNBkDqlKRRx4YlsudQUj87KwczDzlU/cdDMcZZdyaVKjEjL9/WKpRfYyUnystyag8pWtxKMJb5M8VgfeNF9SYoAn8zDyiXli952GJlpycCS81rLS5e7r4IpVzxzb2iN4g3y5zkSrxf6c0yfBeOzOxk//aASZ6UHKL38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959610; c=relaxed/simple;
	bh=VR40LFPXArYqcIJ8ORDG4js7QLiSypxyEc7liIRIMlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UMhtbO/awfGSyL0b+1kK9bQxBVXe5htpPrP1xK44l5JN2Ci6DV8Ns0tQ9XHkuZ01zb7h+KYHz+h4VdSicUiWL7aS8ygevrFWYvwHuTxIFopM/u21aHP0Z23z7ZsUoMQq9BR5GbPckuSsm8IOPJHwTG7PD/L3m043errVULgELpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Teb0ZS/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Teb0ZS/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CD2C19421;
	Fri,  9 Jan 2026 11:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959609;
	bh=VR40LFPXArYqcIJ8ORDG4js7QLiSypxyEc7liIRIMlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Teb0ZS/A2iUMNjelh8Eed6ynj3FEWJwItjP7WVv6La6IbY+Fvwm5UGZQfoiD1UlFy
	 Jfn25HY1EWE9aHrm6XhUl3EYYF6ClfR/xL3ByrUWEq424nBhZdgMt9Ur9B45AR3UDB
	 5S14QsGUj4g2hwhY/EXzAsFedsFWjuQKNq5N1y6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7a2ba6b7b66340cff225@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/737] ntfs3: fix uninit memory after failed mi_read in mi_format_new
Date: Fri,  9 Jan 2026 12:33:28 +0100
Message-ID: <20260109112136.593751286@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e19b13db4f91e..446079b0866d4 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1369,7 +1369,14 @@ int ntfs_get_bh(struct ntfs_sb_info *sbi, const struct runs_tree *run, u64 vbo,
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



