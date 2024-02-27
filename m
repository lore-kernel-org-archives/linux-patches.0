Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8487013B2BA;
	Tue, 27 Feb 2024 14:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042704; cv=none; b=aa7yqeSQ0gGWLLPGzTbgyWQBKXj2ON/zX/43EZlwfac+zwDCKfDL8w5FMv1n8wNmjiSfFDh3RkQyC86PYyy8oBiIs6Cm4bhGc+6cznsC4SQ9FWX3gikvMYZ37NASbhjdbk7F0OHYPJTRLBkhppRXnnAUGy/be1ypFKnwrM8cxtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042704; c=relaxed/simple;
	bh=M801NmTDOXen7LQ5RlpZrN2jGPYe5+NtzDLjnRBPIaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgRCFQZETWD4xmOXEcn96qGsKKFEAR9VmhW/OfXAFNo2IVjSgOvDGrNjyiDr32Rwre9r0JMo5wt3YkSmJPyS3eSFbYCgubl+CpiAuRcKdJ1FCgZIfRvg8LQRbxMzGScNhUQQf3OM9bIfNyeyPHVl6yO1L8KCMY17eGKJ7Y51RtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIeeW2Zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIeeW2Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB4EC433C7;
	Tue, 27 Feb 2024 14:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042704;
	bh=M801NmTDOXen7LQ5RlpZrN2jGPYe5+NtzDLjnRBPIaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIeeW2Zvn2jO9vm2oE/GIYFENnGMH8rgEBsqUs2aWWKMnN6D+/5aVyPTn1m2QMlU6
	 8svOBD2HYhCfDxB7h8ho1J2jVK898dMF4nGrEDZ2f9QVrSo5V1ewNG65lPePeC1LNq
	 Tzw0Gw2IaUHPKZhkL1cASMyS6JRiNJXnBwJ+b+hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Santini <giovannisantini93@yahoo.it>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/245] fs/ntfs3: Update inode->i_size after success write into compressed file
Date: Tue, 27 Feb 2024 14:24:10 +0100
Message-ID: <20240227131617.259382813@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c526e0427f2bf..6d4f3431bc75a 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1090,6 +1090,8 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 	iocb->ki_pos += written;
 	if (iocb->ki_pos > ni->i_valid)
 		ni->i_valid = iocb->ki_pos;
+	if (iocb->ki_pos > i_size)
+		i_size_write(inode, iocb->ki_pos);
 
 	return written;
 }
-- 
2.43.0



