Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0743C1D66;
	Wed, 30 Sep 2026 19:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794970; cv=none; b=ZPxtZple3JlKMlqnyF0ViWE5Hq+u70/Va9jXYEYhfCSngKkHr5AapdgPry668TDZDCxzFsqSzrCpOpwzTjhnW5o9WqVU2ZJrIcsVI3dqIL580HGOfWg+IYauu0XTaCMXsMgad9FZ2/2c/Asi/eHucOZT29bVuVxlbjp267ftJNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794970; c=relaxed/simple;
	bh=13h/WEAvM9q0V6ToiW1xSYSgcG195dnZvuHGuayozs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqYRPWJ5Wtv9fxneY0NUu1yl54SM4oCEmHP1NwevXm7PwNi/6JvjBQzCWa3twSh55jKwDQNvzupj2fdtvMXblshpKI6z2L1Ki0k8Nyck7P9pLnk9lBX6HxQoqBw9+1cvKcGrL4QEvpr60J6D1bSQfaXazd3bwYgn3jfkuJOOs2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpq0hlEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpq0hlEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E4B1F000FF;
	Wed, 30 Sep 2026 19:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794969;
	bh=a6DD5NpeQahvPihsg2Nb2M6ef866eJf6Uu53Tq6x7CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpq0hlEp1LbNk+4ghbQQzgotiKc68YjMksB3RRjSLEh6l0+JmQ0YLmcJtSpoIaOZ7
	 1Wm42xTue4q4vuYMLv4AhRT6uY0Sq0Sy6Ck44oO6fYN4p0DdGHfuKdXRO5o8jBfmUS
	 2Je8KsiuXMMmUGtMUys0OpzeTV9Z6eMYVyV3mr1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0397/1193] smb/client: mark file sparse before emulating insert range
Date: Wed, 30 Sep 2026 17:18:01 +0200
Message-ID: <20260930152443.008566688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit cd03ce4950d80147ac8f20bc03c42b75b0352407 ]

The SMB client emulates FALLOC_FL_INSERT_RANGE with SET_EOF, COPYCHUNK
and SET_ZERO_DATA.

SET_ZERO_DATA creates a hole only when the file is sparse. On a
non-sparse file, it clears the inserted range but leaves its blocks
allocated, causing the extent count check in xfstests generic/064 to
fail.

Fix this by marking the file sparse before modifying it.

This patch produces the expected sparse extents in xfstests generic/064
only when the server-reported block size is compatible with the server's
deallocation granularity.

For ksmbd, the reported block size follows the backing filesystem,
and the test passes. For Samba, the test passes with a block size
matching the backend granularity, for example, 4 KiB on Btrfs, but not
with the default 1 KiB value. For Windows Server 2022, 4 KiB inserts do
not generate holes, while aligned inserts of 64 KiB or larger do.

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 956d1dc8bca39..f065f52cacacf 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3715,6 +3715,11 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	count = old_eof - off;
 	new_eof = old_eof + len;
 
+	/* SET_ZERO_DATA creates a hole only in a sparse file. */
+	rc = smb2_set_sparse(xid, tcon, cfile, inode, true);
+	if (rc)
+		goto out;
+
 	filemap_invalidate_lock(inode->i_mapping);
 	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
 	if (rc < 0)
-- 
2.53.0



