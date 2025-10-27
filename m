Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5516A32A3D7;
	Mon, 27 Oct 2025 19:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591718; cv=none; b=GRJdwFHZ9U8y2f7FXl41T4v8jOQR9yrF1crI0wyLxOPbpFdt5qdxApDaV72HPnZs4SGvQUEazV59ItiZ1ydOH2UXBYhWSh+amPCM0VDKr7HsxSO4RKiUVUhxe4PqOI+LykwPeta1hFD7zYrMPB2b0GhmfIdpY1XPZzou6LVayZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591718; c=relaxed/simple;
	bh=hWqgiYhIQ3/KMKSWDQimvbR2N0LJZdHlwU2cNPqe1Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGrUe4iArPChpKr3r3zN2I2x2JYPzr1bHQCdnUHTJYWu2AbkV65Q/Q6Hqd3dTG4H5Nk4V/s+VOIa87GMXjcn1Ppyc6ByoJI6B4H5ZT60Dw7ewdgOFSXo2r/w5D26LFxWWg20EV0v41EeZ+Zccil7fIvMVlSak16xHBzvXQnMdXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOCyr3L9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOCyr3L9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E00C4CEF1;
	Mon, 27 Oct 2025 19:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591718;
	bh=hWqgiYhIQ3/KMKSWDQimvbR2N0LJZdHlwU2cNPqe1Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOCyr3L9VOx+g35rO3Cx7KOgLTFhooWo5APDqcKdYAKQh3s2cCKJeAOoNgK0HqWS+
	 Ibmo2IeBolJsprB6kRRFUk6spWLWWQ6mOVdGpDhv93G72Mcd79R2n9xjihjk6NX1KK
	 miavXi3P6caKjvBrRBYR2Bq7jcoV6K/NXUNCtNtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/332] hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()
Date: Mon, 27 Oct 2025 19:35:19 +0100
Message-ID: <20251027183531.879247369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 9282bc905f0949fab8cf86c0f620ca988761254c ]

If Catalog File contains corrupted record for the case of
hidden directory's type, regard it as I/O error instead of
Invalid argument.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250805165905.3390154-1-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 65c63c7a00b12..9f8945042faa8 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -538,7 +538,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	if (!hfs_brec_read(&fd, &entry, sizeof(entry))) {
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER)) {
-			err = -EINVAL;
+			err = -EIO;
 			goto out_put_root;
 		}
 		inode = hfsplus_iget(sb, be32_to_cpu(entry.folder.id));
-- 
2.51.0



