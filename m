Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ED113B797;
	Tue, 27 Feb 2024 13:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041824; cv=none; b=FTov3OmFqoYoGU0NLbSESQRkpk2sMbWwAtSXPQE9H2OFnwKcp24QMnzqVj4SgO0+05MlFAj/O3ZkG+Mz+Ss0dLNgrPALBX13NhaAOAa2oiPs1x4JsTms5qg/1UN+DYLxrbaYzau600odpD7o05/jnVYR6tz8ft0LWUFFZhboXrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041824; c=relaxed/simple;
	bh=T1+Tksmcsv9DtaIO5vcaXWMwhnR6X6vQDQOsVtp0iVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC56nU1cmzLfkc9ErA8Bkml6zbI6YGwKVyPhQGes/mektNxtzUCi3l+j15PqQRDK7K5Szjw/u7zOOizKifHRhmlzQQxiI62PQZnM2mtdbkPyvpFscJcJ4pn1D7g7Dt8Su/1fbv1tTIXaXtgbbeNvAIWuVbG1BVzqgXZTmf7P+iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5R20++d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5R20++d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93BDC433F1;
	Tue, 27 Feb 2024 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041824;
	bh=T1+Tksmcsv9DtaIO5vcaXWMwhnR6X6vQDQOsVtp0iVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5R20++dfvKboRLxQsXwe93Iq5h9/bBFinCOby443KClwV4h5jGHXI27poHW1bCpB
	 e2LkIoc4NAdAbOaHuNJCBNmZAPBfr4cnb9eteNEbUGeRgYEDpYoaWVlfGoQXn2vmFZ
	 XXDwy/Oxx/lsKDD+/oHyl9TrYsM9bgfd8s7FR0VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/299] fs/ntfs3: Add NULL ptr dereference checking at the end of attr_allocate_frame()
Date: Tue, 27 Feb 2024 14:23:13 +0100
Message-ID: <20240227131628.562842444@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

[ Upstream commit aaab47f204aaf47838241d57bf8662c8840de60a ]

It is preferable to exit through the out: label because
internal debugging functions are located there.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 4b78b669a3bdb..646e2dad1b757 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1743,8 +1743,10 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
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
@@ -1825,13 +1827,15 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
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



