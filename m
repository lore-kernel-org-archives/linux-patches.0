Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E0747125B;
	Tue, 21 Jul 2026 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656845; cv=none; b=KRcPYDhhEJcJ9swL30hGPd9wmk+y5i5kmG9pv6/DolJ2IiqQjorJek6YGCmRwAX+4BGXOlu1mghuYHjXaYGWyNqU8YYzcnxyGfknef/+2IhcTJG4vuq0MrlvSPCDbwUSl4VTXbrXoYsS3uRuBQhJNRoe2y5hBJvfXFdwaUzcwLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656845; c=relaxed/simple;
	bh=79DXlx5+vlqDFhnepKMvenj2MNdFSRPtsg8ZlRYVB08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTPKUNJK/iw4opzq8DhfxXsZzcLow3FRb2H0WNdwRd8LTWg+4uPeQpBMp/WvJY6QaAfkQtQo6jP8okv0q2kp3E8zGPCTXH0Zq59l9piOYpOmwZ0ENfMxnhfHjETuiiB85N8HOYic2Fgh+7epS9E1lzUJxlX3JmWLdFr+iyjE5Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM0uyRF+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM0uyRF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5003A1F000E9;
	Tue, 21 Jul 2026 18:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656843;
	bh=j9/5DWDNaE6MhB24h0SKQPddeVFACe/y3Ieu/naopXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LM0uyRF+PI1KtUq6qnv7I0xdmm/uppcazByv1LM6RH5gjmG2EdnlExu7uVh4u5Krm
	 Udr+5K68BW1p1b7IHy39u5hJ4RZ/zgBr1HXBEZp1TOnMsU2YnvfOhW4RA29QV19K47
	 cIDYr67hHFICsLl5+MgyhUKSqVV+Kph3EGbZbxKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0540/1611] udf: fix nls leak on udf_fill_super() failure
Date: Tue, 21 Jul 2026 17:10:56 +0200
Message-ID: <20260721152527.509473798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 62a311d88f2d6b..5a82ae2af93ec8 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2329,7 +2329,7 @@ static int udf_fill_super(struct super_block *sb, struct fs_context *fc)
 
 error_out:
 	iput(sbi->s_vat_inode);
-	unload_nls(uopt->nls_map);
+	unload_nls(sbi->s_nls_map);
 	if (lvid_open)
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
-- 
2.53.0



