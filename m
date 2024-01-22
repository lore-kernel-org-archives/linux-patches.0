Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A722414831B;
	Tue, 23 Jan 2024 00:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969150; cv=none; b=lA/xkV2GxrbDCienS7AOLiklbMm4xiApjAtyNAyIPQeZX3c0uScUUmXKrzSRDCgSdwuUiAspzBYLTHWvho0Og+gqAuoSh2LVm1tsJsdt/AMlqJatzk2s43Bv7lC9Gq43oh+LQt7D3vxZajcorIjRLut6bf+6yXri61HUSYQqLjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969150; c=relaxed/simple;
	bh=lSa549Agya2RzPAy3u1Rl8Fn/ND9POz4jn12wfzlcLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmcRqaNaxoYeEVrdPIH1ylyp40463XGpsqUlZwK87IiROkyhVKEQqFVDr8gjWVlI1lwvErOGW8OJ42kp6YEZo2duZzZB37qEAFiI1qiv/FEVSyoPtudumIWAPbq1TkZPbgmHRHt1LXp2jttEEb5+twFR48rzqgLQSIUNtdmjUbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVjo2kc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVjo2kc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FE5C43390;
	Tue, 23 Jan 2024 00:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969150;
	bh=lSa549Agya2RzPAy3u1Rl8Fn/ND9POz4jn12wfzlcLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVjo2kc+QaIs1b7mg6YA7wqmDzRxzlIgIAQ/yxCw0pvKn3X80O3yvqDXj0YR6WIXW
	 Ntdo18RT9cICrm1Xszeb00wz1rA2KuhQ+Zw9+PH3Nb+jpvYhA3NZRTFWHaOFzRukJ3
	 /D6OyqLshhh72MhGq5azA3YSod1qfigZU149HIuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 032/641] efivarfs: Free s_fs_info on unmount
Date: Mon, 22 Jan 2024 15:48:56 -0800
Message-ID: <20240122235819.088992468@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 547713d502f7b4b8efccd409cff84d731a23853b ]

Now that we allocate a s_fs_info struct on fs context creation, we
should ensure that we free it again when the superblock goes away.

Fixes: 5329aa5101f7 ("efivarfs: Add uid/gid mount options")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/efivarfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 869537f1a550..edf29c15db77 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -368,6 +368,8 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 
 static void efivarfs_kill_sb(struct super_block *sb)
 {
+	struct efivarfs_fs_info *sfi = sb->s_fs_info;
+
 	kill_litter_super(sb);
 
 	if (!efivar_is_available())
@@ -375,6 +377,7 @@ static void efivarfs_kill_sb(struct super_block *sb)
 
 	/* Remove all entries and destroy */
 	efivar_entry_iter(efivarfs_destroy, &efivarfs_list, NULL);
+	kfree(sfi);
 }
 
 static struct file_system_type efivarfs_type = {
-- 
2.43.0



