Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB3A1A0DD5;
	Thu,  6 Jun 2024 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683679; cv=none; b=fntvQiRnlLccEI3pi3tWQR8nChVFxCu5bRz9RQOofU3ke+DFjmxoROZmjBmFaWX5/JsTjYvm21qbo7qAZeSj5qpTJ2FyigTWxMrOTvFjQdVHGmE46KZdp9OaUbg03FEkvDFKyJIcHHRuwTsORLn7Lwlx7PKM+vo6MfRoqBNXUt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683679; c=relaxed/simple;
	bh=IkStDNhKf7GNSBkM8M7wcQCubzUa/bRFTJNBunYH+hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQuLUUcnYY/zLEj+FlwMnOi+5wVOlM8+dnUf8A98b+CMkY6CxMfkZtE7JUmCX87Dmj8ydlvM8YxjtGlOVypdk3TH7yKX5QtNGUIVSFRroEefwxi77o7PcxulxjO6ig+L+mbEoFo1H5XYbUNN2DkQ095BN6N3F34lgH9bkE8hCJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtWY71+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtWY71+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD45C32781;
	Thu,  6 Jun 2024 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683679;
	bh=IkStDNhKf7GNSBkM8M7wcQCubzUa/bRFTJNBunYH+hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtWY71+5LQ9LrbtxAIRbRRG4XvypigV99f5o3ZhMoTpoSBHN/5+hcKJSXEKYhDj+X
	 A0kWfhTvwC9BjOolslVijO042H9jHf5pjGr8RSr6vREdxwq1i3qYU9pDQnQW8ju6pJ
	 AjyDxIweZ9dT+G0kLpcEjK0dw27c5RDYpjuKkdsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 579/744] fs/ntfs3: Check folio pointer for NULL
Date: Thu,  6 Jun 2024 16:04:11 +0200
Message-ID: <20240606131751.029092580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1cd6c96219c429ebcfa8e79a865277376c563803 ]

It can be NULL if bmap is called.

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index be8c8e47d7e27..6af705ccba65a 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -571,13 +571,18 @@ static noinline int ntfs_get_block_vbo(struct inode *inode, u64 vbo,
 	clear_buffer_uptodate(bh);
 
 	if (is_resident(ni)) {
-		ni_lock(ni);
-		err = attr_data_read_resident(ni, &folio->page);
-		ni_unlock(ni);
-
-		if (!err)
-			set_buffer_uptodate(bh);
+		bh->b_blocknr = RESIDENT_LCN;
 		bh->b_size = block_size;
+		if (!folio) {
+			err = 0;
+		} else {
+			ni_lock(ni);
+			err = attr_data_read_resident(ni, &folio->page);
+			ni_unlock(ni);
+
+			if (!err)
+				set_buffer_uptodate(bh);
+		}
 		return err;
 	}
 
-- 
2.43.0



