Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829612;
	b=jF6HYyrtD6pKZh68DM94Yi2zj1msZ4C+4cFn9YLvh+Mla4fPNfbtXz25Yf4P3I9ykVUW
	 3qjJMmvf5XMpIjDYOdtp3XHaswQHph7f78A1bMtGfAU9r+icY5/mtgkEhwnRXQgymCeWB
	 QRBUXBasCjPsUtVrobScqkmAI7GZoz7iEX1t7Ee0jRsgk3EThXPEAaiC++xoc9GngsD8i
	 1JFRmMp154tM8OlGOtpdwVvZyjO80KJv28om2EeRXLDTqK7OX5NdHU7nM7TpGFnvb5h3S
	 0Kp83XgNtw8nZYXtFp7qU3IBhoKt6iziBouiZ+qvnHDDjOpjHtZqzzyXnf9GebuOnOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O2jam49ULyebCiMEL0VDLhAmKdjNAbnysFvSB3oeopM=;
	b=yTP+2AlEwA5510vHwzCxjn0ZNtNACSXlsu8ap2DzQNM1ZQN21KsSnC9nMhGN8rk4pYyX
	 TWG103f3FgpkDF6qx2npYjnscXIn8YWW/2uCpVVLuPCsd5fqxiyKduzVeu+MQJZMdROQQ
	 1sxzWK49UpWtAxirFWye3jgfgWqSZoB20I9n9IWJ3NxFwIwTJMVFzpycAIERXL+vb99c3
	 Rec55xXDznuu9F3GAsmtRZ+zzLUgWjqmv07Z9HO0eoN7x8GqcAqYvL7afGRLlf2oBZtO+
	 qHbyGYIr+B+tL6g89sQi37+OJHLAtd7m+NqwKHDMbYETLesufKIXUpqdq+FYWgvX7tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjiWhCUI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632AA608C99B;
	Wed,  4 Nov 2026 22:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjiWhCUI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100C01F000C1;
	Wed,  4 Nov 2026 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829612;
	bh=O2jam49ULyebCiMEL0VDLhAmKdjNAbnysFvSB3oeopM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjiWhCUIiB/ADT7IESG+8HODB/yX5+YYYpMyp0aKQu+xz3MvsF/QJBMR0sviCVAWt
	 8fdnTiDC6rS4iaDr1/3+qkooYwMyevzP6KCY0u44tEj/vjeDZlXzuWLZyRmK3hoK3Z
	 HK8FAZ6weZAcRdymwMiSRrsjX1jHLo1oXIhuCm/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0235/1005] ext4: use FGP_WRITEBEGIN for tail block zeroing
Date: Wed,  4 Nov 2026 15:59:28 -0500
Message-ID: <20261104211050.434408166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit e1cf7b5f5c8ad1e00d00c50c61c3e8fdc79cd422 ]

ext4_load_tail_bh() returns a locked folio that callers immediately
mutate through folio_zero_range() and mark_buffer_dirty().  Use
FGP_WRITEBEGIN so that, on backing devices that require stable writes,
__filemap_get_folio() waits for writeback to finish before returning
the folio; on regular devices the wait is a no-op.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2e3f7ba1a924b..c3fb5f16f6e39 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4092,7 +4092,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	int err = 0;
 
 	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT,
-				    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				    FGP_WRITEBEGIN | FGP_ACCESSED,
 				    mapping_gfp_constraint(mapping, ~__GFP_FS));
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-- 
2.53.0



