Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE6141988;
	Tue, 27 Feb 2024 13:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041804; cv=none; b=f+6t7Xvynz6JvKzR8lB7Oi5tOKgm7HYM0aE7UKxRlEmm+i8tF06E6+To+cy3pr+xFTcMXxuRNAiNjfuMBEEyWGFe4hl4fhpZEgqrIb6Ylt4U2bo3qq8ZJ9tE4DaXr+IT9ForGfplQlt9xZGc+yTzLNVRVEIjN5R15oYKu5nsP4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041804; c=relaxed/simple;
	bh=FIjyFLPtglGtUEizBJxRTOxcnfSzpYLS4EPyK9p39bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu4zzAMCyiygzopbR45zpcDDC6MLFl6rvhqHCuWO1p7mvUVSkEky2cAyQup3LDkipGpN6eg0vlCmse45b94FNyl+PQc+bdg1iKmOR0CKadxWzLN/ghHxBEfrWrTxPQWY+gUImWH7LQV5Jx0/hv5pWZYSG/j4PuOF1qgDyzDBzp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sx9nNWxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sx9nNWxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC34C433F1;
	Tue, 27 Feb 2024 13:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041804;
	bh=FIjyFLPtglGtUEizBJxRTOxcnfSzpYLS4EPyK9p39bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sx9nNWxm08dyrrmhUKx4FQpHpPf6PheCd42PbXEfkM4cEuqUmZPtXlDRGgFj1pUGU
	 qh+GA4O9bRW2Ym02OR5VJCLffUriekiy7wp5txB3jxQnUC1PrNDT8D0rv5tPyItbh3
	 S56QPX1XaTv6SmoLO5NFOBpLLwUDxja2gNTJzvMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/299] fs/ntfs3: Fix multithreaded stress test
Date: Tue, 27 Feb 2024 14:23:07 +0100
Message-ID: <20240227131628.381334081@linuxfoundation.org>
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



