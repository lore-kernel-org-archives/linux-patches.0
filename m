Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E941C26F2A7;
	Thu, 27 Nov 2025 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254900; cv=none; b=eXE1ILTrH5mTo+02BfC7dWj9CNdllk4O22AH6KqSaH6O6q+Dcn6v5z0kbAKaNnQPjxmBg3GxYbWm7szDjAlgF7rpcFgdf6pvrcR3fukWXGRgxl7FhDmUoTNqupRTuyKtsbObiqwXzwhZ4pG0BHz8XXcioBUYF21wQH9hJ1MP0dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254900; c=relaxed/simple;
	bh=n0GVNggKO8Wrj0eFhXirnOa7Zi8oNfYj5mzRqqCK3jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeFkdpinZNcmRiHZjvxL1n2x4BxrRm3rzs2LLLkWKRR0Oo3socm45sQxMkGqVdKnbpQg8xssIoWjPyS+6yTuJOyS1+qteaop3Ur0zS6N3cc6b4Lw5taoegpYQftXqzI18ct98cSObnPvW0HY8ABiBL8AW9xSKD/xV+821r5SoCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IK9IP5Dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IK9IP5Dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76922C4CEF8;
	Thu, 27 Nov 2025 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254899;
	bh=n0GVNggKO8Wrj0eFhXirnOa7Zi8oNfYj5mzRqqCK3jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IK9IP5Dkpjvaglj5KVKICvB2lpXGUd1MoIzE8oDSqyoGDUKM1qe/KhbBtK5v420uS
	 GvCKvG3VTO6G09xnQ9hhX6GpcKczCXuVI95pq+zwSbfvTCNz9BlAF54EziTIbgKHUR
	 bXYV5/IT+xpNrxVq3CjMhD4iG39QPodjR4yDDINU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 06/86] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
Date: Thu, 27 Nov 2025 15:45:22 +0100
Message-ID: <20251127144028.040814717@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit f2c1f631630e01821fe4c3fdf6077bc7a8284f82 upstream.

sb_min_blocksize() may return 0. Check its return value to avoid
accessing the filesystem super block when sb->s_blocksize is 0.

Cc: stable@vger.kernel.org # v6.15
Fixes: 719c1e1829166d ("exfat: add super block operations")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Link: https://patch.msgid.link/20251104125009.2111925-3-yangyongpeng.storage@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -411,7 +411,10 @@ static int exfat_read_boot_sector(struct
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
 	/* set block size to read super block */
-	sb_min_blocksize(sb, 512);
+	if (!sb_min_blocksize(sb, 512)) {
+		exfat_err(sb, "unable to set blocksize");
+		return -EINVAL;
+	}
 
 	/* read boot sector */
 	sbi->boot_bh = sb_bread(sb, 0);


