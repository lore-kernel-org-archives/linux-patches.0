Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330D24E4C5A;
	Tue, 13 Oct 2026 11:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892307; cv=none; b=DqgNm9CFvdqYJ4F3NVAaKK3l4K6QLvch4bvWlR9Exmpagb34K1Do3YBaIHs3AYN0PR+PA1WiaSjzasNO0KtJBrn95ul65Oz+Lrwx+EsA8fFi/o+JlryAmHSj9Bm0q4KeKkbUoq9uiJlSCCyAagbn51T3iWGwda9Lch6c/RFD0oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892307; c=relaxed/simple;
	bh=1brTBFTdVfFulxxMQdq9R0hq3yCPHWLAM7zoe9GCcss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3wg5zCq5WWlpXWemDbAaBbtVpZr0OSNaldHO3hyXINQhcPedLRWhIsv1UnE1dk5wH8A3/a44WAZFQI3PqkP6ofVttwFLN0FobL+zQnxdXgeS/rGPmJzrZ7u0ke85iJeJ3eEPXIrA7dKoa0nrRzg8/mw1NtdnenT+72hch1XO3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6PwzQ4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6PwzQ4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3850A1F000FF;
	Tue, 13 Oct 2026 11:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892305;
	bh=n3IytHMbDM9es0XPRqNYm3tnlimZZFI7KNSxIeh0irU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6PwzQ4H9+Ia7+ktoxckpeITwZU0VlQ8NY8Qcj4trGzkhcmlLYb+jG7xhOr8kgQI2
	 R0pWEUnJIL0CsHMTkSj0JNUK4Ie1ccvM61kspnH/r87LXH7SIR/yuZ7SvF/3vEhrl6
	 f0LMVfTQPxARD0/Q5rTCMR/vEqRPuGDCp1bDV5ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Xinmeng <1564938642@qq.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 075/281] dm-snap: reject the transient exception store for snapshot-merge
Date: Tue, 13 Oct 2026 13:36:31 +0200
Message-ID: <20261013112856.950262621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1294,6 +1294,20 @@ static int snapshot_ctr(struct dm_target
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
 


