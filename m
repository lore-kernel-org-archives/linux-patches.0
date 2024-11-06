Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ACC18C00E;
	Wed,  6 Nov 2024 12:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896092; cv=none; b=U0ClBzo41nsTvw4qHGtCYFx5LFUVm8DRJd6h4Z25SPyctx/50uoA3pV4hqiuYYo+ydG1GGTIQsjgYG76xqfjOCQjqsqzpyYXKMGs6ddgm1QDWn43MOx1YvEjAoTKY/UQxd5xRmzIeT42+XWTWCj7pbqySnN1ifOsCh7H6dccGHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896092; c=relaxed/simple;
	bh=zQafidKhtClXxC/7g83eQ+ejngR46d79pRfwMKkrF/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOnZSNf+eDSsM1E8yPOLW9XPdN6II4xeRlVk0BvmpcTX/UmgpThpvs7yYWL7Yu1+nLY7MJ5+PSz0gEMEl1oTX0tBN2rFsDQ1yEA6aV8UjOS61d7dluNouWtUutiV/WZIO0/t6UgtdWy94KzFf7Zyr51Ke3MWl1ndA/+D96ngK1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/Ex/4Kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/Ex/4Kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD03DC4CECD;
	Wed,  6 Nov 2024 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896092;
	bh=zQafidKhtClXxC/7g83eQ+ejngR46d79pRfwMKkrF/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/Ex/4KbMjnGfH5mIWo658b6ECye7Yrw3EpKjKeIy2goKjqKbhGxaXrLWfLn+4GsY
	 KrB0lY7neSrfeVKXg5BAeZn6Vdy2Y0ZvfdUTZ3RGSOPrFIerBnCfB+itzZBfCItXfy
	 RDUD0j6qO7u14pngPpbIVDJKfeIJGmtqSkuKDrgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3bfd2cc059ab93efcdb4@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 088/245] fs/ntfs3: Additional check in ni_clear()
Date: Wed,  6 Nov 2024 13:02:21 +0100
Message-ID: <20241106120321.374632673@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d178944db36b3369b78a08ba520de109b89bf2a9 ]

Checking of NTFS_FLAGS_LOG_REPLAYING added to prevent access to
uninitialized bitmap during replay process.

Reported-by: syzbot+3bfd2cc059ab93efcdb4@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 60c975ac38e61..2a017b5c8101f 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -102,7 +102,9 @@ void ni_clear(struct ntfs_inode *ni)
 {
 	struct rb_node *node;
 
-	if (!ni->vfs_inode.i_nlink && ni->mi.mrec && is_rec_inuse(ni->mi.mrec))
+	if (!ni->vfs_inode.i_nlink && ni->mi.mrec &&
+	    is_rec_inuse(ni->mi.mrec) &&
+	    !(ni->mi.sbi->flags & NTFS_FLAGS_LOG_REPLAYING))
 		ni_delete_all(ni);
 
 	al_destroy(ni);
-- 
2.43.0



