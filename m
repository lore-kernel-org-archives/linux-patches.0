Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625051420B0;
	Tue, 27 Feb 2024 14:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043296; cv=none; b=MsJV92jWoYYT9UfSErZYui74Nk+iAnaKPvjXcvMTvw02pd/P9NPe8QwlI7Bj0TiAwzT799+suEQ9U0AQmWLRc3URWbBM6gKL1gpoC4JBC8+yOQ817TRPescOSetvftG+zRvbpEck3x2ZK2cGEewe9GyRcGeAfSGW2Z58YkDDWz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043296; c=relaxed/simple;
	bh=oWm53C/5ZteBUCxG1Ny6sy+a1cZlUdj0hc7pGYMr6xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=su3VuBoqWv11LzrT+jqVztK8d3C6BZvwFyvoTY+ra9eLpteEzRaJuPqka5OtmvFxzHNDAfKWwn8H19KKFjWCc0C/yzoMbEK+hmF1ajUDtgm87hk6iWjJ8pbw/PZ3xwATwLAxrAUP3vEHPYxdkHtheQU9sZc0+CZpXnFW+6ndnv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIsbrJah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIsbrJah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC63DC433C7;
	Tue, 27 Feb 2024 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043296;
	bh=oWm53C/5ZteBUCxG1Ny6sy+a1cZlUdj0hc7pGYMr6xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIsbrJahFtznrwXnjzen7F7ktLixHMzXmKW2Uats2ptfNPiCfCT5klVawikttloDL
	 Siv7SkP7xahYc5ndtsIkxRBEVh/hMxMcZu7W3yYEDJ0KIwsZLuSqUxJTKopQo03Vtx
	 Ulce7yKZNSQSY/lmZBOoujy9dqFKja6fzWVEyZ7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/195] fs/ntfs3: Correct hard links updating when dealing with DOS names
Date: Tue, 27 Feb 2024 14:25:17 +0100
Message-ID: <20240227131612.358995053@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1918c10e137eae266b8eb0ab1cc14421dcb0e3e2 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index ba336c7280b85..ab03c373cec66 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -491,8 +491,20 @@ bool mi_remove_attr(struct ntfs_inode *ni, struct mft_inode *mi,
 		return false;
 
 	if (ni && is_attr_indexed(attr)) {
-		le16_add_cpu(&ni->mi.mrec->hard_links, -1);
-		ni->mi.dirty = true;
+		u16 links = le16_to_cpu(ni->mi.mrec->hard_links);
+		struct ATTR_FILE_NAME *fname =
+			attr->type != ATTR_NAME ?
+				NULL :
+				resident_data_ex(attr,
+						 SIZEOF_ATTRIBUTE_FILENAME);
+		if (fname && fname->type == FILE_NAME_DOS) {
+			/* Do not decrease links count deleting DOS name. */
+		} else if (!links) {
+			/* minor error. Not critical. */
+		} else {
+			ni->mi.mrec->hard_links = cpu_to_le16(links - 1);
+			ni->mi.dirty = true;
+		}
 	}
 
 	used -= asize;
-- 
2.43.0



