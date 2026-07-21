Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6183F2101;
	Tue, 21 Jul 2026 18:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660036; cv=none; b=fkwvRQID2MUH8u4aOqIEBM8d17ZO4vrwbQb8V9gQgltY3YG0VXY1Aqomn01B5VIAnh2qWqdC4H65YPGVqVVCsZXWraFFMZ2398PG4uJNppNGbaATLB/AtpTjAYW1SwwL+tUCA8cdEYTxmeCkiLRgAiG+UNqujXi0TARwf5faoV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660036; c=relaxed/simple;
	bh=9g71YkM/F/bCJRtvueo6JtBxipllP5Y5KJiLrKKKZ8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8TDve3Uu7hmgmRwduWlSEFcQcbprfI+NAwYT/sageWKuCBGVdUqXizcsdhsITvkOFaW+MpgpEWZriZNkqgBAkKwQHBqbLda6zqOWrdXpzZQLY5dbyQ0WQLsNeoF8GbZa/acSLVin69wyEbXIQDjSynYbKN5BlORUo1GEGby65s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cn3zXrS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cn3zXrS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADEE1F000E9;
	Tue, 21 Jul 2026 18:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660035;
	bh=oYHdzTGlu9+Nyswthwv8SB6lsvaaaK9pz68fdcg+0Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cn3zXrS6QYTxtsjSyXYYGO8Nh7ehpWvKe39RmCdUYoEF1qVhW4rqVfRXdrTySBr1M
	 IWmb+GUQPbKBQ1hoOGQYNJnGqP9AtJBOLPblzsts9mKqieaHpeZoHseWrE0JK+RATC
	 VJhW5Haa+g0HzmDPCamG6FWnqwGzprEav/6i+X+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0784/2077] udf: fix nls leak on udf_fill_super() failure
Date: Tue, 21 Jul 2026 17:07:37 +0200
Message-ID: <20260721152611.288199099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1b5282790de6f0..f5328c0084dca9 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2330,7 +2330,7 @@ static int udf_fill_super(struct super_block *sb, struct fs_context *fc)
 
 error_out:
 	iput(sbi->s_vat_inode);
-	unload_nls(uopt->nls_map);
+	unload_nls(sbi->s_nls_map);
 	if (lvid_open)
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
-- 
2.53.0



