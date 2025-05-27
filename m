Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C5F1E89C;
	Tue, 27 May 2025 17:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366331; cv=none; b=t+xJajXE2ho0oVgVJs/2yX68ULRJxGiWTkNnabmO90itUxfYntNTgUJbmnIG0SIR6bmo3y631Kj0BEDaJvS4cImBwQD8ZwXmI+2ywRMP1D4HBo9zWDtDLJg7tE26nn4JMoeV5kfLKtIXlsFrT1JHBVuqkGp0cwFwt2QL/Zw+VaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366331; c=relaxed/simple;
	bh=M6g/MEftlvbOQSkl2Ct2IjlIpgsCax6JgxOC5kMtVTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rueNc3M/l4t5a1eyk4JQp1t8isiHLQiJ1pXP6fFAptff1oZ6517IJuyGohX4SKUdrzogWSQtZs8Qvqvi97+dNWHfH0I10ZoZ+Fhc/kzBvYA2l7q+8DWpeEdbh++xoo4O1YaLkRIggw+yY2Flfv1JcDiStvmDsV2TEOlLd/O7l/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RM8HX7AH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RM8HX7AH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19A9C4CEE9;
	Tue, 27 May 2025 17:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366331;
	bh=M6g/MEftlvbOQSkl2Ct2IjlIpgsCax6JgxOC5kMtVTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RM8HX7AHqzX4hhXlqhn+VaewJ/yw5L0Td+XmExtYKB3WvyUe5JvEzhLKScevrr1wQ
	 /pJpgycuZEI7ZM9QNeXGPVB0u12fQ0/pZX7vPQbdmNkCeNGTfUnMUhqHiqn3Z8z98A
	 0gQtbt1bs4u/8aLJX3DUyx1N47+Do/aGiyBxqodY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	kdevops@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 034/783] fs/jbd2: use sleeping version of __find_get_block()
Date: Tue, 27 May 2025 18:17:11 +0200
Message-ID: <20250527162514.512383120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit f76d4c28a46a9260d85e00dafc8f46d369365d33 ]

Convert to the new nonatomic flavor to benefit from potential
performance benefits and adapt in the future vs migration such
that semantics are kept.

- jbd2_journal_revoke(): can sleep (has might_sleep() in the beginning)

- jbd2_journal_cancel_revoke(): only used from do_get_write_access() and
    do_get_create_access() which do sleep. So can sleep.

- jbd2_clear_buffer_revoked_flags() - only called from journal commit code
    which sleeps. So can sleep.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-6-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/revoke.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index ce63d5fde9c3a..f68fc8c255f00 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -345,7 +345,8 @@ int jbd2_journal_revoke(handle_t *handle, unsigned long long blocknr,
 	bh = bh_in;
 
 	if (!bh) {
-		bh = __find_get_block(bdev, blocknr, journal->j_blocksize);
+		bh = __find_get_block_nonatomic(bdev, blocknr,
+						journal->j_blocksize);
 		if (bh)
 			BUFFER_TRACE(bh, "found on hash");
 	}
@@ -355,7 +356,8 @@ int jbd2_journal_revoke(handle_t *handle, unsigned long long blocknr,
 
 		/* If there is a different buffer_head lying around in
 		 * memory anywhere... */
-		bh2 = __find_get_block(bdev, blocknr, journal->j_blocksize);
+		bh2 = __find_get_block_nonatomic(bdev, blocknr,
+						 journal->j_blocksize);
 		if (bh2) {
 			/* ... and it has RevokeValid status... */
 			if (bh2 != bh && buffer_revokevalid(bh2))
@@ -466,7 +468,8 @@ int jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	 * state machine will get very upset later on. */
 	if (need_cancel) {
 		struct buffer_head *bh2;
-		bh2 = __find_get_block(bh->b_bdev, bh->b_blocknr, bh->b_size);
+		bh2 = __find_get_block_nonatomic(bh->b_bdev, bh->b_blocknr,
+						 bh->b_size);
 		if (bh2) {
 			if (bh2 != bh)
 				clear_buffer_revoked(bh2);
@@ -495,9 +498,9 @@ void jbd2_clear_buffer_revoked_flags(journal_t *journal)
 			struct jbd2_revoke_record_s *record;
 			struct buffer_head *bh;
 			record = (struct jbd2_revoke_record_s *)list_entry;
-			bh = __find_get_block(journal->j_fs_dev,
-					      record->blocknr,
-					      journal->j_blocksize);
+			bh = __find_get_block_nonatomic(journal->j_fs_dev,
+							record->blocknr,
+							journal->j_blocksize);
 			if (bh) {
 				clear_buffer_revoked(bh);
 				__brelse(bh);
-- 
2.39.5



