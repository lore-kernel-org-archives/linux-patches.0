Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C7519E960;
	Wed, 18 Dec 2024 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734520919; cv=none; b=NnEnRYr5VpRYIbZ9L11WapTkdM2pXsnb3EDPBrNArteWEnBZ59rtMzvU7u+VBArtcsbIu5vzQBOHi6LIkCZ4TelXITKkMvS5H4eX+Vq/Ee1WrqrsBEQE9a2/u0gGgFRw8K7QrAsOqgVfyTrIb8sHr+14lyVDAGwLlhuQWBe+7TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734520919; c=relaxed/simple;
	bh=wY/7hF5PRSZcYzzsthu++8A3kOn20EmjgReMJ7MrJNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgSwv79dcA/N5kBPKhOng0wvKP6RtwWdEOsfrBVSIjRuX9/0Tgzz+LJWIVoXtiquQCMkqyD8VPci1jvCQriHcni5TTu64H4ksCBW6qYW/ma6IhX7B8fgwPIGX2DoO1rs4wSLpy9GfLTE3APu94heF8HQuJd6v2q9ZzqRgurYt1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nGC7kMO0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nGC7kMO0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=drrnbmYw5yknCAZIExrvfSIJUoiJeJ3WQdEq1X5C6vw=; b=nGC7kMO0MsyJEJ50VX/9EC1+u7
	CfDdDSAwgAdN07IHzDwiNxwdQSllNNg0j25GeIBsc1CFGCyUYtd5dLzzgorrS4KWDKBKgTivKYI91
	OYM4zMWT52lbQiDIeplAaMbPVGsskDF3IWVJlnlIMJELWBwcspe5n+OhKo0VdkV4+kPzbeaW81A6m
	PU7wVictLHixYRU7SuaRLDiXORPfYLKoKXKUci5XnJbc50FNkOrJCALtqP1vd/nWjRm6QmHtT4Ua8
	xJ95Tw7zfYrZdBseQ9xNV9aTRL9COC/wm6qqgQec1vSx0J1m4/t+jWgU6lPI7otvMVO6E1hDtNn3n
	6metfIvQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNs7o-0000000GR82-3yQT;
	Wed, 18 Dec 2024 11:21:56 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests 2/4] common/xfs: use min io for fs blocksize
Date: Wed, 18 Dec 2024 03:21:51 -0800
Message-ID: <20241218112153.3917518-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241218112153.3917518-1-mcgrof@kernel.org>
References: <20241218112153.3917518-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Use the min io for the target block size. Likewise we need to increase
the log size if using a bs > 4096.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 common/xfs | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index 569770fecd53..9a13258789e6 100644
--- a/common/xfs
+++ b/common/xfs
@@ -13,10 +13,16 @@ _have_xfs() {
 _xfs_mkfs_and_mount() {
 	local bdev=$1
 	local mount_dir=$2
+	local bs=$(_test_dev_min_io $bdev)
+	local xfs_logsize="64m"
+
+	if [[ $bs -gt 4096 ]]; then
+		xfs_logsize="128m"
+	fi
 
 	mkdir -p "${mount_dir}"
 	umount "${mount_dir}"
-	mkfs.xfs -l size=64m -f "${bdev}" || return $?
+	mkfs.xfs -l size=$xfs_logsize -f "${bdev}" -b size=$bs || return $?
 	mount "${bdev}" "${mount_dir}"
 }
 
-- 
2.43.0

