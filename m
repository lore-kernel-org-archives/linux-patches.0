Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA5A46EC8F;
	Tue, 21 Jul 2026 18:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660381; cv=none; b=TZdeH4T8KuQZEmnpSCaShgyBmt3uY3duTBe654qAJ3r61TstdBPz7nyuW9LLzXofZBCnCxYk65YtqQcdIRx3unD6ZA1wSihCmy57+3vhmOiZHpsHw/gvu7CHdOd26UdD3qx8p/lQ1k990uSfLUQcN7j11f71zqknN3FEs5wBNto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660381; c=relaxed/simple;
	bh=4WStR1YXpe7RAbt8OeBhid3N3ew/qsrR9FQHrlwycwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeBbVJVXsl2HE6w9K5yKi8V9X0xHUp/bDRcSyAtJ0scrDEx6JmeJPdui/dL1aXs/YLGOb1Fy7JkFYdOf3AQ5xa+DgVLzHpK0ZmJZmbsUOmqRydNA+E6h48nHbq4/KfvSGu4/u8iXfPHf27iDNQiDNfDcNTc6bgq74FyKoKesHuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdmzrkW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdmzrkW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EEE1F00A3A;
	Tue, 21 Jul 2026 18:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660380;
	bh=Fs3MBCYXJSmQOI0VF5jeBE13hFOMZxUnOsZOKqSoUMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdmzrkW3UhZRI20Rz/rYxgW/ebZIcuhFs2uKE83EAGcK6tdtYa5JjXQR1k8mphB3q
	 f+y6MGPBWmR/MgVTx6vKUXUiqSj00vCAkkx5oZEqiN2wrBL/RmIMqo7HlHKjAtt+Z+
	 xkB0E2WBwkCj5Aqukevp47UONxzFSLJ6j1tgXhU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0921/2077] ntfs3: avoid another -Wmaybe-uninitialized warning
Date: Tue, 21 Jul 2026 17:09:54 +0200
Message-ID: <20260721152614.537182511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1bf15dd17385e3730521d17e9e158c475cd7474b ]

The ntfs3 specific -Wmaybe-uninitialized flag found one more false-postive,
this time with gcc-10 on s390:

fs/ntfs3/frecord.c: In function 'ni_expand_list':
fs/ntfs3/frecord.c:1370:16: error: 'ins_attr' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Add an explicit NULL pointer check before using the pointer, and
initialize it to NULL.

Fixes: 48d9b57b169f ("fs/ntfs3: add a subset of W=1 warnings for stricter checks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 78eb065c7e431b..bb3348f256d997 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1330,7 +1330,7 @@ int ni_expand_list(struct ntfs_inode *ni)
 {
 	int err = 0;
 	u32 asize, done = 0;
-	struct ATTRIB *attr, *ins_attr;
+	struct ATTRIB *attr, *ins_attr = NULL;
 	struct ATTR_LIST_ENTRY *le;
 	bool is_mft = ni->mi.rno == MFT_REC_MFT;
 	struct MFT_REF ref;
@@ -1363,7 +1363,7 @@ int ni_expand_list(struct ntfs_inode *ni)
 				      le16_to_cpu(attr->name_off), true,
 				      &ins_attr, NULL, NULL);
 
-		if (err)
+		if (err || !ins_attr)
 			goto out;
 
 		memcpy(ins_attr, attr, asize);
-- 
2.53.0



