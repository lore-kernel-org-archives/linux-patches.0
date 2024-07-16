Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97581DDCE;
	Tue, 16 Jul 2024 16:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146226; cv=none; b=MDAwx4WqQT61o/p9e0EF6943eP5ZIuY+QOGmgyH7pawFmqRAq5Cvx1jNLT8E70Qk95/Mz0p0URWKHx9CuVj2hxKOBzV8/0R2hbrUe1DrfjdfqtdJqesa6fahNDx3x6kFzkT361ELmzrVMyLbJsrnUcUg9lTU42vQ6mg3RE2Ibrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146226; c=relaxed/simple;
	bh=7Akd0BTzE7bseINOzphtCMbCGBfx4Aa2pCbAPKum7pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tK7T9cYMBATL0qSNSykeEQiFU4jRDKgPh2Ongup5vODl/dmZETOme0s3GG4/PjqAV3qVu1+neo3G6V6TkwpiDfiXUKqUkVDBtCueeH32AqI9+LYBr+OQ3u97URwJKpUI+oIOpSNUz6afZzwKlCFtlPkE3uqkO/h0uMvCD4LRmbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=to+/Iydl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="to+/Iydl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33085C116B1;
	Tue, 16 Jul 2024 16:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146226;
	bh=7Akd0BTzE7bseINOzphtCMbCGBfx4Aa2pCbAPKum7pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to+/IydlFjSTiesE5UefYMjEl3YjWiNpYOf1BfGVErFH3yzEvX23+F+9XjbgpavIG
	 XZcaapff+KDmleiGU/MYNz90xEQ9wT6VlLYQevvLJjTaprcfI3qB9g03XhAx8w5eD+
	 Oo9Lba2D8GJT5lXVNNYZQ8gTsLtbT70zucxTtwB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/144] fs/ntfs3: Mark volume as dirty if xattr is broken
Date: Tue, 16 Jul 2024 17:32:15 +0200
Message-ID: <20240716152755.085376405@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 24f6f5020b0b2c89c2cba5ec224547be95f753ee ]

Mark a volume as corrupted if the name length exceeds the space
occupied by ea.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index d0b75d7f58a7b..4a7753384b0e9 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -217,8 +217,11 @@ static ssize_t ntfs_list_ea(struct ntfs_inode *ni, char *buffer,
 		if (!ea->name_len)
 			break;
 
-		if (ea->name_len > ea_size)
+		if (ea->name_len > ea_size) {
+			ntfs_set_state(ni->mi.sbi, NTFS_DIRTY_ERROR);
+			err = -EINVAL; /* corrupted fs */
 			break;
+		}
 
 		if (buffer) {
 			/* Check if we can use field ea->name */
-- 
2.43.0



