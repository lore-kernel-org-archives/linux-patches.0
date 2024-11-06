Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36914207F;
	Wed,  6 Nov 2024 12:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896227; cv=none; b=teLilkUJbnjNc5jZuJX5Xo7l3ubpsV19At1gGeMXvgv8FSGd9ZdSot8zIB6dY5MkcnZqMp+JNmVCEmNawwls5SOT3TdGUN01qphdLMnuF7tC7LCVVgdfWhQXZxmSHbAFSIZhS+Lemcg0Dh3qBH9XOGsCZTgcJ0PlVrkF6iEEayI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896227; c=relaxed/simple;
	bh=TTbAls8ecwCBEKR88hRp1cGZ0NCdxKI5EO6VA/h66xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2Ub6tGqdzlvb2BTZeKBq62+XDoJUR4H4SOzCrqFjHruGqY59FEMiunV6aAGwdbbkwcEQz+QsvDpglDrKAUyE8CQ4YXlJm7SBzVFDLlCsRiyaj9G4osqBiFlWrdz/FE+s5bI6NEUSbSEue4HIBo7FFZdz0DiX3dNMPUDIkdnieE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ld9gBhWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ld9gBhWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6853EC4CECD;
	Wed,  6 Nov 2024 12:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896226;
	bh=TTbAls8ecwCBEKR88hRp1cGZ0NCdxKI5EO6VA/h66xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ld9gBhWgazqJOeeNVTwyxUc3Lx5xPxHS8LQh+0jXKft3LSk7JGRSbNtzdITMOUYsF
	 7/NlhPL2gVgQ3qSvLbi+kp2bE1TTO2oQ3hKEKQ/Miw8/Svnf4eI+4qfhvkXeZJ55RY
	 KD6i/Vs/mj/84ssaBmSAU4I0ZaCzOcqYbts9vQik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 133/245] nilfs2: fix kernel bug due to missing clearing of checked flag
Date: Wed,  6 Nov 2024 13:03:06 +0100
Message-ID: <20241106120322.499717538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 41e192ad2779cae0102879612dfe46726e4396aa upstream.

Syzbot reported that in directory operations after nilfs2 detects
filesystem corruption and degrades to read-only,
__block_write_begin_int(), which is called to prepare block writes, may
fail the BUG_ON check for accesses exceeding the folio/page size,
triggering a kernel bug.

This was found to be because the "checked" flag of a page/folio was not
cleared when it was discarded by nilfs2's own routine, which causes the
sanity check of directory entries to be skipped when the directory
page/folio is reloaded.  So, fix that.

This was necessary when the use of nilfs2's own page discard routine was
applied to more than just metadata files.

Link: https://lkml.kernel.org/r/20241017193359.5051-1-konishi.ryusuke@gmail.com
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d6ca2daf692c7a82f959
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/page.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -409,6 +409,7 @@ void nilfs_clear_folio_dirty(struct foli
 
 	folio_clear_uptodate(folio);
 	folio_clear_mappedtodisk(folio);
+	folio_clear_checked(folio);
 
 	head = folio_buffers(folio);
 	if (head) {


