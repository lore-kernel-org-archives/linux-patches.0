Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2767A25F97B;
	Tue,  8 Apr 2025 12:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115758; cv=none; b=gAI/nAPaveLE3mDc8cDuTeRO7Z6g9xlODfoJscJ3RNBq5l8YNXj+6RvsJEjK/eFAECshlHONf6RBv0A66mvmKOYpn8+spjmvN9mWy1U+I7uHmZZHWvM2aFD+mjeiNUomOcocnpfFK/wH0fR9X3g5tCzsOI/QcPnrPxizkrMLaTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115758; c=relaxed/simple;
	bh=QjDzZMRfnfKATs+4vKZZdb0tbk34RM2BT7FG1uVAkhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzaY2DOR+Ngiu4wz8fT/8kmbvC0wRgQmcrIwFfqZOcg0XEgp6zpgZQHwUHGedAp8Jk9Diu9xnE4q3f/RtjUM950lL+foJ/pN6uuZQK1+FSr0y/E5gcyzhQzq+agluzHKXye7N57BXWxm5mEnRTDLQVN1mUT/YmWvbmKcz9Aw/fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4x43b3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4x43b3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE49C4CEE5;
	Tue,  8 Apr 2025 12:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115758;
	bh=QjDzZMRfnfKATs+4vKZZdb0tbk34RM2BT7FG1uVAkhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4x43b3yIfZd2nlNvUvti9PgaavyY0B+Q+uv0Kamhbngg7UQ2n0sx+o/lhBoOx47/
	 M/pnsxnIQCaeweMQpJBTbZomVMWSg2JRuJgzjYBznXKkTGpMXaeBJSsPgqM4XxBcY3
	 frQpEXy9qhlLwOeTSmQHpd0OjP72vfTrIXtoO+bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/204] fs/ntfs3: Fix a couple integer overflows on 32bit systems
Date: Tue,  8 Apr 2025 12:50:23 +0200
Message-ID: <20250408104823.073219749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5ad414f4df2294b28836b5b7b69787659d6aa708 ]

On 32bit systems the "off + sizeof(struct NTFS_DE)" addition can
have an integer wrapping issue.  Fix it by using size_add().

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 2dfe74a3de755..139bdaececd72 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -617,7 +617,7 @@ static bool index_hdr_check(const struct INDEX_HDR *hdr, u32 bytes)
 	u32 off = le32_to_cpu(hdr->de_off);
 
 	if (!IS_ALIGNED(off, 8) || tot > bytes || end > tot ||
-	    off + sizeof(struct NTFS_DE) > end) {
+	    size_add(off, sizeof(struct NTFS_DE)) > end) {
 		/* incorrect index buffer. */
 		return false;
 	}
@@ -736,7 +736,7 @@ static struct NTFS_DE *hdr_find_e(const struct ntfs_index *indx,
 	if (end > total)
 		return NULL;
 
-	if (off + sizeof(struct NTFS_DE) > end)
+	if (size_add(off, sizeof(struct NTFS_DE)) > end)
 		return NULL;
 
 	e = Add2Ptr(hdr, off);
-- 
2.39.5



