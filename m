Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7250C1DF98B;
	Mon, 23 Jun 2025 21:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713265; cv=none; b=HUoIa+qJSy/8CKbi9yA6XlQxSfECw/tO2mBZr1HAw10pE0dMiOPC3D+QeYxPgjjYKI0GmNAPTCA7Rf9FQecubs9b7Z21Ss8r4J1YZYA/+tvpKE6eSWLCJVCfffksM88crkS2Rgpr7g/F9MI89QlOs0sd25wjlHSlMIgy3BUWog4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713265; c=relaxed/simple;
	bh=RNlWxsLPaWjFUznLhNEXP5XXfuCOVe7dnPMf3HIDZpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjaEqjbHt7sfb8FpVG/KtloXsf2vwkr3RjZ+WbWpctdIYw0CfOlvYMNG/9/U19B7AVsKTSBPa3ry34pJjYMDdLR3lO8pQRwQflKH3nYKwTIN3K7cIovPsCezGB/ULM3mW6TlIplIBbQgcQW639xYQJStPlVQJc8cH4YLSx+D2Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrB1mQRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrB1mQRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A808C4CEEA;
	Mon, 23 Jun 2025 21:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713265;
	bh=RNlWxsLPaWjFUznLhNEXP5XXfuCOVe7dnPMf3HIDZpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrB1mQRLclGx9u11YqLn/78g8GJOZH6H6rzzgaZjz/AvCCRJLrbXgLrQp/yBmI5m9
	 XFhjMmjpnX+5Dgr3q2D+pX1C0CuFaoaL6YZdU4USe94ZX3uUMtQov60NjjiWRlTLTk
	 BYKYndncI5dJCRrmqr5lsVtrrzDt0pZbefCUUju0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Dave Wysochanski <dwysocha@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.12 035/414] fs/nfs/read: fix double-unlock bug in nfs_return_empty_folio()
Date: Mon, 23 Jun 2025 15:02:52 +0200
Message-ID: <20250623130642.905524437@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


