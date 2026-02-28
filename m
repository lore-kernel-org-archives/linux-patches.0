Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2A9373141;
	Sat, 28 Feb 2026 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301513; cv=none; b=OfJXvzDyxOsKCCWDPQhVokyDd9dh3t5kfg85bm4gb1UGXaHmAMslOeiXhEqvd8kHSkpCqPVeLcPqj0I3vBajtm+FD7rsXXXPQVsl01E+IZOZ8bxijHhmFR3SmClvZ2wrgi/fcsvAz20xTLrws/RBzQrhEZtuAizrvKMNxvww+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301513; c=relaxed/simple;
	bh=GmK4+ie24+tlIzHCphK3xOU9A0aQitWKtrBsOjrjRug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT0exT8SVz10kymRoHWkx5X6uqJ9AAa6SjAa9Y2y+atyfoVGSQUi7qwC1vxRj7LDd1Q0utNSFUKf4w+KgZcAb2Eww+vCvomwoGx3HqB4yfuzuJvrEqKuFdwjgnODrLnbtb0TqeezdD04rSta8aCGd5cLlpbl/S9pLiLfgdKhtu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gc2HlQEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gc2HlQEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D428FC19423;
	Sat, 28 Feb 2026 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301513;
	bh=GmK4+ie24+tlIzHCphK3xOU9A0aQitWKtrBsOjrjRug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gc2HlQEjEKWFeW1je+GkHuF7Xjh2tQOSF25BvLCSMqFSLiZgzuxweah8mHKj4B67m
	 CbxG1TIwnsRQJFvzcXDNrZ2Z5DRhJtBjAkp7cl/UT1GYWEDPUTwMCUtqkgZx3AUieH
	 f3U3vI73pbWAMXYh9Hs3Bg0N7E2d6KlgJhjENlXQ98QidQobaUfu4lST04Oian2heL
	 lMISLeSIjFMKd7BWoaMchZlthC7FJSBeeZtizwqVj/F05uockMAkxsXLLfWrUky/kC
	 PCOIIfzHR4FUfc36Mz3SrTEVSNBsfPyIb5D0ZdHcucgSHzN9xcH2nOs+pTqQ14fMKg
	 tVFZ2qAN4xVNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sam Edwards <cfsworks@gmail.com>,
	stable@vger.kernel.org,
	Sam Edwards <CFSworks@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 699/752] ceph: do not propagate page array emplacement errors as batch errors
Date: Sat, 28 Feb 2026 12:46:50 -0500
Message-ID: <20260228174750.1542406-699-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sam Edwards <cfsworks@gmail.com>

[ Upstream commit 707104682e3c163f7c14cdd6b07a3e95fb374759 ]

When fscrypt is enabled, move_dirty_folio_in_page_array() may fail
because it needs to allocate bounce buffers to store the encrypted
versions of each folio. Each folio beyond the first allocates its bounce
buffer with GFP_NOWAIT. Failures are common (and expected) under this
allocation mode; they should flush (not abort) the batch.

However, ceph_process_folio_batch() uses the same `rc` variable for its
own return code and for capturing the return codes of its routine calls;
failing to reset `rc` back to 0 results in the error being propagated
out to the main writeback loop, which cannot actually tolerate any
errors here: once `ceph_wbc.pages` is allocated, it must be passed to
ceph_submit_write() to be freed. If it survives until the next iteration
(e.g. due to the goto being followed), ceph_allocate_page_array()'s
BUG_ON() will oops the worker.

Note that this failure mode is currently masked due to another bug
(addressed next in this series) that prevents multiple encrypted folios
from being selected for the same write.

For now, just reset `rc` when redirtying the folio to prevent errors in
move_dirty_folio_in_page_array() from propagating. Note that
move_dirty_folio_in_page_array() is careful never to return errors on
the first folio, so there is no need to check for that. After this
change, ceph_process_folio_batch() no longer returns errors; its only
remaining failure indicator is `locked_pages == 0`, which the caller
already handles correctly.

Cc: stable@vger.kernel.org
Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 9faeaf1196c5c..32447023615a0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1373,6 +1373,7 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		rc = move_dirty_folio_in_page_array(mapping, wbc, ceph_wbc,
 				folio);
 		if (rc) {
+			rc = 0;
 			folio_redirty_for_writepage(wbc, folio);
 			folio_unlock(folio);
 			break;
-- 
2.51.0

