Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7921F7582;
	Tue, 17 Dec 2024 17:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455839; cv=none; b=cfMCiN1aZi3rsW1aek+JKwybfq0FzG5zTDknVcI7K0tE+hsf0c8XVNpQGXUHl47d5CWrx4b97xzUVcNZ+2UtF/fzA7/IwMnJ2goLUQ+evzfbi4TDomjE1bVb98rAgm4IQNXmfwm7NqJYuF3o1TjlhyoCcw8QZTd9gQl5CNNMDGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455839; c=relaxed/simple;
	bh=hOAP/W4+xOLbLzSrZDL7u08T+xcsYTuux/8TOrAQXm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIVjv83p8idk/mI9K6KeOYrzffpbPlpoXgOfwvo+GaJWa9kshRRgEkze8R+Gns7X3rrVH78nzWXZx5hO2tgoi47y8DqezwO3G9FiHXmELYAVsI+Zb2704Gth6IbusTqs5insGZDBlpfsyth+0FpUmSjGZIJv2lGQFJBIcEJJZkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fupNLuDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fupNLuDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FD4C4CED3;
	Tue, 17 Dec 2024 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455838;
	bh=hOAP/W4+xOLbLzSrZDL7u08T+xcsYTuux/8TOrAQXm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fupNLuDYXSl4hoZr8OBBG9yyX3L/UGftAi2zFQcPTRceMuOh9iE8hH9iChlKr1qN6
	 j6iFp8n5qV+s2JwKmHGCoRSL06pHIxJK5j1gpaLQn/PU4HOBA/+FyexESePwxzNqeC
	 G0xFyZHCKSroQGclkl9QRjVV8PRfgRfuh2vy0DV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.1 19/76] xfs: return from xfs_symlink_verify early on V4 filesystems
Date: Tue, 17 Dec 2024 18:06:59 +0100
Message-ID: <20241217170527.050878728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


