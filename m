Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DED223DC0;
	Mon,  2 Jun 2025 15:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877402; cv=none; b=CHSB1MlHpkaXVYX44MBmti7WzWYyEqqEWGYKCTNVxB3l13bAGc1LDZJw3jPL1wb7cguNOo558uInOcnkvxMb9JMScwmkvMKowUm8wxhR/T6V2YCGZPiZdCxR8AV3L0hdP04IjgahS08VifEM5Ju7DoTbS2QBBM+pmjclvJl2fKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877402; c=relaxed/simple;
	bh=wjKW0aKeiGT0Hf9ErfxOK7KIxrdbCRtoBzIl674UZeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3KH1G5UmNwDdFBifflvEfAm5pgC57nO8XrcFmtbFccRKMKSZTHw+6hPgsswGoM3iktSK8fXZ7gbPtjsDB16p8X0UUnUcqKxfmj27BjLWuSXybePgq1CiweFKWG+Kbi0R65QrvOUJauSevbcxJASpSscczy67WyvoBPQGMZr9yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h36evT7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h36evT7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E9CC4CEEB;
	Mon,  2 Jun 2025 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877401;
	bh=wjKW0aKeiGT0Hf9ErfxOK7KIxrdbCRtoBzIl674UZeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h36evT7u4H8Ij6EkzX7v8o5R0ffQ8Vg1b4AcUviqeWbHhWjWii5i7Sj/BHqHa5dRr
	 okYF5leXLkV3CyS8e2fMe9UmlmmklVcA6AYyavlb+05TrvYEs3yP9KwWHfkTCkhyoQ
	 Fpe7TXZB9umDdEkUpacf8JvIfxk6T2WoYLbqXIPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 266/325] ksmbd: fix stream write failure
Date: Mon,  2 Jun 2025 15:49:02 +0200
Message-ID: <20250602134330.583712381@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1f4bbedd4e5a69b01cde2cc21d01151ab2d0884f ]

If there is no stream data in file, v_len is zero.
So, If position(*pos) is zero, stream write will fail
due to stream write position validation check.
This patch reorganize stream write position validation.

Fixes: 0ca6df4f40cf ("ksmbd: prevent out-of-bounds stream writes by validating *pos")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index cf1b241a15789..fa647b75fba8a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -423,10 +423,15 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	ksmbd_debug(VFS, "write stream data pos : %llu, count : %zd\n",
 		    *pos, count);
 
+	if (*pos >= XATTR_SIZE_MAX) {
+		pr_err("stream write position %lld is out of bounds\n",	*pos);
+		return -EINVAL;
+	}
+
 	size = *pos + count;
 	if (size > XATTR_SIZE_MAX) {
 		size = XATTR_SIZE_MAX;
-		count = (*pos + count) - XATTR_SIZE_MAX;
+		count = XATTR_SIZE_MAX - *pos;
 	}
 
 	v_len = ksmbd_vfs_getcasexattr(user_ns,
@@ -440,13 +445,6 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 		goto out;
 	}
 
-	if (v_len <= *pos) {
-		pr_err("stream write position %lld is out of bounds (stream length: %zd)\n",
-				*pos, v_len);
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (v_len < size) {
 		wbuf = kvzalloc(size, GFP_KERNEL);
 		if (!wbuf) {
-- 
2.39.5



