Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA09B46DFEF;
	Tue, 21 Jul 2026 19:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663937; cv=none; b=nzv+TPMVvLRn0wf7lcr9zVMG0XIPIX4vWJPQlh5baBHpQq1dy8tyXnVtNXDR+TFZx3qmKmjtu5mXdpU1757qzNwKFnSApQJNTIglcbcTLlpET7+mnp2QiHBmiG9iupF/HQB6R89wE48uJ4w0Zxa8cIqWcxbPXSGxP1dzwISH+Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663937; c=relaxed/simple;
	bh=OrcVaUVvr6Lqu6DH4RCr9LF6NXeuY8EBdTeYeSyq9U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggXSZMC8ZtnuJti8zO+ACUYhFvf7/Ll57g3gqiK46uxN6raCiahCppVEpNjHaNJvb4q1Z6sjLGl988HPEyWr7xOQ+e3jg+G2G9A0EEC4Idx1OKwyJFCsW6wdVdYN4QhrlM/V2e4h3YlOz52DWimCXUYxA1Ljbywq4yQ2b0Zrnqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsgiRL/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsgiRL/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34001F000E9;
	Tue, 21 Jul 2026 19:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663935;
	bh=W6Y7XH0sswXzjJwLXljH6dSFonfNwXhwh4eRkj1krdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsgiRL/ElcBTbUrxa8GAicdScJWN5eGt8ZP+w0QRDr289hw4LU/CUlZLQRyFrVt4k
	 MfoN32m5zBmMZtI6czkd2EIqVGDBHPyvLG2uZ/DBdPLS8i6HTxumZHU0K6hY4w5oKe
	 D0zsKpkvrAnvpKBFTEAiNxY64lOZFP/iPuOqIgqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1009/1276] dm-integrity: fix a bug if the bio is out of limits
Date: Tue, 21 Jul 2026 17:24:12 +0200
Message-ID: <20260721152508.585377647@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5a266764fadaff8b5c1fe37a186ebf9b09cb953e upstream.

If dm_integrity_check_limits fails, the code would exit with
DM_MAPIO_KILL. However, the range would be already locked at this point,
and it wouldn't be unlocked, resulting in a deadlock. Let's move the
limit check up, so that when it exits, no resources are leaked.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2423,6 +2423,9 @@ static int dm_integrity_map_inline(struc
 	if (unlikely((bio->bi_opf & REQ_PREFLUSH) != 0))
 		return DM_MAPIO_REMAPPED;
 
+	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio)))
+		return DM_MAPIO_KILL;
+
 retry:
 	if (!dio->integrity_payload) {
 		unsigned digest_size, extra_size;
@@ -2487,10 +2490,6 @@ skip_spinlock:
 
 	dio->bio_details.bi_iter = bio->bi_iter;
 
-	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio))) {
-		return DM_MAPIO_KILL;
-	}
-
 	bio->bi_iter.bi_sector += ic->start + SB_SECTORS;
 
 	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);


