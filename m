Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6C31F7582;
	Tue, 17 Dec 2024 17:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456477; cv=none; b=emz1Mlztu6LKV5zffsRJS2O7X7tJCxE0v4CYqle/9RE5Dg9rFt8K01bRbdqhrLZJZo8HZqCUxSOS0pwhDQ7HKd9xHNXfqlWrD8IBB6VDyGm9jpPqtQU+G/N8YPzmxicfY1tTu8fDhlV+qwlyINcO92cXkLWFKqhcUrK7eQhzvGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456477; c=relaxed/simple;
	bh=TaaSPIM91nOYMcRpHJER/lppiPfhmPBbNO+M5Yf+4Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0o031DDkKpIXpIdNajCbf4DR0oIjVmBd8ganZuoNbSqBYo04dfgq/8asFPDC5eGSj8aUJ4pE2o0ApYqht8MPQyCRvrtiyXMxBeUNH2VZueUeE6laeRo5c699v7mRbObf0Gu/s+PI1f5cqf0JmL0a4a8JovajfqjCpr/G6Dom7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGAPIvFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGAPIvFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258E2C4CED3;
	Tue, 17 Dec 2024 17:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456477;
	bh=TaaSPIM91nOYMcRpHJER/lppiPfhmPBbNO+M5Yf+4Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGAPIvFWUWYBoxCL1fmsh5iN4DYafJArJSsjeFrRHVLw+m/whUvMOkGxbt5hfSRQ0
	 +JFvfpN1iaDpOz6RgnGZ+oGRoHk/MSm6xxhPKd54Hb6yTvF4WHEwnk59cxzPjuyMuu
	 5KOSuYvFFvQMAGrvco1WolE7NyMCsZQYF774VXQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 072/172] xfs: return from xfs_symlink_verify early on V4 filesystems
Date: Tue, 17 Dec 2024 18:07:08 +0100
Message-ID: <20241217170549.271146465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -92,8 +92,10 @@ xfs_symlink_verify(
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


