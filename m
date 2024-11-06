Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE9C1D2784;
	Wed,  6 Nov 2024 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896042; cv=none; b=XIZl+KIB2vatsfMSLDQqfBkz8yt4q/Eye6XJOIU8/2zIOZbII7dxqLWGZRjR7sddlYq8I4mfQwfPpDQQgoNj6n//bKN5W4Wg8qofHPL5qi44l+f4PghXyljD4rIEwR9zRzwSEhL962K9lwmLOn+OO4oR3jKPEVrAfmzLvsGxu2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896042; c=relaxed/simple;
	bh=EQ1DJBTe8MB56YaVGBtrEAe1UGlYlW5HDGK5+Dm71D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRk9mbYmDHTySvvJrFdx00YjHVYNhR+YWQIWCocmhYgWGXu8MJDEmOoMxa66cNjFbYeeWjFvsMZr6XfuOPNI3guA7uSPx5tctb9e/JLxNI9sNkmp/gHInO9aZ7fUMZp3rxODWx9QlKa3O+KlazA+RgolEMBIIJlWaoRQn6Motrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCY/j2uU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCY/j2uU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9881DC4CECD;
	Wed,  6 Nov 2024 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896042;
	bh=EQ1DJBTe8MB56YaVGBtrEAe1UGlYlW5HDGK5+Dm71D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCY/j2uUEP8IMwEFcnHlFmA2nzSHAMr3NiSQ6/RDH78zLvvo2GFjp3PyPLQU6wHjW
	 aTcghPtNwgQ7b5FqaekqKrZnZARNsKLtXR6I4fgZ4tT0AsnupMCIa/HJETVFoqUg8U
	 RYWCVKUV3U8D6dLDdrE1xIQb8/qIpIWE5V57f2I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 069/245] smb: client: set correct device number on nfs reparse points
Date: Wed,  6 Nov 2024 13:02:02 +0100
Message-ID: <20241106120320.903333201@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit a9de67336a4aa3ff2e706ba023fb5f7ff681a954 ]

Fix major and minor numbers set on special files created with NFS
reparse points.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index a4e25b99411ec..c848b5e88d32f 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -108,8 +108,8 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 	buf->InodeType = cpu_to_le64(type);
 	buf->ReparseDataLength = cpu_to_le16(len + dlen -
 					     sizeof(struct reparse_data_buffer));
-	*(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MAJOR(dev) << 32) |
-						 MINOR(dev));
+	*(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MINOR(dev) << 32) |
+						 MAJOR(dev));
 	iov->iov_base = buf;
 	iov->iov_len = len + dlen;
 	return 0;
-- 
2.43.0



