Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E0E2E5425;
	Tue,  8 Jul 2025 16:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991887; cv=none; b=Y9zX4vSeJLoMsXuyvi/FUe1z5VO5qK+ckDestbnfSBDj1maji3ly5GXL9fYT9URZzUpLne9v0F9+JXtYAvw+FhkiNClewpH5VizuHkIz+9Qt2dG9LGXC1KpPqsGYRctCb+/cAJAO79lbLalTsjRHP2Uc+aLg86gVNXmMHoHsluw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991887; c=relaxed/simple;
	bh=QkOhldzF7KG0re14tavBPXWg+Icm6RpFzTsMdso+D8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1ldDBgIJiFuGpC5OIvKs9wzU7nPiOnrr7VqjS45g3FBgzbvkllHxGBgZzCJPYNl+1VNZEF+SnTlpFj9e5+bMhTJtR0Va0ucbjyA4l8pkSyTfK3sG1n3uJadE26hDwpes2yfabI9e6c2CTlrsVPdz4AOgi1jvat9z6vefw4uzAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUNpMLGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUNpMLGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0DFC4CEF0;
	Tue,  8 Jul 2025 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991887;
	bh=QkOhldzF7KG0re14tavBPXWg+Icm6RpFzTsMdso+D8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUNpMLGRVgpQGzkl5fVaIDUXRTTcG00aZTSSwoVkXfCftsvkM6OtSF3gDiZaFmLzp
	 wMQjBRwaXz/HU7BxctLFuRBCP7TixalC74HwIeLWnewEMVZYujaIFszp5ZaA+v9Yc2
	 G8xcP/c8Bl6K0kRvrS57+JL/Qzl/wAYpkPJ5Tqqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Young <hanyang.tony@bytedance.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/160] NFSv4: Always set NLINK even if the server doesnt support it
Date: Tue,  8 Jul 2025 18:20:39 +0200
Message-ID: <20250708162231.575337288@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Young <hanyang.tony@bytedance.com>

[ Upstream commit 3a3065352f73381d3a1aa0ccab44aec3a5a9b365 ]

fattr4_numlinks is a recommended attribute, so the client should emulate
it even if the server doesn't support it. In decode_attr_nlink function
in nfs4xdr.c, nlink is initialized to 1. However, this default value
isn't set to the inode due to the check in nfs_fhget.

So if the server doesn't support numlinks, inode's nlink will be zero,
the mount will fail with error "Stale file handle". Set the nlink to 1
if the server doesn't support it.

Signed-off-by: Han Young <hanyang.tony@bytedance.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 09922258f5a11..28c24079c57a8 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -567,6 +567,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr, st
 			set_nlink(inode, fattr->nlink);
 		else if (fattr_supported & NFS_ATTR_FATTR_NLINK)
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_NLINK);
+		else
+			set_nlink(inode, 1);
 		if (fattr->valid & NFS_ATTR_FATTR_OWNER)
 			inode->i_uid = fattr->uid;
 		else if (fattr_supported & NFS_ATTR_FATTR_OWNER)
-- 
2.39.5



