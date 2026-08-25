Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B2E47D475;
	Tue, 25 Aug 2026 13:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664628; cv=none; b=Qkhbd9aYdRI5qJC+CV9fj0h49rcAMhwx6Vu9hPxNLN66MksFkWB/nn0exzRHNFwHoVbuTS6TDmIJqHuigVJSj1CFamLdRSmJlKI7mFIWFmZkXEn8VnM7isP4U3ed6lxMSDCMWj9E2D84Cagc3eJPg2piT/5sl2Pu9OHVYOldg1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664628; c=relaxed/simple;
	bh=BYYqltCjzs9sH/LwdT5Kd3pGhO230tIpY9IR31uULX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MID6wBXtZl8DVWZ/GSFzCaNga4Vf+PHa/oUDcuUgH2lhm7Ew11V/FbQehvaPC0zYj0ntPpuE/zZqRpor10pH2VBiE5e9mRfMCXO+LrRwFPA2LF2WyQ6HAIGRuIJ5TfDRFZEliNbE18rJFMG/2zSClG6MeQOBihiIU/rs+idt/lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdUEqlHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdUEqlHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64701F000E9;
	Tue, 25 Aug 2026 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664627;
	bh=52RvFp7q2SFLpZyZIoRrIduRIxqD1y7jhKxWTtlztBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdUEqlHzAgh6bApSN4BJf7X3gwOb96iMqsaU89II0GVA7aWtmUO6sZASh77OLxpL0
	 KfdPKJj1XVwJPbFnvpEQqWPHkLN3Kiz2lxExgP+6lAWzVSQDFBL65j3hudDVDfMa+6
	 SHMTfjaoSBo1MXFm2OU7HFV5b1+zQANwXeJ+7BH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 32/82] xfs: validate attr entry pointer before field access
Date: Tue, 25 Aug 2026 15:25:19 +0200
Message-ID: <20260825132542.766642559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

commit b7eea80be25f3334f131d52982b3131aba77b97d upstream.

xfs_attr3_leaf_verify_entry() accesses lentry/rentry fields (namelen,
valuelen) before checking if the entry pointer itself is within bounds.
If nameidx is crafted to point near the end of the buffer, these field
accesses can read out-of-bounds before the bounds check at
name_end > buf_end is performed.

Add explicit bounds checks for entry pointers before accessing their
fields. Use offsetof() to check that the start of the flexible array
member (nameval/name) is within bounds, which ensures all preceding
fields are safe to access.

Fixes: c84760659dcf2 ("xfs: check attribute leaf block structure")
Cc: <stable@vger.kernel.org> # v5.5
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -325,6 +325,13 @@ xfs_attr3_leaf_verify_entry(
 	 */
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = xfs_attr3_leaf_name_local(leaf, idx);
+
+		/* Validate lentry pointer is within bounds before field access */
+		if ((char *)lentry >= buf_end)
+			return __this_address;
+		if ((char *)lentry + offsetof(struct xfs_attr_leaf_name_local, nameval) > buf_end)
+			return __this_address;
+
 		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
 				be16_to_cpu(lentry->valuelen));
 		name_end = (char *)lentry + namesize;
@@ -332,6 +339,13 @@ xfs_attr3_leaf_verify_entry(
 			return __this_address;
 	} else {
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+
+		/* Validate rentry pointer is within bounds before field access */
+		if ((char *)rentry >= buf_end)
+			return __this_address;
+		if ((char *)rentry + offsetof(struct xfs_attr_leaf_name_remote, name) > buf_end)
+			return __this_address;
+
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0)


