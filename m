Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DCD13D896;
	Tue, 23 Jul 2024 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760193; cv=none; b=HiQ8lA/XzgeDN6pV2QlJXr/OZqN0EE2v31hvgaLAXxUWtQXqi7DdEqYF0DHtlETsKwkdzgdXBTBmDEfNfjDtpvii06Q0cLxaJ/5VweKGD+U/dJul+yw5WNHjiDYVAOMZhJng68DXlAAeE+QhANDrGspT7rhQah1GysvLtL3/8NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760193; c=relaxed/simple;
	bh=pjOxc/NVReVhSpcR+DEYvzMm5HhR4N4IfoIyPS9hpDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsiIwie6j40uBEVUkfsJ2VR2OBXDCrufeYRcELTzbj+0XDLrMep3YGvK7Mzh/g2dHGacskQvNVDWqDEzWsKgg//7hJjK6xLtRjbJjvKk5tVhjqp5E1/mZfcV3HcnOz2CErUfS8sgvWE2PXwLD4UdA6eKR9TCbhT/Nwc/yn1L0mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mfh3Z6rF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mfh3Z6rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DF6C4AF09;
	Tue, 23 Jul 2024 18:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760193;
	bh=pjOxc/NVReVhSpcR+DEYvzMm5HhR4N4IfoIyPS9hpDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mfh3Z6rF8uVG4+r/s7kFROEbbuX/2dew16ZRRl9/XrvJCILEXPbaoaTkw+oqiJZpZ
	 npRS+HNjb1hoj4fMsAapy7waCUGKKddTi/6q7C9wb94112/i1SgXzL1hBY4A/IlTLV
	 qvNpQCtCp2MWxQC1u5eYzWOXT5jmFjc3kS/I+n5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 132/163] erofs: ensure m_llen is reset to 0 if metadata is invalid
Date: Tue, 23 Jul 2024 20:24:21 +0200
Message-ID: <20240723180148.574205243@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 9b32b063be1001e322c5f6e01f2a649636947851 ]

Sometimes, the on-disk metadata might be invalid due to user
interrupts, storage failures, or other unknown causes.

In that case, z_erofs_map_blocks_iter() may still return a valid
m_llen while other fields remain invalid (e.g., m_plen can be 0).

Due to the return value of z_erofs_scan_folio() in some path will
be ignored on purpose, the following z_erofs_scan_folio() could
then use the invalid value by accident.

Let's reset m_llen to 0 to prevent this.

Link: https://lore.kernel.org/r/20240629185743.2819229-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index e313c936351d5..6bd435a565f61 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -723,6 +723,8 @@ int z_erofs_map_blocks_iter(struct inode *inode, struct erofs_map_blocks *map,
 
 	err = z_erofs_do_map_blocks(inode, map, flags);
 out:
+	if (err)
+		map->m_llen = 0;
 	trace_z_erofs_map_blocks_iter_exit(inode, map, flags, err);
 	return err;
 }
-- 
2.43.0



