Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCEF155A4E;
	Tue, 29 Apr 2025 18:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950647; cv=none; b=OGTBDRLPXRsUge+y0P6TjUBlHWrOM7JU8b+fYvH5QCtCMHg+MIOTqW/ZjhGg7X8zj4bedNpRzhUGHk5jeftdzcfiKNFFR99xuZ8eFAQ6RHa/TlTRqZ/fi+THUrAwyH0FlCWgJoynmrGBKhZCxWW7X496if7Sx/i6k2V5+9b6hB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950647; c=relaxed/simple;
	bh=PAmnzfKLf+PVr4FDh2xO29/EVIDaBz4k2aqA1/4Sfdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VreAKqIU4dmYxw0s4a0HHOGfeZFnjG3gZBVJcMVPgSgiAqobvMo6JgNsmcp7JTDBseXt7PR2nNWUYcXnLAn/ZLnqc4+bVpECbQ7JHpAUXikSQtC7mkeULfqg6LPL+lFdPQk9dZi1DefjfdHTIol8gYL9VgmiXHe554zX3XNS348=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9ApJ+3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9ApJ+3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F62C4CEE3;
	Tue, 29 Apr 2025 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950647;
	bh=PAmnzfKLf+PVr4FDh2xO29/EVIDaBz4k2aqA1/4Sfdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9ApJ+3sfvSF2zLIcvdDaY4zvl8lw7GdcqIRsoFpqWMNs19IfN/gGsLw8aJK1Uah+
	 S7og8LJNZHc9WZ8o9ElWw/Q2teuoU5GoiilhRXenFvUuClQuMYsdWZ9xPzzJuNNYF+
	 xXSh26fz2lVtGf35tL0X+Ta6Qd+7oIQzZqxf2GY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+e37dd1dfc814b10caa55@syzkaller.appspotmail.com
Subject: [PATCH 6.6 132/204] fs/ntfs3: Fix WARNING in ntfs_extend_initialized_size
Date: Tue, 29 Apr 2025 18:43:40 +0200
Message-ID: <20250429161104.828597361@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit ff355926445897cc9fdea3b00611e514232c213c ]

Syzbot reported a WARNING in ntfs_extend_initialized_size.
The data type of in->i_valid and to is u64 in ntfs_file_mmap().
If their values are greater than LLONG_MAX, overflow will occur because
the data types of the parameters valid and new_valid corresponding to
the function ntfs_extend_initialized_size() are loff_t.

Before calling ntfs_extend_initialized_size() in the ntfs_file_mmap(),
the "ni->i_valid < to" has been determined, so the same WARN_ON determination
is not required in ntfs_extend_initialized_size().
Just execute the ntfs_extend_initialized_size() in ntfs_extend() to make
a WARN_ON check.

Reported-and-tested-by: syzbot+e37dd1dfc814b10caa55@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e37dd1dfc814b10caa55
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 2ecd0303f9421..4aea458216117 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -335,6 +335,7 @@ static int ntfs_extend(struct inode *inode, loff_t pos, size_t count,
 	}
 
 	if (extend_init && !is_compressed(ni)) {
+		WARN_ON(ni->i_valid >= pos);
 		err = ntfs_extend_initialized_size(file, ni, ni->i_valid, pos);
 		if (err)
 			goto out;
-- 
2.39.5



