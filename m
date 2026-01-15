Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A242874E6;
	Thu, 15 Jan 2026 17:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497538; cv=none; b=mU5LmOwJ8Of3fbzrXMxJmWNAJxV3m9s3kP2Txfd2tJ/AW8jGbDJ3wVphqJJhePEMcO8HOwEtr0dV+2WXnZA46LymVfoahC8wpDQz7poA5Q3sqLkhwNGtjMtjgHcydwKdaYl8+eiPWcY4TtqUFVv+J75twhb7H464oDej6Zv9Meo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497538; c=relaxed/simple;
	bh=s1IL4A7wsf8ReH0Fa0/ep0VSmcffUyWCoCIlUc7HA9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRb8Tz0TAqKZ1fm9hhgltnDKveDVBrRftn+gKLl9Y+wzB43ARPlUHc6WVjzPeV74bJfSBBXqXK84vbGrtY1XqiypT+lyMU2T/L4Zwn5CQYItaPZbUbhaacWQrKOl47RpTfvmuxBEv78JemKLzhXr6k08NhCc56A3W+naLf0NUi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amYKnCwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amYKnCwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3502C116D0;
	Thu, 15 Jan 2026 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497538;
	bh=s1IL4A7wsf8ReH0Fa0/ep0VSmcffUyWCoCIlUc7HA9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amYKnCwG7+L/i1EaWim/lAAiWdHRP9Mh2+1iOlr/P0vm3BRk0PJVhpNqeDPwwp487
	 EpLz5NE9UFzBjK3EvPr+xZ6r9aIn9b/DiSJQukM6Kdp2paBt5A8D+d/ww3lSjmNcQV
	 a4p4JeZKghtnL6tzuLcBYOjmdtyTA5szHWHFpf5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/554] fs/ntfs3: Make ni_ins_new_attr return error
Date: Thu, 15 Jan 2026 17:43:02 +0100
Message-ID: <20260115164250.451634690@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 451e45a0e6df21e63acfd493feb5194f4697ce11 ]

Function ni_ins_new_attr now returns ERR_PTR(err),
so we check it now in other functions like ni_expand_mft_list

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 4d78d1173a65 ("fs/ntfs3: out1 also needs to put mi")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index b5f3e7bc5d6da..4db52dfde6328 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -470,7 +470,7 @@ ni_ins_new_attr(struct ntfs_inode *ni, struct mft_inode *mi,
 				&ref, &le);
 		if (err) {
 			/* No memory or no space. */
-			return NULL;
+			return ERR_PTR(err);
 		}
 		le_added = true;
 
@@ -1000,6 +1000,8 @@ static int ni_ins_attr_ext(struct ntfs_inode *ni, struct ATTR_LIST_ENTRY *le,
 				       name_off, svcn, ins_le);
 		if (!attr)
 			continue;
+		if (IS_ERR(attr))
+			return PTR_ERR(attr);
 
 		if (ins_attr)
 			*ins_attr = attr;
@@ -1021,8 +1023,15 @@ static int ni_ins_attr_ext(struct ntfs_inode *ni, struct ATTR_LIST_ENTRY *le,
 
 	attr = ni_ins_new_attr(ni, mi, le, type, name, name_len, asize,
 			       name_off, svcn, ins_le);
-	if (!attr)
+	if (!attr) {
+		err = -EINVAL;
 		goto out2;
+	}
+
+	if (IS_ERR(attr)) {
+		err = PTR_ERR(attr);
+		goto out2;
+	}
 
 	if (ins_attr)
 		*ins_attr = attr;
@@ -1034,7 +1043,6 @@ static int ni_ins_attr_ext(struct ntfs_inode *ni, struct ATTR_LIST_ENTRY *le,
 out2:
 	ni_remove_mi(ni, mi);
 	mi_put(mi);
-	err = -EINVAL;
 
 out1:
 	ntfs_mark_rec_free(sbi, rno, is_mft);
@@ -1090,6 +1098,11 @@ static int ni_insert_attr(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	if (asize <= free) {
 		attr = ni_ins_new_attr(ni, &ni->mi, NULL, type, name, name_len,
 				       asize, name_off, svcn, ins_le);
+		if (IS_ERR(attr)) {
+			err = PTR_ERR(attr);
+			goto out;
+		}
+
 		if (attr) {
 			if (ins_attr)
 				*ins_attr = attr;
@@ -1187,6 +1200,11 @@ static int ni_insert_attr(struct ntfs_inode *ni, enum ATTR_TYPE type,
 		goto out;
 	}
 
+	if (IS_ERR(attr)) {
+		err = PTR_ERR(attr);
+		goto out;
+	}
+
 	if (ins_attr)
 		*ins_attr = attr;
 	if (ins_mi)
@@ -1302,6 +1320,11 @@ static int ni_expand_mft_list(struct ntfs_inode *ni)
 		goto out;
 	}
 
+	if (IS_ERR(attr)) {
+		err = PTR_ERR(attr);
+		goto out;
+	}
+
 	attr->non_res = 1;
 	attr->name_off = SIZEOF_NONRESIDENT_LE;
 	attr->flags = 0;
-- 
2.51.0



