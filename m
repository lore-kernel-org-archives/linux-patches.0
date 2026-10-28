Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211425;
	b=TcGDyn8UBb/AflQC61LtWKiEAGoN2/q3f4LbxbyG6JRLcyDog9B32TmauQNEv0unmIZ3
	 tioBe1tqA85cgbdxQqNqV6u1QwRbfutTiTekwhxUL4vRwpooQ2MebmfciIYZl9abFbo01
	 Ho0ztLIsWoWo0qhA5VGU0P/0Cxa0Pk+7w9t5zcKhjdtKkEp94qn5f+FMzuTkAC7YyCf3q
	 jjI/nBjYeyFlq4CYKdXqD72y6TwkXAeu9IWuQep7PCEL42mKKVQZ+a4kyja7ZkldyE7Su
	 8FTxjIXGj18vtUq7CK5cnHmmXPamim/OM4A38js285whebrQCP8VJrRU9NeMVIBo8dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OFrO4iljuO1CxgHixkYqWvDADRn9lYF81eao+EmjHFg=;
	b=tj5MFCz+HjLqGxybsKdrphVN/bfbWAwusc8EpA9u7ZR9CTqLPg30tr97fLF002pk55aL
	 h16oH7VtCfdp3vJAMSMMipZXesILxq9owo6XqonIozGp3r95/ch/068LT/YfZDPTpymcQ
	 GRNmB46OhM4VjvbfWEff0gzurU+n6FQnYwN5aaVZEAiPyKFyRglymAD4D39Oo6fRYB1HN
	 n4ut8LuLbEC1jETukWwtIlTRF7vaz5PD1KnQVFI7Jj23jJPgt7qWWmslH6QITLHbLPVZu
	 unOpdXTK/lULRhL6TthuFvjfBwc1GasnRzcTOVxE/XhZlQdG53dt0cR0Hz7Zp9pbvWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgKxlflP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED23606A31D;
	Wed, 28 Oct 2026 18:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgKxlflP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8081F01825;
	Wed, 28 Oct 2026 18:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211424;
	bh=OFrO4iljuO1CxgHixkYqWvDADRn9lYF81eao+EmjHFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgKxlflP084S6lOdBY9gg0fUzlSnHQZj+PoyceYA5Fe1W0WyG6gRHYjI2axEkvVHU
	 SOX1/O5xEWAHXsDU0V0PSxzoLvHN+IRSMn9M1wuargCOJfUnj4K1XZrSS5WHebhLlD
	 maEZ/SlUh8epa2/E+ywf3Am37MFZ09SCm/+sBNG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Xinmeng <1564938642@qq.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 366/571] dm-snap: reject the transient exception store for snapshot-merge
Date: Wed, 28 Oct 2026 17:58:33 +0100
Message-ID: <20261028170016.699844116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1322,6 +1322,20 @@ static int snapshot_ctr(struct dm_target
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
 


