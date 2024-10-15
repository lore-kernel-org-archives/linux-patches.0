Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F711C57B1;
	Tue, 15 Oct 2024 12:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994050; cv=none; b=GUMMOvZ73LwJfKipYrl8CyTo04CkrlodLVM/+ads5yHbvA65i5CSHLNnJps3eykaWDbVWYXzIbxvPXc+T/vofM6ejUACc9CwARFXnlTy0ASzaHWREf16DFP8O2iarrqXNWQ/VfWeRNt1YcD3yO9vRtJovuji9i+Rn8T43M8dtus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994050; c=relaxed/simple;
	bh=M+qaTeB3TJZB44PWHG9y6wp7LhhgoBZqOpIKL6V0wO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vl8moP18dhtP+D/FPOzBxdkNenCAmDDnwo5iX52uxKt1EVkqv36Z8Pjs/spODEdAJ5Vtr9dXoJ4zPIu4dCzekD6yBzmirNVSWCYZ+xHR07GXYW6kXkpzVQMMX09jQLUMZ+lYpqeIK9zRdHpeqlJp1FE2n4CwImsfc7GwfYiFb6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L434mAo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L434mAo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C20EC4CEC6;
	Tue, 15 Oct 2024 12:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994050;
	bh=M+qaTeB3TJZB44PWHG9y6wp7LhhgoBZqOpIKL6V0wO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L434mAo2VT+KLxTeLhsaZExPLizEAFYOGFgH/ZyTj7GQ1DsNjZBSk2dcDFvu6OsB2
	 8hg3s/bnRBVryimKxvPyHZCyhoM7oLpUQaNZZYlAXkTlOzeRH8FPDUJnxf/3fsD/4Q
	 KFMO+RyHaWGq5bNGDNJ/qBwInBxDOIrJyaABqdy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 593/691] fs/ntfs3: Refactor enum_rstbl to suppress static checker
Date: Tue, 15 Oct 2024 13:29:01 +0200
Message-ID: <20241015112503.882793256@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ba4dc7385b446..6fddedca71f32 100644
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



