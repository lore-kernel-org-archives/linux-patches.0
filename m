Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9FF1F891C;
	Tue,  3 Dec 2024 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242018; cv=none; b=isd4ncDkAe7CY4PK8uapla2Wc7g8VU2VpqdkaDB1n9uVd5uI3zMDUJk1ei9isuE62O2ps9T0gQoDtiqOaU75sFckE9Sqd/bgBU2NGe6CYVlCmzvZjhfsDGmljjSZZEuZyVxweDIhQ4iVOjxFLe0A7lTbGlw9fYDOKIA/QLjGfiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242018; c=relaxed/simple;
	bh=DBLD4k5hJAS/cQzOaAbGNIQwdMwtDdA39/ufYjDiEvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd9rRq6eUjiduQrEskGqIUQ7qRRGd0DeNJZ40QV9GCamUwrnRImnHtCw1Opnsp9EtE7fwXsEcFnRY9urrBH5eEYHpuFgE5hLt+HtHufJyxJTl9RHS2f76vjYvLHv4b/Wgj/M85zKXvevTJB7g4/Je3UBVx+ugPAq0m6P+0MCEI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcA6T/yZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcA6T/yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A168BC4CECF;
	Tue,  3 Dec 2024 16:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242018;
	bh=DBLD4k5hJAS/cQzOaAbGNIQwdMwtDdA39/ufYjDiEvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcA6T/yZ7TD0nSxcEuuLTE62E+7KtEpT4T05Lesv74LxB2zEppfbiGFqvwccKKxj5
	 CHi3kr1zzIuY3z5S9jQ86EQqUNfd61cTnPI4s6VFlfoq8yOBJsVfrmshiH3qV+OcrS
	 ElokMQtqmEElKT7tAOMpCDKEV1O/W5+6jDxP2s18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 552/826] fs/ntfs3: Equivalent transition from page to folio
Date: Tue,  3 Dec 2024 15:44:39 +0100
Message-ID: <20241203144805.282250224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 045fff619312fb013540c80cff18aab3c33048ab ]

If using the proposed function folio_zero_range(), should one switch
from 'start + end' to 'start + length,' or use folio_zero_segment()

Fixes: 1da86618bdce ("fs: Convert aops->write_begin to take a folio")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index e370eaf9bfe2e..f704ceef95394 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -222,7 +222,7 @@ static int ntfs_extend_initialized_size(struct file *file,
 		if (err)
 			goto out;
 
-		folio_zero_range(folio, zerofrom, folio_size(folio));
+		folio_zero_range(folio, zerofrom, folio_size(folio) - zerofrom);
 
 		err = ntfs_write_end(file, mapping, pos, len, len, folio, NULL);
 		if (err < 0)
-- 
2.43.0



