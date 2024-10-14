Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30801AB528;
	Mon, 14 Oct 2024 14:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916728; cv=none; b=JqBabBR+344EmSmL2OzpqPuWXnBx4Ku17m35wx2ue4xmxWl74C0DhTfE5ncJpSIKDpjt27MckdurxffxBhbn46cfjc8cWaK7HyCTH7qESFoC/cDfoiPjajNmiQLwOHf+lXUwIiffUXXEgAMvqq/U2BpzSFQbm6Wi5OCiY/YPkkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916728; c=relaxed/simple;
	bh=zvcYChbHS/g/NdedPpMo8GNo822BkbbeHhmCN425n14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6+1OLU8eoYGKlrvEMhbPbsPR6tGzW80B0qiQGohffQSDytkK26GiDB1Ok/FPKLYpblhabPJ+gIU5JhTF2SQjwoDjAygSmwCs6d8Scpmg00iUDARnip7HWC04eGu3ziQWCI1fRrw/cXh1iw7eyPX9BbqpbLHulDxG2XQ9+jsMUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xz71NY/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xz71NY/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3265AC4CEC3;
	Mon, 14 Oct 2024 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916728;
	bh=zvcYChbHS/g/NdedPpMo8GNo822BkbbeHhmCN425n14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xz71NY/SmlY46HXcSTYNyS2oWFD6igDIK+mPgUNlU9mygo5fa1Gx6n+spyEL4o9o4
	 hirUznY7BroRs60Oe26a0tzMXMHVgcL6dPcjmP6BIEydzWVD5zBWmhv/6BgwoEtTMB
	 w4lGqWy2ujF/LChjn3d5gVHhZmssxpwK+/cg/sHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/213] fs/ntfs3: Refactor enum_rstbl to suppress static checker
Date: Mon, 14 Oct 2024 16:19:16 +0200
Message-ID: <20241014141044.945754560@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 231b012fb19d3..2a1aeab53ea4b 100644
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



