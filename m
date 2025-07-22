Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758EF2ECD29;
	Tue, 22 Jul 2025 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193682; cv=none; b=fSjq69HcQG+2optWYkVAekwETJI4uaRNpYpJY+LFMtbcdrdBWraQjEZ3bkkme8YBSRp77o5mwj7O+tXJN3F0luiVVN7Qrv6ntUh/V7A9tjvGhE1X8mlL99nKdmZg6aaz5pfExIRz22bVgvozCh88MTY6DuNUAQceZdEZrF3XabA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193682; c=relaxed/simple;
	bh=dx3QLZFobVnJn+2QzmFQZUv8KnkqS8oSEosofWoy6qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VmxEqO2Jbe7Vx4ayTITVI+Fgpe/esqhklP90FzwGqhTS1iVPGb5s7WWl8fmUxSqEPTymgwTW3f18mwwh3BmjpCbPOwIwbfW1/ivIX+LlzmCvUQxBifmC7FgzD1uUQSAmrM78VW99ifjjbvPI6aothQWjpdhWkinkzqc0VZrhOy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whUGT7YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whUGT7YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CA5C4CEEB;
	Tue, 22 Jul 2025 14:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193680;
	bh=dx3QLZFobVnJn+2QzmFQZUv8KnkqS8oSEosofWoy6qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whUGT7YOjRsULwWVBb7iVLP8vn8anW5ZjjgTMmY9S1P0V0RfD+00okgbdSkrg4hRB
	 0szk4ARttEr7lxe6lBxCKFuK8nj/Hsw/r0HN8p5YRAN/v4hdCOweNMeYOUmg3DP3f/
	 b/vFGgt58Oo0Lv9RINnHuzUv+UZLfs1qdV7kGlH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 165/187] efivarfs: Fix memory leak of efivarfs_fs_info in fs_context error paths
Date: Tue, 22 Jul 2025 15:45:35 +0200
Message-ID: <20250722134351.920744753@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 64e135f1eaba0bbb0cdee859af3328c68d5b9789 ]

When processing mount options, efivarfs allocates efivarfs_fs_info (sfi)
early in fs_context initialization. However, sfi is associated with the
superblock and typically freed when the superblock is destroyed. If the
fs_context is released (final put) before fill_super is called—such as
on error paths or during reconfiguration—the sfi structure would leak,
as ownership never transfers to the superblock.

Implement the .free callback in efivarfs_context_ops to ensure any
allocated sfi is properly freed if the fs_context is torn down before
fill_super, preventing this memory leak.

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Fixes: 5329aa5101f73c ("efivarfs: Add uid/gid mount options")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/efivarfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 0486e9b68bc6e..f681814fe8bb0 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -387,10 +387,16 @@ static int efivarfs_reconfigure(struct fs_context *fc)
 	return 0;
 }
 
+static void efivarfs_free(struct fs_context *fc)
+{
+	kfree(fc->s_fs_info);
+}
+
 static const struct fs_context_operations efivarfs_context_ops = {
 	.get_tree	= efivarfs_get_tree,
 	.parse_param	= efivarfs_parse_param,
 	.reconfigure	= efivarfs_reconfigure,
+	.free		= efivarfs_free,
 };
 
 struct efivarfs_ctx {
-- 
2.39.5



