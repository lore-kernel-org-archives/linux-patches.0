Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08AD424651;
	Thu, 16 Jul 2026 13:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209425; cv=none; b=ji9rNFI+XwevLmvQfiWHuyP7DoMSLQAxIHq59h/QoJMIM1EtvQdD37hnrz4p+jy6SeYWM+U5rQxn2k3oDzhga6AubZ8YNRQ3kPZwmBovpgTsy4kJ26leC7WhNcaxLCS597YjWm3PhC6bQIg03Fju+vJ6CXTBJJOOmqw4VZPOxLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209425; c=relaxed/simple;
	bh=1smfPu4pw+haYiUXircSJwFBkntxnbYDyr0e41HNptM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rs75RwibdiX3UX5T6G/Elbn3QuX9zs12QW3GDauoroI5GDZ4pHdTcn1Jzp3zTP86pecTiQ2Lm9Y4MZYfyBopxRhvqvPrTQKIvALGRMqWas7K+9k+OT8eXZblAWg4Et/X3u54dsuuHKJ3fLzv8AV7bC46gvYbMbMYkjZSm5KAtHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqQ232zH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqQ232zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEBD1F00AC4;
	Thu, 16 Jul 2026 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209416;
	bh=W3npcK1trsQjK6yM+cqUnWoNrbQ5n/hJw8NfSqOhc9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqQ232zH6O3v5tnkcpfojd39b1o49yaT6GywyzRtLPf1TqbQjS2B3zLdltcwRW5y2
	 UQVH6TEQd27JqYr16Zr+XKECpvuOOSSYZn8OI94oZ97hw+Vci4ZUs+4YTOx2oSfp1d
	 BxE/QZ4/8Aym+ajbZkCOuXH9B4XD6gamd4ruV928=
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
Subject: [PATCH 7.1 178/518] fs/ntfs3: validate Dirty Page Table capacity in log_replay copy_lcns
Date: Thu, 16 Jul 2026 15:27:26 +0200
Message-ID: <20260716133051.733030582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -4547,11 +4547,21 @@ copy_lcns:
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
 


