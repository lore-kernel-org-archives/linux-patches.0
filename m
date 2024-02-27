Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B94613B7A2;
	Tue, 27 Feb 2024 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041851; cv=none; b=FAxppQXyotECC8I2YzLMMfRFre9IajSo/j6f/qjnV4juGZGfdc40UpZHW8QlX+PFObhbGvA3z7eIXh4E/TIRbXPKVDUjH7mZEzxni4S2zWP79OkffTHZE7eZL0rWN+/3Hia8T8TWfQOrvRmRAhbm2fwuV9DugAyu9YpoaXxVxkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041851; c=relaxed/simple;
	bh=mxLmv5Dlhh/Fj729EgqkU02Bl4PgatAWCMclSKyU4zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFVW8lcj26iy1RqYgTIjV89n2goyJLl8/krwl4BUbBVldS+jAKuDN71BafKRHBkkSRbqaRwL2hMf5rCU9s7a4sZc2HJ8ry92Xr7G4+L6XoiRenA+R2J5HwG5YHvD+STgdpeVBFOXkSClyOhGXC4cgzkBhJPfmFpKsTlNdLJVDv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlGuCkwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlGuCkwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675C7C433C7;
	Tue, 27 Feb 2024 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041850;
	bh=mxLmv5Dlhh/Fj729EgqkU02Bl4PgatAWCMclSKyU4zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlGuCkwe0dSwYc8itr/xe8j4dVKCA1ajS8Gd0GNHYsJDaHNdu8Qjh/NX6No7NiZUo
	 XWbXFWMUSCSkQu1ICFlj9P62PW2Q0jNlrPuZclY/0nOhWqeSqTdwpE5rqngzTb+lWD
	 gvtfpVqtcUVLEsOZakl2wMGHwD9dE8Jui4AqmwuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Santini <giovannisantini93@yahoo.it>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/299] fs/ntfs3: Update inode->i_size after success write into compressed file
Date: Tue, 27 Feb 2024 14:23:21 +0100
Message-ID: <20240227131628.805955113@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d68968440b1a75dee05cfac7f368f1aa139e1911 ]

Reported-by: Giovanni Santini <giovannisantini93@yahoo.it>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 0f6a78aef90fe..dfd5402a42e44 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1054,6 +1054,8 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 	iocb->ki_pos += written;
 	if (iocb->ki_pos > ni->i_valid)
 		ni->i_valid = iocb->ki_pos;
+	if (iocb->ki_pos > i_size)
+		i_size_write(inode, iocb->ki_pos);
 
 	return written;
 }
-- 
2.43.0



