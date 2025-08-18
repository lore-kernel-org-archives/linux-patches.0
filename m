Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB8331CA57;
	Mon, 18 Aug 2025 12:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521692; cv=none; b=tHDFUVhwA/6zpo0eXHkn4CdP4qMUco6Jf26A7mcns3DSE/OttvkSDrPLYDuH5xsTF2fn/DDc9N/oPDKRAWM4w2VKbza71CfIYeHYbSvpKIHgOa2df/aZ8r5iCLkcxX/NZW6iV/Fjs5E2+vVPpd3ScvfD2T2P1u1re+VR79EOgzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521692; c=relaxed/simple;
	bh=IvOinnXXIJUhCbwdCzco16WccVtYYvwAzsiaUpg9us8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xo6sTQbnk344KYPjslXMXIzVnUIJPQJLM4rfQNSTpXgs+7QpgJdX4W3ePJ7KJZDqjRhcxaA1/f/K2fNmb1GYjVoit8RpgkTaoEAMhXvysSbfTEsLQOQVnG0+2HBgaIQuthHccmauWfhcwb95F4IFRBJjZLhLO8dvbLAnnZZ+rBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3u4leLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3u4leLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15F8C4CEEB;
	Mon, 18 Aug 2025 12:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521692;
	bh=IvOinnXXIJUhCbwdCzco16WccVtYYvwAzsiaUpg9us8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3u4leLLlHu69wbQd2EeSiKYEx69z1bi8HA52GgpxjPCMER8EeicoCRjQGKex2Fu8
	 3RyARppzIBRJHaynhM0/f7jc0PyCQxR0RxjbWgGYiF3q+s3Hk8YthNvkzW7EPXiZaT
	 4WBtocjjjPbDg2fowTkcSLuyeQ7gFCdvVYf1wVFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/444] gfs2: Set .migrate_folio in gfs2_{rgrp,meta}_aops
Date: Mon, 18 Aug 2025 14:41:43 +0200
Message-ID: <20250818124451.837904860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 960d6afcdfad..b795ca7765cd 100644
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



