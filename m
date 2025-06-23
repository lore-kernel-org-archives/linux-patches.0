Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FC9246BC9;
	Mon, 23 Jun 2025 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686038; cv=none; b=h95JmL6JFcjp4tSZ+ygfFrgGNoYmSkiLp9Jc+HI3Gk7+/SPSgPRuQP0zJsiSJLotn9j2K3gF5UUJ2FCKhzdZuw9A1TrYR31WGbC0bCbpTfu7CkC/zdukiDup/D4rbiCl/lTKqAqbK+fArMVdtZ1LhVk4NXY2Nn+4USAgaRNWx1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686038; c=relaxed/simple;
	bh=vGL+VrjZ/h672YOMUwzJX4IV/69vCg7IL4a+BFL/7UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diPQ28wKoJMDnyccJt4JQGnpTnuTrDALqekROi0+F4R28wpqZqw+a9Aj45Kci6s54GqCitW273FiPmPuKUhg2UhfVWWT8TgMSY0F/+Exy+NjRrnN5WkrJXr6PE2mNl+kXzyu1NNHdeNxphlB6srvwC+o10LXIEQpTpsR+OxUnmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyaXazO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyaXazO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7436DC4CEEA;
	Mon, 23 Jun 2025 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686037;
	bh=vGL+VrjZ/h672YOMUwzJX4IV/69vCg7IL4a+BFL/7UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyaXazO8KFJ1HxshJc8QZrgh6lJLWYiJ171AVGiPDk51QdOyZDvsexcfu1LG72JpD
	 6dR76To1044kOq7i0fZoBD4h0AVeskFUIJrzTTFLRm3VrPU6mE83nNO6fJTF9fLiz4
	 pidDU0NnyZgRv5KnSyIzXGMuRYFeXLwkNX9OXCsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Dave Wysochanski <dwysocha@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.6 019/290] fs/nfs/read: fix double-unlock bug in nfs_return_empty_folio()
Date: Mon, 23 Jun 2025 15:04:40 +0200
Message-ID: <20250623130627.561168967@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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
 


