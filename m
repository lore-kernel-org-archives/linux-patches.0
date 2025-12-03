Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AB734F270;
	Wed,  3 Dec 2025 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777885; cv=none; b=oV7MUvvO1CpZ7cHQsUkH6/3ENUwSut4p9g1yyDkyAvEjZleTje//rSZW5MInmK7z0bfpJQmCRWDxKXhoWVvwbgYd9uC/tnA1omVltrRGmh/9K9OEkkUUq3VL9AkB8RaSSxmgxmkuaR0R+1TcCGPMzmi831zADw/0Rsih1rm88aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777885; c=relaxed/simple;
	bh=LvyS62fom42inBUTxf4y2Ay/kQUkfRo460UF1nfCcvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8s8oEh1JgofNd0gDkCWidH2wYzUv1x8J6zz38Y64EGVVW0KRFo+e0BywnO6jeDWR5xCglbO5Rc5A4kQyz5qfZEl1ogf+26o7BgmRPMZjRCXyehCN7NXyurFCsR/H1y0X+AN/y2iMwIMvj1DBfuFoKHjfEt7Ww2rGMtw104G0mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Az3UT222; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Az3UT222"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7BBC4CEF5;
	Wed,  3 Dec 2025 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777885;
	bh=LvyS62fom42inBUTxf4y2Ay/kQUkfRo460UF1nfCcvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Az3UT222S1i+TQjsttbBMxfrg4YzJ0Uy+YED/g1LYgDyR3q5luUx0Fky453syH6p6
	 Tgc6+QIBrFbGb0yjgTOUXpZ+By+5XIHpJziRKJqOCivtU5/rxFb5t5RwBTfURpaZxn
	 KEXOSBQoRRCic+o8c5+47tDYMJnYuze6dvKGasP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chuguangqing <chuguangqing@inspur.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/392] fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock
Date: Wed,  3 Dec 2025 16:25:28 +0100
Message-ID: <20251203152420.632025901@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: chuguangqing <chuguangqing@inspur.com>

[ Upstream commit 1534f72dc2a11ded38b0e0268fbcc0ca24e9fd4a ]

The parent function ext4_xattr_inode_lookup_create already uses GFP_NOFS for memory alloction, so the function ext4_xattr_inode_cache_find should use same gfp_flag.

Signed-off-by: chuguangqing <chuguangqing@inspur.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 115c6ddccd7c4..b1529988e9def 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1499,7 +1499,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 	WARN_ON_ONCE(ext4_handle_valid(journal_current_handle()) &&
 		     !(current->flags & PF_MEMALLOC_NOFS));
 
-	ea_data = kvmalloc(value_len, GFP_KERNEL);
+	ea_data = kvmalloc(value_len, GFP_NOFS);
 	if (!ea_data) {
 		mb_cache_entry_put(ea_inode_cache, ce);
 		return NULL;
-- 
2.51.0



