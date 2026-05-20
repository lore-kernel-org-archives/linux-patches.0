Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFFB3403FA;
	Wed, 20 May 2026 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295546; cv=none; b=M+vNJHi1WjlI8JG/FIxBlzEonfPn7E0JakF64auyZmV5eaBge+eVAnUjWfhUYn3tU1RJQ8ntdaPAW5GusRO67L0N6CCYBfqShGwhDijgwHbVSdwq/9jwFuwMBTlW10sUBxj0qKmVGl8pTBB16kfJj+ryKFUXk4lz5DUJ1yyHRXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295546; c=relaxed/simple;
	bh=6TiZ4XJ7/4f4B17Gq1AzUs//MrKCJ4qDgUeNVHbZznI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJB3Xq99vD2Wm+e+sgt5RTr/jqru28MtXw3eV0cZnorLTlvkP+GiE/WaPAltmwmNxnoictVTbe06uGbCbpkmBzy32Ms/C4v1la9UwgU6MDb7t7GSUJUuusxwofdfvCe/GT2dp+41tYU7p4slh03jhxgHmUkJQF/Kcd6lPFvQog8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1g4xJUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1g4xJUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94941F000E9;
	Wed, 20 May 2026 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295545;
	bh=X9Pt7mK5U1E+OlFfIcvEEnasd8c6pRQteY7Kvi1I0KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1g4xJUxDifSdWB4ub8cKkILMkrJV/tccerNcSuAKYqp28xyI7OE3DRQg8opYVuki
	 fiJVwp2tLGNgRH3Qf1qqpWkXJLa22ZC48sdefC5E8owNgcYklKOialgyT7J7ZjH+6b
	 kjnuVp+4v8yS8Tf6KhJLoXyiHyJY0sNgau1sOe14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0459/1146] gfs2: less aggressive low-memory log flushing
Date: Wed, 20 May 2026 18:11:49 +0200
Message-ID: <20260520162158.585956290@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 7288185ce87ec70133b7bc3b694b0f74bf46a0ee ]

It turns out that for some workloads, the fix in commit b74cd55aa9a9d
("gfs2: low-memory forced flush fixes") causes the number of forced log
flushes to increase to a degree that the overall filesystem performance
drops significantly.  Address that by forcing a log flush only when
gfs2_writepages cannot make any progress rather than when it cannot make
"enough" progress.

Fixes: b74cd55aa9a9d ("gfs2: low-memory forced flush fixes")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/aops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index e79ad087512a0..6a6ded7a61d20 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -158,6 +158,7 @@ static int gfs2_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
 	struct gfs2_sbd *sdp = gfs2_mapping2sbd(mapping);
+	long initial_nr_to_write = wbc->nr_to_write;
 	struct iomap_writepage_ctx wpc = {
 		.inode		= mapping->host,
 		.wbc		= wbc,
@@ -166,13 +167,13 @@ static int gfs2_writepages(struct address_space *mapping,
 	int ret;
 
 	/*
-	 * Even if we didn't write enough pages here, we might still be holding
+	 * Even if we didn't write any pages here, we might still be holding
 	 * dirty pages in the ail. We forcibly flush the ail because we don't
 	 * want balance_dirty_pages() to loop indefinitely trying to write out
 	 * pages held in the ail that it can't find.
 	 */
 	ret = iomap_writepages(&wpc);
-	if (ret == 0 && wbc->nr_to_write > 0)
+	if (ret == 0 && wbc->nr_to_write == initial_nr_to_write)
 		set_bit(SDF_FORCE_AIL_FLUSH, &sdp->sd_flags);
 	return ret;
 }
-- 
2.53.0



