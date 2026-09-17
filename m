Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664A65476C2;
	Thu, 17 Sep 2026 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658812; cv=none; b=Ion4r3zD4/zreAnj2uDvbH3Nu0tFV7Y9Z9Q6iiZ67qac+Vgkbe6BbFRjYcZCAGLTxBGNgfJszxJ/rmmRUNtQeO92T/4zmNyaI7SqYXOdQBJY2rOJnMGPnKqc83Yiw4GYhKH/bQ5mAmOwuex5bwgjAOO7VAqmlPb5jlcckvkV6r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658812; c=relaxed/simple;
	bh=CgVjA6eIIvq/OdBk5BD+MKZ2eZb1jy0ZCCzTujwGQLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQVS3VP881ignD3rI23i5pvUa8tufE4SSN8B5ACZPwUnAr7mb14vY5c1CZZV8xaq7yWiD95Mj8KGiCzojkiznix1G8vpLDqbefG4hqiVvaxuBbmmv6v5x/gXvKdvONqeOYidVDC+fE4Qu7lWKMZXdOG5apDKOBJ6bEADTXdgbfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynoJLo6o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynoJLo6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381581F000FF;
	Thu, 17 Sep 2026 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658802;
	bh=5gQ/wBOeElCDKw2P0VQT3hHv1pIFOCfNsmSfegIP1Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynoJLo6oXUju8YGvg1P1II+vpLN43FzIAp+MhhgUXYdG1rkXdN/xalRxlOBknqyL9
	 PQNZ/Qg21H9PDiZFBeNw++zpo7ega8kdSNGbxPvQqWEWV1U090dBj8X2lTVXDcPZdO
	 boQOZyGpiNOHybO1ifjx5+PCwZahUIQIK+X4RPoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 037/733] ntfs: return DT_UNKNOWN on inode lookup failure in readdir
Date: Thu, 17 Sep 2026 16:05:45 +0100
Message-ID: <20260917151351.669865397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 3d3de2aee17d1431694aa085039479b5679e5ad4 ]

ntfs_reparse_tag_dt_types() returns PTR_ERR(vi) when ntfs_iget()
fails, but its return type is unsigned int and the caller passes
the value straight to dir_emit() as d_type. A stale or corrupt MFT
reference in a directory index thus makes readdir report a garbage
d_type value to userspace.

Return DT_UNKNOWN on lookup failure instead.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/reparse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/reparse.c b/fs/ntfs/reparse.c
index fa523dc3691ea..f2377e3a56ca9 100644
--- a/fs/ntfs/reparse.c
+++ b/fs/ntfs/reparse.c
@@ -332,7 +332,7 @@ unsigned int ntfs_reparse_tag_dt_types(struct ntfs_volume *vol, unsigned long mr
 
 	vi = ntfs_iget(vol->sb, mref);
 	if (IS_ERR(vi))
-		return PTR_ERR(vi);
+		return DT_UNKNOWN;
 
 	reparse_attr = (struct reparse_point *)ntfs_attr_readall(NTFS_I(vi),
 			AT_REPARSE_POINT, NULL, 0, &attr_size);
-- 
2.53.0



