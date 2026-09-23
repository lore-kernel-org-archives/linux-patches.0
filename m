Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22CF3A6F1C;
	Wed, 23 Sep 2026 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172997; cv=none; b=nsRTLs3lXMwGHgONEU5ssl9yClTfdUrn7laENe/DJXsB9qeBxvzmXKmt1ZQltM7ijv5jxAZNb4iEzBsHiVTB+mnze8+rRzSe6VLylaa2pU4+sRLe0959xgZi2xyrt9XKL5ZVC6N9buHZbXNjUtShTM2Cw8Wgg+lCgZZU53L57Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172997; c=relaxed/simple;
	bh=xnnO9STuAOGoqdCvYQHv0pQHDdzF8nWHJqgf7KQUjw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEvD46zlAdqrmhayQ+pvRvfe0HguJYKaXhyY/GyMOyDxA4ttAPANAaCB7J7piN9ITuzgCzTPQ0sG4DmlXKATX2SQOrGIPEhQXWPF7wjyrgxf5Zi9auHEslTwJIfFXpAnNExlHmFQiYvcIldm2Fy64GznVmvd7CCsZXup/EsKm+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Co8Dl7NI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Co8Dl7NI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318741F000FF;
	Wed, 23 Sep 2026 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172995;
	bh=0Ow5HmhDUZB5oJ+xzO9oW6mfzO7Bj7bcvw3XOYeECno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Co8Dl7NIeYJRfloxt8THNGVOo0WzV4cR2jMgcc4J2AuRt/2R4yPNFRqS+9wwjM97X
	 Fqbdx0Ke6tFN8TLyta2Ot/KZPTxOBZp010gDwpbxU4shvCwx0dFV12VIfU/sZpZ4C6
	 YzOc9Cc21tjRhNIXesNhnYmFMraovIVv2zozCWA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 124/438] ntfs: propagate folio errors
Date: Wed, 23 Sep 2026 16:02:25 +0200
Message-ID: <20260923140647.993637736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1923eeffa63edeff427d76fc302bc5eb835771ce ]

Return the error from __filemap_get_folio() instead of replacing it
with -ENOMEM.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 560f1dd1fba39..b6e161d51dce2 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -3713,7 +3713,7 @@ static s64 __ntfs_inode_non_resident_attr_pwrite(struct inode *vi,
 					FGP_CREAT | FGP_LOCK,
 					mapping_gfp_mask(mapping));
 			if (IS_ERR(folio)) {
-				ret = -ENOMEM;
+				ret = PTR_ERR(folio);
 				break;
 			}
 		} else {
-- 
2.53.0



