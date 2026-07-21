Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DF642DFEC;
	Tue, 21 Jul 2026 22:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674359; cv=none; b=OSBAEdu1sYwW6ZZ0US3D/ZCHGvjTvSglrRTGwKtXthkZDCwyenfhemVy5cfrcsPzs5eI1Az1I977t0LVi1MM762s3+ipR7/CxvvqHCl7W7TQcbObIOovbWtbvS85Fpokz7521Zpo2kC0HzyNxxDxaVfs6Q17EcmZ+VvWvywBJes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674359; c=relaxed/simple;
	bh=0JurwyvzCXo99fP+GjSg1JBSPqq3yktPlvVYNQ6RoXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUWKS0aKKGzzzl44gIaa34KErcpVTBcr6Ll6ECd9XIVBkWpG0fCX5LA2SuUtzD1SmO8ocUynNS9sorfPQaEgIO1WlCx/oGNA/peh5EznK9ppSTIxAjClMToUY1xhQyhmt7/2dxENA6D0YowGRZ/NSsyyEbtDYzPTHJHbm6kmFC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qExUtNiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qExUtNiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADBA1F000E9;
	Tue, 21 Jul 2026 22:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674358;
	bh=XYvb+rtism9kdXg3rKIQ4fLmKX8sCRiF+QvLoXrEqlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qExUtNiNUpA1Lf2tHi7dj6svTGehOZGyjpa5xz6CML0ArBnbQm6BJUShIlTachTXJ
	 Wu6x17YTTTdtD8IjLx8mOEV1wf6BHsq2iYLKjFbbhPpwNBSSAsD0QXKN8r2pSOrYAH
	 oK1pZ8naJhVfPosqTefFbfqkTpx3lR90qBXtDU7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 512/699] dm-stats: fix merge accounting
Date: Tue, 21 Jul 2026 17:24:31 +0200
Message-ID: <20260721152407.244922940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1917eb2db750ecbdf710f79a8042eaa545a063c7 upstream.

There were wrong parentheses when setting stats_aux->merged, so that
merging was never properly accounted. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -651,10 +651,8 @@ void dm_stats_account_io(struct dm_stats
 		 */
 		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
-			(bi_sector == (READ_ONCE(last->last_sector) &&
-				       ((bi_rw == WRITE) ==
-					(READ_ONCE(last->last_rw) == WRITE))
-				       ));
+			bi_sector == READ_ONCE(last->last_sector) &&
+				(bi_rw == WRITE) == (READ_ONCE(last->last_rw) == WRITE);
 		WRITE_ONCE(last->last_sector, end_sector);
 		WRITE_ONCE(last->last_rw, bi_rw);
 	}


