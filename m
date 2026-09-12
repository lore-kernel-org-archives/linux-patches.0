Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5833234CFAB;
	Sat, 12 Sep 2026 07:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199673; cv=none; b=J/5vU+GZL2Ar7/c4wkljaMDMhl8WP+PdXIgZaPvqurRjwuJDPIT00gx2Vmk6s7bpc3hFSQD77F3NKgkIQmM4fCnOo+JKQ3omZcJPz4EtKP7iViE/pKgaLriSyWSiw+P3SC5URJzB694sNacDdwjwnoFi7OJmFAsfrarKMrGdsSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199673; c=relaxed/simple;
	bh=wDefqAR/3RoBb2StDJYe/IgAILh+UP3JsO2boQLpvlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtoZxvE4HYhxji0c55LlnjBgU4ku9qb8UY3whlfn/42OIp70u6LjvwdKD16N2BQ8CTzgeCXuMVOxRllcmpB4rokG4yGd1D4uCiICIdDR/hWOGrQ9d+3k7v7jJ8pG1r2i0Nf2krrF6SqTkYBb/Es4SmEL/Vv6MUld8FYhWZy3P8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDSTMOGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDSTMOGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914A21F000FF;
	Sat, 12 Sep 2026 07:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199672;
	bh=wcMtdQYd9ZoYcKG4v9gurb3Hz7PMdDSaoSw9vh+OI1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EDSTMOGtlyiNHfeMfgqxO9yxJa3ZYUVmsmrSKM6I8/xoOUYQ19cuI17c2Cyjs7Z3A
	 rNB4RG3rFu2ZZzpllW/PSthpgbSFX5CeB5t+bifbDsfcG4gplxmXw534DIdw2oUODe
	 +7VpJiHtCQdgX2xbiMdPTffmgZaP71SFB3VameE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Brian Geffon <bgeffon@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0631/1815] PM: hibernate: Fix memory leak in snapshot_write_next() error path
Date: Sat, 12 Sep 2026 08:39:41 +0200
Message-ID: <20260912065703.693458977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit 21d5c4cee31c5ce78f6decc7fafc7e7759af391f ]

When memory_bm_create() succeeds for copy_bm but fails for zero_bm,
the function returns without freeing the resources allocated for
copy_bm. This results in a memory leak that includes radix tree nodes,
zone structures, and page lists.

Fix this by calling memory_bm_free() to release copy_bm's resources
before returning the error code when zero_bm allocation fails.

Fixes: 005e8dddd497 ("PM: hibernate: don't store zero pages in the image file")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Link: https://patch.msgid.link/20260711145246.8625-1-malayarout91@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/snapshot.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d933b5b2c05d4..4a73927cc55b6 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2797,9 +2797,10 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			return error;
 
 		error = memory_bm_create(&zero_bm, GFP_ATOMIC, PG_ANY);
-		if (error)
+		if (error) {
+			memory_bm_free(&copy_bm, PG_UNSAFE_CLEAR);
 			return error;
-
+		}
 		nr_zero_pages = 0;
 
 		hibernate_restore_protection_begin();
-- 
2.53.0



