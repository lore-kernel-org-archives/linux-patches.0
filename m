Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ED43B6BE5;
	Tue, 21 Jul 2026 22:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672855; cv=none; b=IfURqzhG0KzyR4Gk6PcFdw4odU3zqR1m8/RNLaUfrQ8agrDcUD/VE4SKgkx2O3n9iRSDNuV28wKxGJdPtmwxuGXZWEccAI0x6fjxn2gdsOzd4XijzaGHsZ9yCV/gnAY4i6Fe9pAD8bQ0P1JsT3u13kEr0sbVfb/qUKP9scxv/Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672855; c=relaxed/simple;
	bh=rIcZdvT2nAMXJDcW3jKTzXF6SXwx1qwFuB4u4bQsRGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PS6XNM1FIYL7SP+6M/fRjILwzmCsM42ub4qjsjhysvfuI65EHYLqK0U5WwKQqvjDnUJR47SYkV4knW2noTH/PG+hV7HGHM2zh8lL0Vr2C3Am/lYlqQWJzg/+EYNCoBlXK0i0zTNevfV4rfNNCWq7OE/RpSCbQV/asFgw4LVTIzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pH/XeHjb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pH/XeHjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34BA1F000E9;
	Tue, 21 Jul 2026 22:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672854;
	bh=8oU1wSCZ0ICa6zrohDf3Jb55MNLPHVlFdAlACkO8IuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pH/XeHjbayjbyTciJ0jjCYuB3Ep5il8VJZs9wqb7vKyS2ZznZV0FPfFEynaCFQTbW
	 mqndKNmRHamE6Aycz+Z2N+oerymoKgiLXaAiTwSWLOWXK0hHk/PXuG1v/NB6rLLE0n
	 cjisK99OweVPYYNDH32il8ZjVWMOQY90Ph2hLWT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 783/843] smb: client: use unaligned reads in parse_posix_ctxt()
Date: Tue, 21 Jul 2026 17:26:58 +0200
Message-ID: <20260721152423.673258354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

[ Upstream commit b86467cd2691192ad4809a5a6e922fc24b8e9839 ]

The server controls create-context DataOffset, so the POSIX context data
pointer may be misaligned on strict-alignment architectures. Use
get_unaligned_le32() when reading nlink, reparse_tag, and mode.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2037,9 +2037,9 @@ parse_posix_ctxt(struct create_context *
 
 	memset(posix, 0, sizeof(*posix));
 
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+	posix->nlink = get_unaligned_le32(beg);
+	posix->reparse_tag = get_unaligned_le32(beg + 4);
+	posix->mode = get_unaligned_le32(beg + 8);
 
 	sid = beg + 12;
 	sid_len = posix_info_sid_size(sid, end);


