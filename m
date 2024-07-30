Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E91C1A76A0;
	Tue, 30 Jul 2024 17:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359638; cv=none; b=MXCOlaouG0dYXOu0BQ4MGo+kuAlwSL85sXyx01SuKurFafBWHWvQqx7115uUiVHwLIN1KrGANxW4ENUk/ppcByHhrFJQDdryrziZNKMOEPVct0EYPjPa66QjrR/XoI36jaPcJStoe6ZT937HgIor1sLuQOBB5xEgdw/TrirRNT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359638; c=relaxed/simple;
	bh=nM7r5b+qaJfPiqYGOJ9hlhJGMUxSUnjASup3w7P7cUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKDvMy77egLt0jLz2nQmsRzOfvhgYRDiRa4bGScivbaO3CFwagdBa5iTEBqZK6Kec1Qgy2mPKVFyOscJ58SDlvBl+SdNMMXz4+J9z6+7WMH2S8a4xiZ23s3QfWwEsXtFM9r6Si2A5BJs+UDNolv9w2lo/pUejJsfErJsVLZgivE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mp0tK6zK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp0tK6zK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C10C32782;
	Tue, 30 Jul 2024 17:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359638;
	bh=nM7r5b+qaJfPiqYGOJ9hlhJGMUxSUnjASup3w7P7cUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mp0tK6zKRK39UnRmTwzNQX+72BOCgNLT322iOGueYlldjeWKp2xJefyvMXLh3jTyc
	 hDxsfN/3pL0unTPbTKkOo7fdQKwKxsyITdMF364Ep8AR+YRHYxZSRUpguy2qlbAJDC
	 uLBOkVRWcT1f7GC+g7dgnZEEDVzhLs6r3x9VmVlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 489/809] fs/ntfs3: Add missing .dirty_folio in address_space_operations
Date: Tue, 30 Jul 2024 17:46:05 +0200
Message-ID: <20240730151744.052829982@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 0f9579d9e0331b6255132ac06bdf2c0a01cceb90 ]

After switching from pages to folio [1], it became evident that
the initialization of .dirty_folio for page cache operations was missed for
compressed files.

[1] https://lore.kernel.org/ntfs3/20240422193203.3534108-1-willy@infradead.org

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 8521238f5448e..bef3b4a36b750 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -2133,5 +2133,6 @@ const struct address_space_operations ntfs_aops = {
 const struct address_space_operations ntfs_aops_cmpr = {
 	.read_folio	= ntfs_read_folio,
 	.readahead	= ntfs_readahead,
+	.dirty_folio	= block_dirty_folio,
 };
 // clang-format on
-- 
2.43.0



