Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87BA335BAF;
	Mon, 18 Aug 2025 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525029; cv=none; b=pV5gleb302v09HkQjUAEw2ZbQr7Nyx8aprOo2vvxhDpuXV/IOlIdm+RS9kInWYdavmt6A5OIKTPjG8JUs8r7qyN5ZzWddRLYKHLZY9p40j3CA/HrMJrYTUYySvx7TVmemycqPeMwBQLko50Gj9ZItgF3zOym2l5dq1Cuv1Mn0uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525029; c=relaxed/simple;
	bh=VHJ8VzWLuZ6e7MrNbgJaVfAl2S/qPNZaxxSTxmfgNys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Abtg4blgW/RKu+QVXob9xIeCGIvXKTVPJjCykhPdtdWoAXJhAIxZXXbtcZfDn31iy/Kiscp/jcB/7izDeRcmbgOXYWjk1GdYHoQUDoLU/TC+OR+1jq/vVOv7CvLWIsV40W2CJpig0Am+VqUpB60Rx0f69eKUFnJ8NaI7XtlIfQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOflIub6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOflIub6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E98C4CEEB;
	Mon, 18 Aug 2025 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525028;
	bh=VHJ8VzWLuZ6e7MrNbgJaVfAl2S/qPNZaxxSTxmfgNys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOflIub6JsCDBuEmt3z15GM6fl4IhO1r5UFUm0mk9zzuSJTi3qqIbhXeSfLqbu4mI
	 NAHruke5RPMNZPz52KFOhLd3Dwt3bUOfm3y6r//gkxYEb24nFqgeVyfRHXpbjw7axp
	 psN3TN/f+pR8abpCxRC7cgwk51TZ3PmijQ29+c14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 105/570] gfs2: Set .migrate_folio in gfs2_{rgrp,meta}_aops
Date: Mon, 18 Aug 2025 14:41:32 +0200
Message-ID: <20250818124509.853293033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Price <anprice@redhat.com>

[ Upstream commit 5c8f12cf1e64e0e8e6cb80b0c935389973e8be8d ]

Clears up the warning added in 7ee3647243e5 ("migrate: Remove call to
->writepage") that occurs in various xfstests, causing "something found
in dmesg" failures.

[  341.136573] gfs2_meta_aops does not implement migrate_folio
[  341.136953] WARNING: CPU: 1 PID: 36 at mm/migrate.c:944 move_to_new_folio+0x2f8/0x300

Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/meta_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 9dc8885c95d0..66ee10929736 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -103,6 +103,7 @@ const struct address_space_operations gfs2_meta_aops = {
 	.invalidate_folio = block_invalidate_folio,
 	.writepages = gfs2_aspace_writepages,
 	.release_folio = gfs2_release_folio,
+	.migrate_folio = buffer_migrate_folio_norefs,
 };
 
 const struct address_space_operations gfs2_rgrp_aops = {
@@ -110,6 +111,7 @@ const struct address_space_operations gfs2_rgrp_aops = {
 	.invalidate_folio = block_invalidate_folio,
 	.writepages = gfs2_aspace_writepages,
 	.release_folio = gfs2_release_folio,
+	.migrate_folio = buffer_migrate_folio_norefs,
 };
 
 /**
-- 
2.39.5



