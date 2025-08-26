Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFFE1F5423;
	Tue, 26 Aug 2025 12:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212703; cv=none; b=KgsrFW9QwQTc6AqKMe0kT2kOMzqx/ILpYL1fWp9sZyEHMDBdLDek/4I6CgXNvaeYcUrYxYG1rmemAdLIS80jLoEpS+R4ye9pU0tA+8H+9MNobA+t/tfjtiBm0rGbx5SBuiUpC14B+Z4q+cvGq/CP4apX2sS1Ccl89UGfOitTqqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212703; c=relaxed/simple;
	bh=WiSAgt0wn4tk2GoaCA8n9IGtqNVOYin1xlHemgotXDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVLMsqBr2k0/lB3wWKSiMl1b47VJSRs1WeaqX+2eZxvQTveWAxEI/79jbkeRl7xlckpoTehaiCQeI/Wc0UXmWnLUIBlt9LNd4eBVCcbG7utcvmE3fXhE+bXjGQdQ+xaYLABtGnQTZqY+d2A62N4qkUkil0KRRFEnRR3qb+NJTKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLAZ4yUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLAZ4yUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22549C116B1;
	Tue, 26 Aug 2025 12:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212701;
	bh=WiSAgt0wn4tk2GoaCA8n9IGtqNVOYin1xlHemgotXDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLAZ4yUg4XtkDY3HF4bxDIw0Di4DFkINWDkU0WKYpcDPFKquUvJ/wfsusiRJNu6yv
	 ht7aHUpmeyc+KLhVYkqMthKmTMQltWhQB9CHzyPA0s7azYgs5tqASKV3iYtAMtqa7f
	 umiAp4JbKe23NL2zGy9xe1p+ex+QJC/GOpmcf8YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/587] gfs2: Set .migrate_folio in gfs2_{rgrp,meta}_aops
Date: Tue, 26 Aug 2025 13:03:39 +0200
Message-ID: <20250826110954.715053473@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
index 1f42eae112fb..b1a368fc089f 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -93,6 +93,7 @@ const struct address_space_operations gfs2_meta_aops = {
 	.invalidate_folio = block_invalidate_folio,
 	.writepage = gfs2_aspace_writepage,
 	.release_folio = gfs2_release_folio,
+	.migrate_folio = buffer_migrate_folio_norefs,
 };
 
 const struct address_space_operations gfs2_rgrp_aops = {
@@ -100,6 +101,7 @@ const struct address_space_operations gfs2_rgrp_aops = {
 	.invalidate_folio = block_invalidate_folio,
 	.writepage = gfs2_aspace_writepage,
 	.release_folio = gfs2_release_folio,
+	.migrate_folio = buffer_migrate_folio_norefs,
 };
 
 /**
-- 
2.39.5



