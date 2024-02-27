Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2CF2F2D;
	Tue, 27 Feb 2024 13:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040755; cv=none; b=OuJPsJW2xiT71KFv+pWHgTT1Jp5v12Rh98upWzF2z0YFXOZQsBRrpxNRJyiDy+1KUWuxZkUZ9ZupBxkOvrl2z+jg8w45XfJrKsdoP+pGDVCVA8r88okk5MtTsGOWg0I37yTQDiXkkwZdqQvFtTR36kw0IxBrew/M0aYzZeXka7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040755; c=relaxed/simple;
	bh=HHNYB9a6EMdBmGwNYkJFBWmORDufhb3yYXokrb98Vuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVu1LAdqK5ojFJafnwP9IYn5+PKWxHNKxGbirrDbEgsscP110vsTVl1FlT4nG5WrZ+gIe5xc6zVr/hKLAFPzr5+zNLsl/MMrXWChQ2vWYjlofLujSW2r4FTGGfWkUKIjc4Y+nqUzfcxvzMFRqUWKgNGfVC62GKjnH5KY1PHeZRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQ+/QmVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQ+/QmVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEB7C433F1;
	Tue, 27 Feb 2024 13:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040755;
	bh=HHNYB9a6EMdBmGwNYkJFBWmORDufhb3yYXokrb98Vuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQ+/QmVdz5ykRbXHZwU8iatvsGaD+EhNZ86YRThxV+V7dhzYYr7SGbFARcuTPTkTk
	 c0XG0YYJfIGNnZrmdMB8/tN9YgOXgXJGCD9lr2Z2BaDQN76SXeYPSJqauDeEp0FiG7
	 e7CxbK/+U7usvs9+1v0RB/sXVlNq0x46fVkrDXwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Santini <giovannisantini93@yahoo.it>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 099/334] fs/ntfs3: Update inode->i_size after success write into compressed file
Date: Tue, 27 Feb 2024 14:19:17 +0100
Message-ID: <20240227131633.694044714@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index b702543a87953..691b0c9b95ae7 100644
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



