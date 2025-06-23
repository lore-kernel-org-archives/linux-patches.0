Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630F0219E0;
	Mon, 23 Jun 2025 13:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684384; cv=none; b=t7AqcFZuQ9hwuVgq6NkVrnZMDGNF6AwWm6tdku/G1BvXDtvrdWfCXu2BIo+McEPNlL8mFPa5r/1NSkwrOeN3kJDz1YzTtGf9yQL1IBRSmie3cNVlwx5eq+Ht2W5zAWnOI2PWn8A0/SAOriJ4o+IeZpHL06sU1twK/wlO/8/drFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684384; c=relaxed/simple;
	bh=y41ax8+2b/0j6hPn6Yu2apijOfkaGBFJeIdNz8Q+Ulo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzramCAPVDdc4xkVa8jUYOx7a03D9l6rV6BeKGLAcL9RvGM434lFGZKu6H3EGjtHVC6InD/7VkWSYls2ioE4lrzRgx08YxJG8u2gKu5svXXOUEKocoaRPAnOqTBgraK0m/NhF70sklGM/HtzuJiQKKMG7GFHXVN+cUI2c9ZyE7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGDQ+uqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGDQ+uqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E669FC4CEF1;
	Mon, 23 Jun 2025 13:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684384;
	bh=y41ax8+2b/0j6hPn6Yu2apijOfkaGBFJeIdNz8Q+Ulo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGDQ+uqEdlJwoJn0epiVEKEZwtiF+Z79JTxlCXGd/PqzpV+nuEyQHkR5qewpAoyV3
	 GS63+jVBOgwY2l1+0jpYPmBv6eCULbenGQv89MbzoH6GuO1GZcoJ8LB45Q9LG4phoD
	 wJHBv0HHNXZTx+IQc+wChzqdBs/MD3c+wirrNROU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Dave Wysochanski <dwysocha@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.15 048/592] fs/nfs/read: fix double-unlock bug in nfs_return_empty_folio()
Date: Mon, 23 Jun 2025 15:00:06 +0200
Message-ID: <20250623130701.388420706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 4c10fa44bc5f700e2ea21de2fbae520ba21f19d9 upstream.

Sometimes, when a file was read while it was being truncated by
another NFS client, the kernel could deadlock because folio_unlock()
was called twice, and the second call would XOR back the `PG_locked`
flag.

Most of the time (depending on the timing of the truncation), nobody
notices the problem because folio_unlock() gets called three times,
which flips `PG_locked` back off:

 1. vfs_read, nfs_read_folio, ... nfs_read_add_folio,
    nfs_return_empty_folio
 2. vfs_read, nfs_read_folio, ... netfs_read_collection,
    netfs_unlock_abandoned_read_pages
 3. vfs_read, ... nfs_do_read_folio, nfs_read_add_folio,
    nfs_return_empty_folio

The problem is that nfs_read_add_folio() is not supposed to unlock the
folio if fscache is enabled, and a nfs_netfs_folio_unlock() check is
missing in nfs_return_empty_folio().

Rarely this leads to a warning in netfs_read_collection():

 ------------[ cut here ]------------
 R=0000031c: folio 10 is not locked
 WARNING: CPU: 0 PID: 29 at fs/netfs/read_collect.c:133 netfs_read_collection+0x7c0/0xf00
 [...]
 Workqueue: events_unbound netfs_read_collection_worker
 RIP: 0010:netfs_read_collection+0x7c0/0xf00
 [...]
 Call Trace:
  <TASK>
  netfs_read_collection_worker+0x67/0x80
  process_one_work+0x12e/0x2c0
  worker_thread+0x295/0x3a0

Most of the time, however, processes just get stuck forever in
folio_wait_bit_common(), waiting for `PG_locked` to disappear, which
never happens because nobody is really holding the folio lock.

Fixes: 000dbe0bec05 ("NFS: Convert buffered read paths to use netfs when fscache is enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/read.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -56,7 +56,8 @@ static int nfs_return_empty_folio(struct
 {
 	folio_zero_segment(folio, 0, folio_size(folio));
 	folio_mark_uptodate(folio);
-	folio_unlock(folio);
+	if (nfs_netfs_folio_unlock(folio))
+		folio_unlock(folio);
 	return 0;
 }
 


