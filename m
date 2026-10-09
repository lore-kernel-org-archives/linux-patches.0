Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253B14E4C27;
	Fri,  9 Oct 2026 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555761; cv=none; b=DgMz/c8+h3yDy/WOySOFt5QEnnw/7pVOJT/um/kJ1tSAS2ugpVKdpZDFa21VLytpTZBaRctaN/76Vca31NX/KrzYt1jc7gLR/U+k57y1Hz6RqeyHRRMS/D7ndLzTVj9Sd3MV+XMRDxh4trZZWwS8B+ivxT5b1OUoieejOoyJRts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555761; c=relaxed/simple;
	bh=40hV/ZDtn8vmE74LrHWljaYr2wZR1obH3pueEYXPK20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fc5tUBrfeLCEynLyIXxO818GnAGRwst3DuuMyOtTBkMO8K6APBw/QmsrwnGrqm0lgdbTXI+al7aIaT34T+JXczAppuokcvgx1VnldwF+es1MW/tapk+ajIwkgw31FfmoHlIzBN//XdGmPAj/9xE3FvYtUU9C4B3FIK10saqWxQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvoGRwBp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvoGRwBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839F21F00893;
	Fri,  9 Oct 2026 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555760;
	bh=l+w9fuCsJ+JohPbmtf52BU5Ado9CcFONcNZ1T0WO5Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvoGRwBpAfQewf+PCUjsFsHEeuKGlT3GnP8cFcTLLPxTPNakx3NCR+F9EmEpFQZ4Q
	 nC+GfISp8aEEjILlIfrtETDwuBd93Je2wfMSWvnyV9TFR0cNCXNXvXTUaQpuln23qe
	 EyzJSVNlONv5GMXKSEfvyn1DVNsFob6uDGlzWNQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Garcia <berto@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 065/428] ext4: dont enable large folios on encrypted inodes
Date: Fri,  9 Oct 2026 16:06:42 +0200
Message-ID: <20261009140947.573856035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Alberto Garcia <berto@igalia.com>

Commit 709f0f1f1bf5 ("ext4: add checks for large folio
incompatibilities when BS > PS") disables large folios at mount time
if the "encrypt" feature is set. However, enabling that feature on a
mounted filesystem circumvents that check, and writing encrypted data
results in a crash:

  BUG: kernel NULL pointer dereference, address: 0000000000000028
  Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
  RIP: 0010:ext4_finish_bio+0xf7/0x3e0
  Call Trace:
   ext4_release_io_end+0x51/0x110
   ext4_end_io_end+0x4c/0xe0
   ext4_end_io_rsv_work+0xb3/0x100

Fix this by disabling large folios on encrypted inodes, as is
already done for inodes that use data journaling.

This affects all kernels between v6.19 and v7.2, but it is not needed
in v7.3, where the code was significantly refactored.

Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities when BS > PS")
Signed-off-by: Alberto Garcia <berto@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a33629b397b06..32f79f48a9dda 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5287,7 +5287,8 @@ void ext4_set_inode_mapping_order(struct inode *inode)
 	if (!min_order && !S_ISREG(inode->i_mode))
 		return;
 
-	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
+	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) ||
+	    ext4_test_inode_flag(inode, EXT4_INODE_ENCRYPT))
 		max_order = min_order;
 
 	mapping_set_folio_order_range(inode->i_mapping, min_order, max_order);
-- 
2.53.0



