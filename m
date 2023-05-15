Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B2BFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81943C433D2;
	Mon, 15 May 2023 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169921;
	bh=3y7O2X8OhDEjW1aSCmpk6EqsYbOaQkWKclk50bssoOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuynoCDR+g7o9i6nnZoIrLKw2otkXnkfbsjurtC4Ddibqz4kI2bLUgOlg3Ft9DYx9
	 hpV5ydrjLUbKrkP6nDfIOzc3Yka4SAJdTIa/HSjG9Rux6dWbP7NURSewlfVCvi+rD9
	 dd6mec1o0UxE+S+xBL2jRGQu61uwHU/j/K8PBI6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Rudi Heitbaum <rudi@heitbaum.com>
Subject: [PATCH 6.3 212/246] fs/ntfs3: Refactoring of various minor issues
Date: Mon, 15 May 2023 18:27:04 +0200
Message-Id: <20230515161728.958144421@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 6827d50b2c430c329af442b64c9176d174f56521 upstream.

Removed unused macro.
Changed null pointer checking.
Fixed inconsistent indenting.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Rudi Heitbaum <rudi@heitbaum.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/bitmap.c  |    3 ++-
 fs/ntfs3/frecord.c |    2 +-
 fs/ntfs3/fsntfs.c  |    6 ++++--
 fs/ntfs3/namei.c   |    2 +-
 fs/ntfs3/ntfs.h    |    3 ---
 5 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -658,7 +658,8 @@ int wnd_init(struct wnd_bitmap *wnd, str
 	if (!wnd->bits_last)
 		wnd->bits_last = wbits;
 
-	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS | __GFP_NOWARN);
+	wnd->free_bits =
+		kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS | __GFP_NOWARN);
 	if (!wnd->free_bits)
 		return -ENOMEM;
 
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1645,7 +1645,7 @@ struct ATTR_FILE_NAME *ni_fname_name(str
 {
 	struct ATTRIB *attr = NULL;
 	struct ATTR_FILE_NAME *fname;
-       struct le_str *fns;
+	struct le_str *fns;
 
 	if (le)
 		*le = NULL;
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2594,8 +2594,10 @@ static inline bool is_reserved_name(stru
 	if (len == 4 || (len > 4 && le16_to_cpu(name[4]) == '.')) {
 		port_digit = le16_to_cpu(name[3]);
 		if (port_digit >= '1' && port_digit <= '9')
-			if (!ntfs_cmp_names(name, 3, COM_NAME, 3, upcase, false) ||
-			    !ntfs_cmp_names(name, 3, LPT_NAME, 3, upcase, false))
+			if (!ntfs_cmp_names(name, 3, COM_NAME, 3, upcase,
+					    false) ||
+			    !ntfs_cmp_names(name, 3, LPT_NAME, 3, upcase,
+					    false))
 				return true;
 	}
 
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -93,7 +93,7 @@ static struct dentry *ntfs_lookup(struct
 	 * If the MFT record of ntfs inode is not a base record, inode->i_op can be NULL.
 	 * This causes null pointer dereference in d_splice_alias().
 	 */
-	if (!IS_ERR(inode) && inode->i_op == NULL) {
+	if (!IS_ERR_OR_NULL(inode) && !inode->i_op) {
 		iput(inode);
 		inode = ERR_PTR(-EINVAL);
 	}
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -435,9 +435,6 @@ static inline u64 attr_svcn(const struct
 	return attr->non_res ? le64_to_cpu(attr->nres.svcn) : 0;
 }
 
-/* The size of resident attribute by its resident size. */
-#define BYTES_PER_RESIDENT(b) (0x18 + (b))
-
 static_assert(sizeof(struct ATTRIB) == 0x48);
 static_assert(sizeof(((struct ATTRIB *)NULL)->res) == 0x08);
 static_assert(sizeof(((struct ATTRIB *)NULL)->nres) == 0x38);


