Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8768B44AB98;
	Tue, 21 Jul 2026 21:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670893; cv=none; b=tp1uFBZn90nlIK/aXl6tKn5CctySstntUTUlQaqr7oTlFdXHgiqkXZCe6ySQ5hm9mTr2/KmBMD5/LwW0xoG9w5dH6GoGiWgVA6eVNFHl1LCNSA323QIb0ffPHBDk4qv93SADvDf4cje7NrNlvLFbuZc6c1DX4A9qm8Sf9h00Jyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670893; c=relaxed/simple;
	bh=1MAuAxENek2JlN0EiGp4gIe4kngEugOXG2s/S4SH6i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpzDpjQE81k/Y+zWcLUCr5vaHBGUkgXPknodiSJqDvWr5AgsHY/ocvD6qkKJQHDl2OwhDYiDqQsmaXY2vXiabRquWbeC+/Xy2EjRwZbTqZmAsJoM51y3egK/zUH5v74ZrANrd+7lsHsVXgaw3fYk/dndF4tMuqRRiPm3gO/FE7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8Pzmbjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8Pzmbjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34231F000E9;
	Tue, 21 Jul 2026 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670892;
	bh=Rij04f6TXSH0kS8SoagWFXO2cJCIvjyqWs33BXjs5z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8PzmbjpD6ofh84AO55PXFCvVCW850vTfep1razzk9H+7XQHLmuR13zFjsAXLtPIL
	 kiL/mXvx/uanwWICJ+9OxqG932L6+ENHX9O38WFoBpgSyjM/tEX6ehw5Mtj8Dt/Zxr
	 NCx9S6fjle0QyO5hHdn2xMFnEVoF2EvbqMy/nY3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Keshav Verma <iganschel@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/843] f2fs: fix listxattr handling of corrupted xattr entries
Date: Tue, 21 Jul 2026 17:14:28 +0200
Message-ID: <20260721152406.715413750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Keshav Verma <iganschel@gmail.com>

[ Upstream commit 5ef5bc304f23c3fe255d4936472378dcb74d0e94 ]

Validate the xattr entry before reading its fields in f2fs_listxattr().
Return -EFSCORRUPTED when the entry is outside the valid xattr storage
area instead of returning a successful partial result.

Fixes: 688078e7f36c ("f2fs: fix to avoid memory leakage in f2fs_listxattr")
Cc: stable@kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Keshav Verma <iganschel@gmail.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -579,8 +579,7 @@ ssize_t f2fs_listxattr(struct dentry *de
 	last_base_addr = (void *)base_addr + XATTR_SIZE(inode);
 
 	list_for_each_xattr(entry, base_addr) {
-		const struct xattr_handler *handler =
-			f2fs_xattr_handler(entry->e_name_index);
+		const struct xattr_handler *handler;
 		const char *prefix;
 		size_t prefix_len;
 		size_t size;
@@ -594,6 +593,7 @@ ssize_t f2fs_listxattr(struct dentry *de
 			goto cleanup;
 		}
 
+		handler = f2fs_xattr_handler(entry->e_name_index);
 		if (!handler || (handler->list && !handler->list(dentry)))
 			continue;
 


