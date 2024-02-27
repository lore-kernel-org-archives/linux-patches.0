Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A174A13B29C;
	Tue, 27 Feb 2024 14:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043304; cv=none; b=CMTAElJRsoIL/zbOuPy+fq5r7Vc2F8/3XT7vKA6jCIIWAiSx/yCI7UVcvXvgYCyt+8mfUivdFNLOg22qqGlM2eGapqrOCd7xO5xjWcqwcXzwE2Svq4dq5CD3ykqZSAYo+Ri1DXWYuzb5DDnXseaNZsZtTDrtnpfvPaMyK9Ocn54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043304; c=relaxed/simple;
	bh=BgJ1K2YcIamc3YaaUhLY9wxN376E3CTUPrPYcAlNN2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qzt8GDG9byXj3rrj5oKLu4PcsY7070Rh3j9j+B1OM+xYhK7DDy+X1yfpdRUSF/F2E9gjHlDjVEAI53umEtvFRmgkOmYwUUXFpWT3WTeCaZgkGvsXyOyLz0zOTtV1KJ5v4rKBITZUnMahNIJMDMUrcTLriAwJr9/AstLJQQD8QEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saXRkmJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saXRkmJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D25C433C7;
	Tue, 27 Feb 2024 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043304;
	bh=BgJ1K2YcIamc3YaaUhLY9wxN376E3CTUPrPYcAlNN2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saXRkmJs7vTBxvUNo6BkeD0pbOwLg3RiwFETYCVAaMSbmXeneGJCB5j+BtfcsyUtV
	 dwz6f74HN1gTviOJZt1skMSUZ78kHtUPF0fdnALrJtvuyloMpQO3ukvAcNcDRsCjof
	 R4rXN+ejCnlMZwLBAm1MLxULQwav++H5Ptw+b+/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/195] fs/ntfs3: Add NULL ptr dereference checking at the end of attr_allocate_frame()
Date: Tue, 27 Feb 2024 14:25:20 +0100
Message-ID: <20240227131612.455446248@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

[ Upstream commit aaab47f204aaf47838241d57bf8662c8840de60a ]

It is preferable to exit through the out: label because
internal debugging functions are located there.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 2215179c925b3..2618bf5a37892 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1658,8 +1658,10 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 			le_b = NULL;
 			attr_b = ni_find_attr(ni, NULL, &le_b, ATTR_DATA, NULL,
 					      0, NULL, &mi_b);
-			if (!attr_b)
-				return -ENOENT;
+			if (!attr_b) {
+				err = -ENOENT;
+				goto out;
+			}
 
 			attr = attr_b;
 			le = le_b;
@@ -1740,13 +1742,15 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 ok:
 	run_truncate_around(run, vcn);
 out:
-	if (new_valid > data_size)
-		new_valid = data_size;
+	if (attr_b) {
+		if (new_valid > data_size)
+			new_valid = data_size;
 
-	valid_size = le64_to_cpu(attr_b->nres.valid_size);
-	if (new_valid != valid_size) {
-		attr_b->nres.valid_size = cpu_to_le64(valid_size);
-		mi_b->dirty = true;
+		valid_size = le64_to_cpu(attr_b->nres.valid_size);
+		if (new_valid != valid_size) {
+			attr_b->nres.valid_size = cpu_to_le64(valid_size);
+			mi_b->dirty = true;
+		}
 	}
 
 	return err;
-- 
2.43.0



