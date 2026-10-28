Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209165;
	b=c9AlzkBEn8fONPMvMYUqaPJZwCFLcANigBZokDullsZhlVxC1NG5aT3U2Nfytu7P5+bt
	 V2haQmNC7z6/9twDXR61cDlP0cFlrcyQPnapwvUSScJKo02Z7h/3WMDQPonEd3UXoCp9s
	 KkpQh16GUomCKJXpVZhxkugAHECrTpjub5YM3KxcZfKr08BbC06WLJIvtw8finiB6pExe
	 pRJ4Yz9SK1uazXTeK+/Q278EXfAmrc13yJm0U6ePibRc+IqDTb5kk4a46GpeeKOkhTEl1
	 HgGaH/TOJqQoT3PopxV9PXvp80pVA/OAEjFoN3zR28NhZ2neRECt1GfOpE4eK3tCTKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HFgf2ozd/Ev6bOxHgn+hAlN1dFiXLF6gZC7twYpii1M=;
	b=iyczQqTu6XtaIKibTz/nvzVy1syuRqoLepSm5oWtqAM+eWT+uup6+OR9Uw9V3ZPRC/M0
	 daq3+8a5th3QumihdzcAGqdafqbWsKay6z8+3X6h31TISSwUa5CEbS68whzOfPtv9WCot
	 kseU6LO7SUirZiZNfXAe+LVT/82Ym33kFzpdGi7j/+uUiJrgapALuMnRIrhYW2uop3jkG
	 2BzpT2wpa8d6WySWMIzxuEW9eaUQRJEzt1m9MjiMc36Hc7MbXgYTFMXZurfBhnqddiqDb
	 msCWBUzPUadktbsOkYjYhU0hm9U1Ocsh9KcYDUt427lhvnyVqfuEWMJtRoTHuG+OZig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZ85t58f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9B5606A31A;
	Wed, 28 Oct 2026 17:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZ85t58f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627FB1F01825;
	Wed, 28 Oct 2026 17:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209164;
	bh=HFgf2ozd/Ev6bOxHgn+hAlN1dFiXLF6gZC7twYpii1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZ85t58fbOoTJfVvn355tZTcvmay5AIotIy4wdbwzri2gCASMCvMM6u4kMejI/l40
	 +uin7V8GHAS5s/ekYMqLtdKCwKtieZN0TcrixFE8LuczKCy+K99YRTX39J2rbxhiNV
	 2sRIxNe3o5N+tMxJcE3+Gjk87DvfwaHj9LLP/d8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Xinmeng <1564938642@qq.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 332/516] dm-snap: reject the transient exception store for snapshot-merge
Date: Wed, 28 Oct 2026 17:58:04 +0100
Message-ID: <20261028170011.353289834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Xinmeng <1564938642@qq.com>

commit fcbde6227fcc53c73f08c56b2539e462d545cac6 upstream.

snapshot_merge_next_chunks() calls s->store->type->prepare_merge() without
checking it. The transient store ("N") implements neither prepare_merge nor
commit_merge, and snapshot_ctr() validates those callbacks only on the handover
path (__validate_exception_handover()), so a directly constructed snapshot-merge
calls a NULL prepare_merge on resume:

  snapshot_merge_resume -> snapshot_merge_next_chunks -> prepare_merge(...)

commit_merge() is NULL for the same reason. Userspace only issues documented
device-mapper ioctls (CAP_SYS_ADMIN); this is a misconfiguration the kernel must
reject rather than oops on.

Reject the combination in snapshot_ctr() at table-load time (-EINVAL), the same
check the handover path already performs; this also covers the commit_merge()
call site, which a guard local to the prepare_merge call would miss.

Tested on Linux v6.6.157 KASAN: unpatched, the dmsetup reproducer oopses in
snapshot_merge_next_chunks(); with this patch, the table load fails with -EINVAL
and no oops. Also present on v6.6.145; still present on the linux-dm tree
(555f3d7be91a) and on torvalds/linux master (62f4c998b297) as of 2026-09-22.

Note that this is not a security bug because only root can trigger it.

Signed-off-by: Ma Xinmeng <1564938642@qq.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1321,6 +1321,20 @@ static int snapshot_ctr(struct dm_target
 		goto bad_store;
 	}
 
+	/*
+	 * snapshot-merge requires the optional prepare_merge/commit_merge
+	 * callbacks; the transient exception store does not implement them.
+	 * The handover path checks this in __validate_exception_handover(),
+	 * but a directly constructed snapshot-merge never goes through it.
+	 */
+	if (dm_target_is_snapshot_merge(ti) &&
+	    (!s->store->type->prepare_merge ||
+	     !s->store->type->commit_merge)) {
+		ti->error = "Snapshot exception store does not support snapshot-merge.";
+		r = -EINVAL;
+		goto bad_hash_tables;
+	}
+
 	argv += args_used;
 	argc -= args_used;
 


