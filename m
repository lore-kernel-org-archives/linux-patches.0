Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED2D1547F3;
	Mon, 14 Oct 2024 14:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915886; cv=none; b=OZNQkMkCfSEOZ2jSPAd+9ROUscJVYcFcEYP6v0ZJ0GWQ/HbZex2+jvOPCgvstw4rfyOgGCAqBgnvn+iG3C2T9gJBE+vHYxKF7ByOWP8MB9C7O8qj9owGrcKeC+1Ut3SpeUnf8/UQt/CUB0ptU6Fug3PdP95ZPdA0ZofCuOSRU7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915886; c=relaxed/simple;
	bh=FhVMr4apfiGxz5s23f/FwU6E8KAw1hT+k4U/JGWI8C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tbr1kuM0CLEmphkBpWuOQB6tcjAgUBH/BjrsS3dXP7WPgU7kYtD3JX1g0ucfLceXp9HzEHy8Fued+BN5AuDK5zuHEYzP/pKshRqR1+fs08ee5RGet5oje/a+1eYP7tlh7+8CdZLjrBwdjJ6d0cgVy8n8S0lNTRymJbam5nBTzOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRfLGcu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRfLGcu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB465C4CEC3;
	Mon, 14 Oct 2024 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915886;
	bh=FhVMr4apfiGxz5s23f/FwU6E8KAw1hT+k4U/JGWI8C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRfLGcu8R0p3TNkWMgnLIUKJJiR58/phg+pcdRkRDT/1SI7VEgIbkzDnxzzF0tnFi
	 NUPHmgnsQyxeirgiVVgTv7ggxNJqjTWsY9WrBZn0C2MxXSAJjpoiCmDqy5bbytmSfx
	 K04uIn+Z9KzFQAaZOCR3ws7ovbEW0wWGVBWZSt4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 007/214] fs/ntfs3: Refactor enum_rstbl to suppress static checker
Date: Mon, 14 Oct 2024 16:17:50 +0200
Message-ID: <20241014141045.279133666@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c64dd114ac652..d0d530f4e2b95 100644
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



