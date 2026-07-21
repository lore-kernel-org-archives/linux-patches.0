Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A96F471257;
	Tue, 21 Jul 2026 19:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662273; cv=none; b=a6o5esEsHEow47+vXY4A7AEKNtAx04w6f9JzCkIL7rrkvt1d5KnJuwTG5KFjZBuxB416OpgYZX3QnGg04p9zyGQhOtO9KPS1i844uNmDJkfvhS6EOwOSYnDHx1kNASMYtKjjtKBdWE040CqbXLH027U+5YdLRt9YSKTDxE4bdeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662273; c=relaxed/simple;
	bh=QH6E5r/RnIOwCYwwzlDkcS2CK3H3IaDOWJecBu9VJUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llQZb75s62KWGbwQrQa+OwjhR1szuRR5L9o5G8S/a6UDd7nsMsDkA9o9+cb6K64RY85YZn85XnsE9djEpneU12waN7Hlz11csjctgl2SdI39yqbDk37n0cIbUz4UVnKhf5GeFIrlBJbnZmRFWDepeMYYu1Cy3xEM7bvlI+QC68E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPy+E0By; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPy+E0By"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E137B1F000E9;
	Tue, 21 Jul 2026 19:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662272;
	bh=gd1AcVfdzVEiVQQDs9Hui05WC+gon9p4INVjaFCtzRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPy+E0By12RFaH3epW5kwzswA/TSG0NRZ08/y2KMi2Ber0KrC8AJnVSOraH3ps1Cf
	 xQG0U1JcOozlH/FffeVvyVM+8kNtR5SC+LuRiAggxNAaXCAFCiDcqpbIcU8gCMI5/i
	 es4dVWxCMXbH8XXkd8KlyzHnHSE+T2gGphBgy3wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0383/1276] udf: fix nls leak on udf_fill_super() failure
Date: Tue, 21 Jul 2026 17:13:46 +0200
Message-ID: <20260721152454.675325564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 462bdd08fbdf41db223c6117d907c8fd68d666ea ]

On all failure exits that go to error_out there we have already moved the
nls reference from uopt->nls_map to sbi->s_nls_map, leaving NULL behind.

Fixes: c4e89cc674ac ("udf: convert to new mount API")
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 6104fb3594bdbb..c7c5fd45166b9e 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2331,7 +2331,7 @@ static int udf_fill_super(struct super_block *sb, struct fs_context *fc)
 
 error_out:
 	iput(sbi->s_vat_inode);
-	unload_nls(uopt->nls_map);
+	unload_nls(sbi->s_nls_map);
 	if (lvid_open)
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
-- 
2.53.0



