Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A832F5E;
	Tue, 12 Aug 2025 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021954; cv=none; b=m+T352apg+vDpyY5sG9AnwkIdWJghxlwN+UHL2AJqLp9ihrpkyz7dAWiVkN2jAeM7mtmW+D6Efjm+bcLcVr7nltMq9znrDK07y3BNR43yJqqVBkRYeGp7omlrseei55vbuDuf7RAoCgkYMJoCIp707vWtxv/sAg6xoRzYM0YYps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021954; c=relaxed/simple;
	bh=9XO3yXDdMmdmgOof/Thr97TenBk1qiBGXbUu4RUhFWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9FytJTnDGwyFV2n/s1KjmtNy6meW4/moQAY1CVkQ62x5i8FugJs9NywG7+u8oA0g5Z8Fralg2W4995U7M/MrlC1c6wWxbNH1nbxRy7S1bXIwYMZZLc8KVMM5gOxaROEVBlePqKB0ZYp83RFZiTgY1EvT5nZ0FUZr+5cG9DXlFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Upzi/7Gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Upzi/7Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7861AC4CEF0;
	Tue, 12 Aug 2025 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021954;
	bh=9XO3yXDdMmdmgOof/Thr97TenBk1qiBGXbUu4RUhFWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Upzi/7GuAzoepTrtqQ6eiNuqhN5YHa6xJG/rNKQQ3MTdsm4tuakQ7VJkfHF2AC5dX
	 aR4HfojN/On8OM+hNC5cB9yzFe/Qj8sZYGl2CxSXUn6UvwNjslkmc/PUzPWDGWZm06
	 9SqVgqSkj2Yf7LtiL9zX9rfeIuDiU5elD9OQSY0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/369] hfsplus: make splice write available again
Date: Tue, 12 Aug 2025 19:25:09 +0200
Message-ID: <20250812173015.204879582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 2eafb669da0bf71fac0838bff13594970674e2b4 ]

Since 5.10, splice() or sendfile() return EINVAL. This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250529140033.2296791-1-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index f331e9574217..c85b5802ec0f 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -368,6 +368,7 @@ static const struct file_operations hfsplus_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= filemap_splice_read,
+	.splice_write	= iter_file_splice_write,
 	.fsync		= hfsplus_file_fsync,
 	.open		= hfsplus_file_open,
 	.release	= hfsplus_file_release,
-- 
2.39.5



