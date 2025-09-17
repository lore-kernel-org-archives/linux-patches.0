Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD15332A41;
	Wed, 17 Sep 2025 12:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113808; cv=none; b=f/AdlvhlO1u0jVanKBgJIcGvIBJbSdlm5fO3JTaEt98G1+xFwDSjIMv0InY10S+eJychnudBC/H0Koa7vw7ZuaVXX3VuxBuVNNsdUJZPKbBbmteWoHKRCVVTqkDHojg98QzgEN/494GSkJJJLNigJoBnmbHsyyHSk6dXBvcH5B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113808; c=relaxed/simple;
	bh=mbEsAKDiV8RtcQylCZeJ17O74Eet0PPIg4QqHJuJ/jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0XlQte423uUUtJ7bpOoKpFLdZWRBdm6wl/YSjXNrFDT0PK8/sxULEsJcC2Sj4bSRchF45bHwLmXWLmoZXWqpRIH7B5HbGD6u5UWUf7/cyYcEvinTslHsfBAV4qMBsigBPKK5hgGIHwOZC3bVYJPTCgaKg4mvr8Ilw9tBwSLkcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOTQFZkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOTQFZkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1600C4CEFA;
	Wed, 17 Sep 2025 12:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113808;
	bh=mbEsAKDiV8RtcQylCZeJ17O74Eet0PPIg4QqHJuJ/jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOTQFZkIGFrsXPqOjWhebhWrNzC00swjlvDWqJvSYB3VnVKjEbrasIVbtIXXDbOD0
	 FWzrfQRGNAx9J7KCgbA41hXyJ6kg8CCR75cnC3sQJkrDlPlt+c8ZZMRIR/c/N2hQyY
	 OA85r7Ixoo9nDIKGNpXfY+vOTsJnlDhTt1fBPcwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Yang Erkun <yangerkun@huawei.com>,
	stable@kernel.org
Subject: [PATCH 6.6 057/101] cifs: fix pagecache leak when do writepages
Date: Wed, 17 Sep 2025 14:34:40 +0200
Message-ID: <20250917123338.220970948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

After commit f3dc1bdb6b0b("cifs: Fix writeback data corruption"), the
writepages for cifs will find all folio needed writepage with two phase.
The first folio will be found in cifs_writepages_begin, and the latter
various folios will be found in cifs_extend_writeback.

All those will first get folio, and for normal case, once we set page
writeback and after do really write, we should put the reference, folio
found in cifs_extend_writeback do this with folio_batch_release. But the
folio found in cifs_writepages_begin never get the chance do it. And
every writepages call, we will leak a folio(found this problem while do
xfstests over cifs, the latter show that we will leak about 600M+ every
we run generic/074).

echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
Active(file):      34092 kB
Inactive(file):   176192 kB
./check generic/074 (smb v1)
...
generic/074 50s ...  53s
Ran: generic/074
Passed all 1 tests

echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
Active(file):      35036 kB
Inactive(file):   854708 kB

Besides, the exist path seem never handle this folio correctly, fix it too
with this patch. All issue does not occur in the mainline because the
writepages path for CIFS was changed to netfs (commit 3ee1a1fc3981,
titled "cifs: Cut over to using netfslib") as part of a major refactor.
After discussing with the CIFS maintainer, we believe that this single
patch is safer for the stable branch [1].

Steve said:
"""
David and I discussed this today and this patch is MUCH safer than
backporting the later (6.10) netfs changes which would be much larger
and riskier to include (and presumably could affect code outside
cifs.ko as well where this patch is narrowly targeted).

I am fine with this patch.from Yang for 6.6 stable
"""

David said:
"""
Backporting the massive amount of changes to netfslib, fscache, cifs,
afs, 9p, ceph and nfs would kind of diminish the notion that this is a
stable kernel;-).
"""

Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
Cc: stable@kernel.org # v6.6~v6.9
Link: https://lore.kernel.org/all/20250911030120.1076413-1-yangerkun@huawei.com/ [1]
Acked-by: Steve French <stfrench@microsoft.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2884,17 +2884,21 @@ static ssize_t cifs_write_back_from_lock
 	rc = cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY, &cfile);
 	if (rc) {
 		cifs_dbg(VFS, "No writable handle in writepages rc=%d\n", rc);
+		folio_unlock(folio);
 		goto err_xid;
 	}
 
 	rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->wsize,
 					   &wsize, credits);
-	if (rc != 0)
+	if (rc != 0) {
+		folio_unlock(folio);
 		goto err_close;
+	}
 
 	wdata = cifs_writedata_alloc(cifs_writev_complete);
 	if (!wdata) {
 		rc = -ENOMEM;
+		folio_unlock(folio);
 		goto err_uncredit;
 	}
 
@@ -3041,17 +3045,22 @@ search_again:
 lock_again:
 	if (wbc->sync_mode != WB_SYNC_NONE) {
 		ret = folio_lock_killable(folio);
-		if (ret < 0)
+		if (ret < 0) {
+			folio_put(folio);
 			return ret;
+		}
 	} else {
-		if (!folio_trylock(folio))
+		if (!folio_trylock(folio)) {
+			folio_put(folio);
 			goto search_again;
+		}
 	}
 
 	if (folio->mapping != mapping ||
 	    !folio_test_dirty(folio)) {
 		start += folio_size(folio);
 		folio_unlock(folio);
+		folio_put(folio);
 		goto search_again;
 	}
 
@@ -3081,6 +3090,7 @@ lock_again:
 out:
 	if (ret > 0)
 		*_start = start + ret;
+	folio_put(folio);
 	return ret;
 }
 


