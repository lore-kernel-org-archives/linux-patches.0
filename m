Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411E1156256;
	Mon, 14 Oct 2024 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919702; cv=none; b=X/ubVi0CYU4gens5hCSPGfbAelesOnCuusa9muYX6bk00GAtbEefrrqGc6MKbn3rbykwHg4YCfBcaroXmSasATVJNla6m4jEKGh4Wnm4JQQ6KEacvm+19RBG79knYC2BVQ2gIfcBS5FW3K/YzK6b+8Z63SrfCQXrISlurkawB+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919702; c=relaxed/simple;
	bh=3FAebbm7bt4M9E03ngKCfijbViHwGDCS1A+Nt4sVGJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyi+d89xQ08YgntLtIq4I7BZATICVAUkgsXi9AD6IxtpmUYJRnDy3m7JkxFTWD0fxmlHJjrI3dlleZwwXqwM75rx0ec/x2kjnasiYxhaEnuGooUvGCNDW064A1ANa57fKyzFGLoIx8O7dXIOL6YRGFTL0UbZ/Afy316o1y7TOPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVEWjXgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVEWjXgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6F5C4CEC3;
	Mon, 14 Oct 2024 15:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919702;
	bh=3FAebbm7bt4M9E03ngKCfijbViHwGDCS1A+Nt4sVGJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVEWjXgu8yj5DNkyMp/zOOqen89GJkke9zUpv1ub96FsJe36eALqhgloRoQYNYATs
	 +g8f7dJvl59S0tLf5/2T6fgzGZSHmMu8VJLcdjcXfWAAcm4t8vMO8p522uAFWY3xDo
	 m90OB5ahdoPQuuYTuurbLJrzeQ+z2rc6+YeCH7rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 683/798] fs/ntfs3: Refactor enum_rstbl to suppress static checker
Date: Mon, 14 Oct 2024 16:20:37 +0200
Message-ID: <20241014141244.902470130@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

[ Upstream commit 56c16d5459d5c050a97a138a00a82b105a8e0a66 ]

Comments and brief description of function enum_rstbl added.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 8e23bd6cd0f2f..339ce5aa3c75b 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -609,14 +609,29 @@ static inline void add_client(struct CLIENT_REC *ca, u16 index, __le16 *head)
 	*head = cpu_to_le16(index);
 }
 
+/*
+ * Enumerate restart table.
+ *
+ * @t - table to enumerate.
+ * @c - current enumerated element.
+ *
+ * enumeration starts with @c == NULL
+ * returns next element or NULL
+ */
 static inline void *enum_rstbl(struct RESTART_TABLE *t, void *c)
 {
 	__le32 *e;
 	u32 bprt;
-	u16 rsize = t ? le16_to_cpu(t->size) : 0;
+	u16 rsize;
+
+	if (!t)
+		return NULL;
+
+	rsize = le16_to_cpu(t->size);
 
 	if (!c) {
-		if (!t || !t->total)
+		/* start enumeration. */
+		if (!t->total)
 			return NULL;
 		e = Add2Ptr(t, sizeof(struct RESTART_TABLE));
 	} else {
-- 
2.43.0



