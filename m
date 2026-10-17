Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89239391E51;
	Sat, 17 Oct 2026 17:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257030; cv=none; b=EUbtpNuxuOTUKzTe/BKcgJx7NCNI3Y3mXiE0ILrVGaRiRg9HLo9BV9bq9gonhNQLKtzTBTMvgVW3rSC5/cWfDvnLW+lDiDf8rXqZoMmA9ULHnrmDskpc0y0S69HDhj2njaO7myzDR2eSFLHQ3svlCEI8UVQwMt41lg92ybq0r7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257030; c=relaxed/simple;
	bh=lIwO/4qGNpWEUnEMZaZSo1nxsvs0C19mWwCue4b3TNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miRXR1K0JFdGqdt93O7FflulZ9W5SvCS6ooGAOHqt7EuqNPoKSwZFdC1STVXwwuXGinV7NwP45SPgvl1oSt/QGrheLjbv8BZKIMj27tGogeeWC/Nm14XPWaeFg4BshX5T08oQtyPtqmc1ATeW+W64+rNl+QRj0BZsq1HAlkk5DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbsWg+yj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbsWg+yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9631F000C4;
	Sat, 17 Oct 2026 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257029;
	bh=349+q5EZoEgNIh4kPdy/752JwUqepBGvSGG17YYP4hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rbsWg+yjBtSsiFSkUhPgJHiu/8QRI0hTRdSz3oDjw0scufkItR2j95OZsuzFcyJBQ
	 uVm2BM+CES7++hUOOPWE2Gga3Wi5ziXH2gJeKKUfAt2l9/KZbDhWCNQm8DK1UPFctR
	 U3+Vvf1/VUl442oReQm3K7uYt0NtxQRFkpZ0MGNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0427/1674] jbd2: check need_resched() when skipping busy checkpoint buffers
Date: Sat, 17 Oct 2026 17:44:59 +0200
Message-ID: <20261017160442.087842835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit f213e12ff5c9590b1034ae8da0e6d09665c772d0 ]

journal_shrink_one_cp_list() skips busy checkpoint buffers when called
with JBD2_SHRINK_BUSY_SKIP.  The continue statement on this path also
skips the need_resched() check at the end of the loop body.

Consequently, when a checkpoint list contains mostly busy buffers, the
shrinker can walk the entire list while holding journal->j_list_lock,
even when a reschedule has been requested.  Large checkpoint lists under
memory pressure can therefore cause long lock hold times and leave other
CPUs spinning on j_list_lock, resulting in soft lockups or RCU stalls.

Route the busy-buffer path through the need_resched() check so that the
shrinker can release j_list_lock and reschedule promptly, restoring
parity with the clean-buffer path, which already checks need_resched().
This does not change which checkpoint buffers are eligible for removal.

[ Backport to 6.6.y: Use this tree's older shrink_type enumerator names
  while routing busy buffers through the existing reschedule check. ]

Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260713102229.1598812-2-max.kellermann@ionos.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/checkpoint.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 32ed28cfb3a0b..e8a7186eb8c36 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -391,7 +391,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 			ret = jbd2_journal_try_remove_checkpoint(jh);
 			if (ret < 0) {
 				if (type == SHRINK_BUSY_SKIP)
-					continue;
+					goto next;
 				break;
 			}
 		}
@@ -402,6 +402,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 			break;
 		}
 
+next:
 		if (need_resched())
 			break;
 	} while (jh != last_jh);
-- 
2.53.0



