Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23B3448D03;
	Tue, 21 Jul 2026 21:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671060; cv=none; b=lSvs2EWxKc30xR9bUwUfLxlSY2g3OYPFSWBjcLnG4ppZ1bzTJJfw9o1d+WEwAI0XNeRVD5LelA/qjQ1RdY67lacwTeUUYLvJBjYk45oJfEmBM47mG2jiK2YVYMWiQ0CQ/CRlGMWh0dZ/1kRO7rwGxPilf6oGC6cMV1/fNWT6AwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671060; c=relaxed/simple;
	bh=Hc2XQ1hp4Dd2tkvXshZEzbhz1isQHLtgl1NETZegLW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlnlUuyOr3ZuTZmaA78r1agQ70yErKdjlAF3KZJQ/omdDQfHKSJV5I2COxv1tJOxm3zsjAkUCDGuLey5mTEUg4iEUYdi1Jo4HXNjEhFecB9qTEIDl5H8c1nl/cWl6ImZ0+6VXPYm7ciZO/MT4wyGafwf77/0KQZaiFK9mKL1Lbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oy/cG7f5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oy/cG7f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D17E1F00A3A;
	Tue, 21 Jul 2026 21:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671058;
	bh=41g0qsXL0i+PwotshQK4pNrYDwjg50bEJKFrUkVeoHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oy/cG7f5lDc6V2htiUAes8bARWEOAU+hNR78QBS1N9EL0k7GUa2S6M80/4hL4X8OK
	 nBOlurqCm7v6qj/BzMJe7+WqhmIHzQFx+zBvqVgqdmaW0vub8SmE5BijDhWouUzI2h
	 b5/f9zc8fMyKhbJTPewasmbLycmcvfQ1LSknyAiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunpeng Tian <shionthanatos@gmail.com>,
	Mingda Zhang <npczmd@qq.com>,
	Gongming Wang <gmwgg05@gmail.com>,
	Peiyuan Xu <paulbucket12@gmail.com>,
	Qinrun Dai <jupmouse@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 103/843] fs/ntfs3: validate Dirty Page Table capacity in log_replay copy_lcns
Date: Tue, 21 Jul 2026 17:15:38 +0200
Message-ID: <20260721152408.317854300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunpeng Tian <shionthanatos@gmail.com>

commit 57382ec6ac63b63dce2789e835fded28b698ae79 upstream.

In the analysis pass of $LogFile journal replay, log_replay() copies
LCNs from each action log record into an existing Dirty Page Table
(DPT) entry without bounding the destination index. A crafted NTFS
image with DPT entry lcns_follow=1 and an action log record with
lcns_follow=2 produces a kernel slab out-of-bounds write at mount
time:

  BUG: KASAN: slab-out-of-bounds in log_replay+0x654c/0xdb60
  Write of size 8 at addr ffff8880095e1040 by task mount

Two attacker-controlled fields can drive j+i past the allocated
page_lcns[] array:

  1. dp->lcns_follow (capacity) can be smaller than lrh->lcns_follow.
  2. lrh->target_vcn may be smaller than dp->vcn, making the u64
     subtraction wrap to a huge size_t.

Validate target VCN delta and per-record LCN count against the
DPT entry capacity, bail via the existing out: cleanup label with
-EINVAL.

This mirrors the bounds-check pattern added in commit b2bc7c44ed17
("fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot")
and commit 0ca0485e4b2e ("fs/ntfs3: validate rec->used in
journal-replay file record check").

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Reported-by: Yunpeng Tian <shionthanatos@gmail.com>
Reported-by: Mingda Zhang <npczmd@qq.com>
Reported-by: Gongming Wang <gmwgg05@gmail.com>
Reported-by: Peiyuan Xu <paulbucket12@gmail.com>
Reported-by: Qinrun Dai <jupmouse@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yunpeng Tian <shionthanatos@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -4544,11 +4544,21 @@ copy_lcns:
 		 * whole routine a loop, case Lcns do not fit below.
 		 */
 		t16 = le16_to_cpu(lrh->lcns_follow);
-		for (i = 0; i < t16; i++) {
-			size_t j = (size_t)(le64_to_cpu(lrh->target_vcn) -
-					    le64_to_cpu(dp->vcn));
-			dp->page_lcns[j + i] = lrh->page_lcns[i];
-		}
+                t32 = le32_to_cpu(dp->lcns_follow);
+                if (le64_to_cpu(lrh->target_vcn) < le64_to_cpu(dp->vcn)) {
+                        err = -EINVAL;
+                        goto out;
+                }
+
+                for (i = 0; i < t16; i++) {
+                        size_t j = (size_t)(le64_to_cpu(lrh->target_vcn) -
+                                            le64_to_cpu(dp->vcn));
+                        if (j >= t32 || i >= t32 - j) {
+                                err = -EINVAL;
+                                goto out;
+                        }
+                        dp->page_lcns[j + i] = lrh->page_lcns[i];
+                }
 
 		goto next_log_record_analyze;
 


