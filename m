Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E8A54FA5;
	Tue, 27 Feb 2024 13:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040703; cv=none; b=MinE1s0o4C6hLvuAQy9Amb6ofKYpp+rNFG6nitl7FZCR2f38q1XEXwIaum8vqNxu8V3nuJgvJ8TIwadlrWZDone745Ld4dljgZPl0Vvz/MrC/ZUkP8j6JHghPCFUr5EjjurnluHYzNgKG9UnxnWtdiIutgY2EUvcb4OTqhOknGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040703; c=relaxed/simple;
	bh=uXGKQ/YdkFHOuqLXrQkWgqIvW8UHHhlCoTmmVsok4s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmR8L3FmuzaW+5fNgJpOC5VXWR5g8FghN8c0dhnRIHL1S+8b577FQoRWLZENaVusnMl42zfqaD9yIpmhT9KiLFvzbSrOJHJUL0Mvw03Se2XBtePk+R0piOKKnJ/h+r5faMdJPYcxBmhMs/wBAZRhcAPsqaYyX4xEXgPmYY41GqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiZ1w6QP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiZ1w6QP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD3BC433C7;
	Tue, 27 Feb 2024 13:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040702;
	bh=uXGKQ/YdkFHOuqLXrQkWgqIvW8UHHhlCoTmmVsok4s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiZ1w6QPyiSfulSiS8mEi1fUtZZWRlEU1aSNafITi2lkfaz9IllmGd1qTKMWMcKbN
	 GC4eKPsWgl0SXPsq143GfIQQu5fQdCuqYDYI2tdlDj9Qp2c0eTGwLdCsXf9sXMB7yx
	 Pwt1lUtQpuvVNL4VmuqoJaLSQ9kJX8rJ3CIed2Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 079/334] fs/ntfs3: Correct hard links updating when dealing with DOS names
Date: Tue, 27 Feb 2024 14:18:57 +0100
Message-ID: <20240227131633.090373177@linuxfoundation.org>
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

[ Upstream commit 1918c10e137eae266b8eb0ab1cc14421dcb0e3e2 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 53629b1f65e99..7b6423584eaee 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -535,8 +535,20 @@ bool mi_remove_attr(struct ntfs_inode *ni, struct mft_inode *mi,
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



