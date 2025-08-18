Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033F733A00D;
	Mon, 18 Aug 2025 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523173; cv=none; b=KliO+6EZey3uJ/iwtB1NHDH5FftTgmUvdgJNfHVYTvGjXUnKOnexuMkBBvAjb81mp8Jr4DdrujlsZolFrVP99EALz7tlBU+qZV09Om2kdVEcScfcx3pltwSJZAEUkBjPPQwz6yg28LFSitx3CYkdBuRyb864j/6La1oRhTP42ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523173; c=relaxed/simple;
	bh=uswr3zJUmJySD0X8S/orHX41BEN5BrY3BPkIQ1dEvlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXo4LOeogG0C07XK6RSAouzhFcOQM3gGpacBDdV+08aw1CUcT83y03CDJhSysDJrfFGUQyyhlTX84yOQVHJiAHmeNtdUG0Gkb+f9ptdU+TE/hLNwbj9d1IlNqAtTymv/z6mFSgesjwkN7hJue1xqSKRdsr4JoURqHzqbxKArIMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqcKb6vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqcKb6vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E9FC4CEF1;
	Mon, 18 Aug 2025 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523172;
	bh=uswr3zJUmJySD0X8S/orHX41BEN5BrY3BPkIQ1dEvlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqcKb6vNgB4BwI5bdJUwYSEySUvsfWER6xmhAAx3eIa5T5TtnkunMKOqockU+am3a
	 ad3CUqBQaeMlGPItpDmt9U5Etv6KineeqI+SGZ+lrS7TnfjMtV2u6VtN/4gGWPI2Zp
	 NcNqUkh6Y8ygmpRSJGbxBRcTkYSxR6+G+vFhvoBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 093/515] gfs2: Set .migrate_folio in gfs2_{rgrp,meta}_aops
Date: Mon, 18 Aug 2025 14:41:19 +0200
Message-ID: <20250818124501.962770518@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



