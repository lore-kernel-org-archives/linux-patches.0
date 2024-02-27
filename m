Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B043278B61;
	Tue, 27 Feb 2024 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043318; cv=none; b=K0YX/coQLp6GVJyrPA1O1sh8bvX/LKc0vuIDLax54ogdg0Qml8XXOGavU740hJv8eQVIz91z7Kdb8iRBpYPxVFDbXD04iAbkHjqf539+uaDLf0JNAuzOfB3J2PHlDwisUruTMKDQRuhX4S56z7OcZpyEs0MpAGrC2Cf8huE82tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043318; c=relaxed/simple;
	bh=6XTMu0JsUZq11pwSeEClFbrm6AuznHW6lzVbhxFqwRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iopDAl+TDYLin4BtyOp5oSSUSE7hZ1lOELeMS0SHAfKsUDknmsBO8dLBxvkZRAV0zhQr+iDXycuRzVCO/sGWskcw2R0x/ApZzdCHD6ejG08J9+Za/7IdIGRag2fHQkxejsXIFFCGInmD68YaPn2eR63Pvaxv2g+P7lxAUPqEHMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbmxs/ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbmxs/ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF088C433C7;
	Tue, 27 Feb 2024 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043318;
	bh=6XTMu0JsUZq11pwSeEClFbrm6AuznHW6lzVbhxFqwRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbmxs/ngWQ8MHSRZIyFscelvHzOzyZfQoHZc6r/9EqhKCtmwzV8lw98FDXo75gcef
	 nfQjlyOFf3RgP+0Ea9BRRI/TyZAAHbr1WQrElsc4YMLTdtqHq3z9n9SoPud/GdKbTl
	 GHo6mW5EVYx6OIsskpGa+qLDpP2tjYkHbHPQAdeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Santini <giovannisantini93@yahoo.it>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/195] fs/ntfs3: Update inode->i_size after success write into compressed file
Date: Tue, 27 Feb 2024 14:25:25 +0100
Message-ID: <20240227131612.617477837@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d68968440b1a75dee05cfac7f368f1aa139e1911 ]

Reported-by: Giovanni Santini <giovannisantini93@yahoo.it>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index f31c0389a2e7d..14efe46df91ef 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1110,6 +1110,8 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 	iocb->ki_pos += written;
 	if (iocb->ki_pos > ni->i_valid)
 		ni->i_valid = iocb->ki_pos;
+	if (iocb->ki_pos > i_size)
+		i_size_write(inode, iocb->ki_pos);
 
 	return written;
 }
-- 
2.43.0



