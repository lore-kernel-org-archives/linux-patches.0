Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC194347503;
	Wed,  8 Apr 2026 18:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671907; cv=none; b=jIrHIIgvXm6PCIYF0ENguLcFffMWE545N6mqRvPugyDT49yqSfFB2qdAX3B78eAapwD0DoYgNyLp72HjyPNb4MoThTU1WDb8c6bnMH02T49N1bbqrpwN6dR5i9gV8GCay6gui9Qn/eKnjGysF4zkg36TjyiFKJ7lt3p/mG0Pg7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671907; c=relaxed/simple;
	bh=AdbUi1IASMt3MCX5DhdCMXWxxM/cgtOLoghetB6lc1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtQgmVN7cATmLMfVbnC18Z6B9yHch9KbmUNcKJRdBgx69qEFudG89Fsb7Mg7vllFWBYofPWLknu3PGZeSFJoYhHDBIq4W1wVShddNItxiEtM2ucYog72dK3q1Xvuax+2nLLt31vi3vIS/KuRi4j3C+5jC5TcmOvolJcaO3zjTHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuoZq/kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuoZq/kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404CCC19421;
	Wed,  8 Apr 2026 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671907;
	bh=AdbUi1IASMt3MCX5DhdCMXWxxM/cgtOLoghetB6lc1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuoZq/kgcRruftL7BVtfVPOeMhHg6C2xg78ZlspHbECVf3+zotyO2OtqPaE6Lo8JY
	 a+lGd3ODeOS+d6WpoNgvbplOxtxKBfQb0v+KfV54a8XprfSgqETQdyf8n1jMPOLTL3
	 vbQVLzpTE5EyS0Guw15YX9u9dHMBB1m05M7fgHPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 114/312] ext4: make recently_deleted() properly work with lazy itable initialization
Date: Wed,  8 Apr 2026 20:00:31 +0200
Message-ID: <20260408175938.028746246@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit bd060afa7cc3e0ad30afa9ecc544a78638498555 upstream.

recently_deleted() checks whether inode has been used in the near past.
However this can give false positive result when inode table is not
initialized yet and we are in fact comparing to random garbage (or stale
itable block of a filesystem before mkfs). Ultimately this results in
uninitialized inodes being skipped during inode allocation and possibly
they are never initialized and thus e2fsck complains.  Verify if the
inode has been initialized before checking for dtime.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260216164848.3074-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ialloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -687,6 +687,12 @@ static int recently_deleted(struct super
 	if (unlikely(!gdp))
 		return 0;
 
+	/* Inode was never used in this filesystem? */
+	if (ext4_has_group_desc_csum(sb) &&
+	    (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT) ||
+	     ino >= EXT4_INODES_PER_GROUP(sb) - ext4_itable_unused_count(sb, gdp)))
+		return 0;
+
 	bh = sb_find_get_block(sb, ext4_inode_table(sb, gdp) +
 		       (ino / inodes_per_block));
 	if (!bh || !buffer_uptodate(bh))


