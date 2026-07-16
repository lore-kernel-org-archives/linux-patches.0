Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1C33191C8;
	Thu, 16 Jul 2026 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210443; cv=none; b=ADnGI1vGSbDDH51vx7tTHEZYBTJxeNZJPemQXoZOvseicaC2Eh+B0i1u+vNq2TMtAEMURuoN2QFcM9AAtkZ4vzmC0YQoXHaquLVA60GcDZrWmtLSnY17mxntK0s87bR6pojqgzjiLO0jIFWWglnEpM+cJ4CGvTLxVm5UbJqyEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210443; c=relaxed/simple;
	bh=D0FjagXjGZxEw5VBp3MMt/ZQG0M3fgIJYWar6nd7Sqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClmKutsRCHl1Of4aeg2azUvYsBdJdqPrGYtyHtAsPuCCJ1aqwn7GCNZPOgmdDZDiOyj2P5sGWo38KcfPuXN+bXM6CSBVy9KNhnIN0X983YqcyzSeozuvgn0hIutehEzl8UKJqFRqxsqx5Kc4b/16QswDuU13wdjRE1xwtBuyVvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhM//B7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhM//B7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F841F000E9;
	Thu, 16 Jul 2026 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210442;
	bh=PVqTo1CIMo807ak/UUmXYZhLVVANzF9lLSDx1QBVN88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhM//B7ZTVRIhJxdZPgcyqZw4ARUVZCAOiUlYBn/PaEtwo0Pi1KnEZf61xstk5WYG
	 Iaj0b+LijHKckfqlsb/8XKRw/EENobVclwun/JjCI52rVc7e69h+bScyPDCBQpjnoo
	 BssXqrPwawL/BQjeXHDzlQmVFiAYzER/kLvXKIQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlei He <heyunlei@xiaomi.com>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/480] f2fs: remove non-uptodate folio from the page cache in move_data_block
Date: Thu, 16 Jul 2026 15:25:56 +0200
Message-ID: <20260716133044.886239470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit 9609dd704725a40cd63d915f2ab6c44248a44598 ]

During data movement, move_data_block acquires file folio without
triggering a file read. Such folio are typically not uptodate, they need
to be removed from the page cache after gc complete. This patch marks
folio with the PG_dropbehind flag and uses folio_end_dropbehind to
remove folio from the page cache.

Signed-off-by: Yunlei He <heyunlei@xiaomi.com>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: e0288584baa5 ("f2fs: atomic: fix UAF issue on f2fs_inode_info.atomic_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1456,7 +1456,11 @@ up_out:
 put_out:
 	f2fs_put_dnode(&dn);
 out:
-	f2fs_folio_put(folio, true);
+	if (!folio_test_uptodate(folio))
+		__folio_set_dropbehind(folio);
+	folio_unlock(folio);
+	folio_end_dropbehind(folio);
+	folio_put(folio);
 	return err;
 }
 


