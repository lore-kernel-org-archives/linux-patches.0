Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E76813DB87;
	Tue, 27 Feb 2024 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040711; cv=none; b=OSgxj9nFvmfRtohsVMOycqgnzduVQedyNC/JwPOOJ7KDp1Ha7JfPO49oiv0eJ+YqkCzhkX9dadoKTXwdapcV4Kz0L8AEk9rEJYzEFbBi3hJrkvvVP1rpCzwTgTl3qQpG9Rb0dFVTeX1JTlCM3ahJEBA3cRp+bhao3S4EIeJeuZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040711; c=relaxed/simple;
	bh=HEGel3m930yuKF9vj1XxayOgFxkkdTrEc+UMeJPkt9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uObq9tSW+vgzqMFs40BBnygekWpxlvp3FIO2bpeGtzNYz4sp9S/Yia1Gperhmt1P2zKZr8DAPbb5ZwZ9bi36GULpJwuobVRaGvxKMt4eoeEPtAjsSiKLVgU11SmexgJxcE1FxFrW44kVC4dQqtCKGPKZOFFwk3bSsCf4FF/n6/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THNtgfDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THNtgfDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EE0C433C7;
	Tue, 27 Feb 2024 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040710;
	bh=HEGel3m930yuKF9vj1XxayOgFxkkdTrEc+UMeJPkt9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THNtgfDPJOCdQofztFBWk3PfSXBdtE4jhGHZEtmF7InqwKZsHO4uwsRS5gLCFVSPO
	 fDIqeiya05zYiQDsy7v8BMsEn87LAuEUDg6eeqPVevdtK4YF0aEwclIOoxgn7mueMM
	 m418b28SEc+6aBLb1oDiGW1y7pL8v9L1spUzMuhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 082/334] fs/ntfs3: Fix multithreaded stress test
Date: Tue, 27 Feb 2024 14:19:00 +0100
Message-ID: <20240227131633.180790862@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit a8b0c9fc3a2dba07f697ef7825e04363ff12f071 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 63f70259edc0d..4b78b669a3bdb 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -886,7 +886,7 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 	struct runs_tree *run = &ni->file.run;
 	struct ntfs_sb_info *sbi;
 	u8 cluster_bits;
-	struct ATTRIB *attr = NULL, *attr_b;
+	struct ATTRIB *attr, *attr_b;
 	struct ATTR_LIST_ENTRY *le, *le_b;
 	struct mft_inode *mi, *mi_b;
 	CLST hint, svcn, to_alloc, evcn1, next_svcn, asize, end, vcn0, alen;
@@ -904,12 +904,8 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 		*len = 0;
 	up_read(&ni->file.run_lock);
 
-	if (*len) {
-		if (*lcn != SPARSE_LCN || !new)
-			return 0; /* Fast normal way without allocation. */
-		else if (clen > *len)
-			clen = *len;
-	}
+	if (*len && (*lcn != SPARSE_LCN || !new))
+		return 0; /* Fast normal way without allocation. */
 
 	/* No cluster in cache or we need to allocate cluster in hole. */
 	sbi = ni->mi.sbi;
@@ -918,6 +914,17 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 	ni_lock(ni);
 	down_write(&ni->file.run_lock);
 
+	/* Repeat the code above (under write lock). */
+	if (!run_lookup_entry(run, vcn, lcn, len, NULL))
+		*len = 0;
+
+	if (*len) {
+		if (*lcn != SPARSE_LCN || !new)
+			goto out; /* normal way without allocation. */
+		if (clen > *len)
+			clen = *len;
+	}
+
 	le_b = NULL;
 	attr_b = ni_find_attr(ni, NULL, &le_b, ATTR_DATA, NULL, 0, NULL, &mi_b);
 	if (!attr_b) {
-- 
2.43.0



