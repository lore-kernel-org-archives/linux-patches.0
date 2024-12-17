Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7E11F75BE;
	Tue, 17 Dec 2024 17:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455697; cv=none; b=Lz4lEI3qJJ6Jojmjj4IwGjbCdZZvYdMCk0l3U5jMRByJjb2olBVZdrEs46sJopdoXEwPQbtsSlJSZLhA0j036zxCl824wqG2T7IR97broRh4LTyu0dkGinp74eSQO8LUsothpRCmVbVmxqgH5Qqv+Nnl3Bc8l5DO4pbM0DKvhL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455697; c=relaxed/simple;
	bh=2PtQ1RMt1frEg+J5hgzJBkcBUjybBqVkNduvforxj3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGBBqE8Uq2WhjmiV7TMRZaIIqOsVPUMcVw/L6wbSUODZevFllPztlaGeFHllrihH2+WcRl/j3VzjTK+qWeJWUe/InBg+Z7zrijxC/ZglJMmqOilKQ48lLPkWzN9lrM6KVaOchFofsEAE7wxjNN2yjGgbRAPjKqhGOjy7/29/JD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1w7imke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1w7imke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BB8C4CED3;
	Tue, 17 Dec 2024 17:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455697;
	bh=2PtQ1RMt1frEg+J5hgzJBkcBUjybBqVkNduvforxj3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1w7imke5QWq/zrYPt1Es6cgmmbzx3fw82OjLufml70W9HUvaHIuajvUdrCeyvWHd
	 H2oFcNwFo14GJTXzn8d2JhoWLOLOcbqtFpkhORERfP5833NLzDMxxlBm9ntDWxP/MQ
	 5KEo/9EFrvQdxuqOhr7xmc9XBzHqSGpYQzChyeII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.15 13/51] xfs: return from xfs_symlink_verify early on V4 filesystems
Date: Tue, 17 Dec 2024 18:07:06 +0100
Message-ID: <20241217170520.849649167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 7f8b718c58783f3ff0810b39e2f62f50ba2549f6 upstream.

V4 symlink blocks didn't have headers, so return early if this is a V4
filesystem.

Cc: <stable@vger.kernel.org> # v5.1
Fixes: 39708c20ab5133 ("xfs: miscellaneous verifier magic value fixups")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_symlink_remote.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -89,8 +89,10 @@ xfs_symlink_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
+	/* no verification of non-crc buffers */
 	if (!xfs_has_crc(mp))
-		return __this_address;
+		return NULL;
+
 	if (!xfs_verify_magic(bp, dsl->sl_magic))
 		return __this_address;
 	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))


