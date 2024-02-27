Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BDF13A87C;
	Tue, 27 Feb 2024 13:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040824; cv=none; b=sF7y5It0R+3MS6AUor24N3v9X/mOh0lQWM0LkN6bRVe60GpGxI41ZkIEytv/WEgGOOmZAdmrKnQc/YE8Tac2mJHDJ0+zRHBgH1DZ27T0bZUdGLD3a4yYZA1K9zZ0YsPQlKTUlAHQjv2vsQ6G4ahGa3tRIceObp6Y5Y8r6Kb3o7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040824; c=relaxed/simple;
	bh=3QCQMnoKrHWXMWWAJb+qbarYLGrAP5j9OAeEAsTIBZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXwqw6DKnvhISpVTZvi+Ru/3OsqYjsECEwdYRtqAX3zygVRGs2OnDneycOPHGNCk+cQzUd8ienMngpxwkfymCfE3G5xUmSv6FB/d/E9lBiEeSXY8J4fPWWvU0ZGXbs3A/X/70vkXR/6LQa6joNEmDofFLNyalgl96oWpI/IyiE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJ0QAkVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJ0QAkVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93A6C433F1;
	Tue, 27 Feb 2024 13:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040824;
	bh=3QCQMnoKrHWXMWWAJb+qbarYLGrAP5j9OAeEAsTIBZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJ0QAkVbx7vUFFt/HabsOFpNmbnP0eTrCXIPJ3HpiZiSLUIZLjjk7TBPMIMp2MP8e
	 OIXYvv66bUS1Jv1L47clq6HteDOXhMjBfm4ED3iVJCMxjnHoWH2ogx4H2FpkZuN/hv
	 q3fU62Ko+6UOrH1qO5+1CP/wDCpoD63dOyhbQpgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 092/334] fs/ntfs3: Disable ATTR_LIST_ENTRY size check
Date: Tue, 27 Feb 2024 14:19:10 +0100
Message-ID: <20240227131633.483529883@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 4cdfb6e7bc9c80142d33bf1d4653a73fa678ba56 ]

The use of sizeof(struct ATTR_LIST_ENTRY) has been replaced with le_size(0)
due to alignment peculiarities on different platforms.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312071005.g6YrbaIe-lkp@intel.com/
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrlist.c | 8 ++++----
 fs/ntfs3/ntfs.h     | 2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/attrlist.c b/fs/ntfs3/attrlist.c
index 7c01735d1219d..48e7da47c6b71 100644
--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -127,12 +127,13 @@ struct ATTR_LIST_ENTRY *al_enumerate(struct ntfs_inode *ni,
 {
 	size_t off;
 	u16 sz;
+	const unsigned le_min_size = le_size(0);
 
 	if (!le) {
 		le = ni->attr_list.le;
 	} else {
 		sz = le16_to_cpu(le->size);
-		if (sz < sizeof(struct ATTR_LIST_ENTRY)) {
+		if (sz < le_min_size) {
 			/* Impossible 'cause we should not return such le. */
 			return NULL;
 		}
@@ -141,7 +142,7 @@ struct ATTR_LIST_ENTRY *al_enumerate(struct ntfs_inode *ni,
 
 	/* Check boundary. */
 	off = PtrOffset(ni->attr_list.le, le);
-	if (off + sizeof(struct ATTR_LIST_ENTRY) > ni->attr_list.size) {
+	if (off + le_min_size > ni->attr_list.size) {
 		/* The regular end of list. */
 		return NULL;
 	}
@@ -149,8 +150,7 @@ struct ATTR_LIST_ENTRY *al_enumerate(struct ntfs_inode *ni,
 	sz = le16_to_cpu(le->size);
 
 	/* Check le for errors. */
-	if (sz < sizeof(struct ATTR_LIST_ENTRY) ||
-	    off + sz > ni->attr_list.size ||
+	if (sz < le_min_size || off + sz > ni->attr_list.size ||
 	    sz < le->name_off + le->name_len * sizeof(short)) {
 		return NULL;
 	}
diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index c8981429c7213..9c7478150a035 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -527,8 +527,6 @@ struct ATTR_LIST_ENTRY {
 
 }; // sizeof(0x20)
 
-static_assert(sizeof(struct ATTR_LIST_ENTRY) == 0x20);
-
 static inline u32 le_size(u8 name_len)
 {
 	return ALIGN(offsetof(struct ATTR_LIST_ENTRY, name) +
-- 
2.43.0



