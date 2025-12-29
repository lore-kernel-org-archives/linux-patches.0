Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F88433121C;
	Mon, 29 Dec 2025 16:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025845; cv=none; b=XWQIOmircaf2BhJELl6ariBA+Vkjah6sZbYPdQpFL6+6jhWLzHQ34md+sS0odYsBWqkrOqSvwZSmtAKUS6eWTkfrd1bx7jenxaE7tD5veP460LeH8+f7c4JbkX3kS+75/hkSBdq/6blsxfZk05oS67OxDa88OgiYKLBmPFT8XWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025845; c=relaxed/simple;
	bh=4UBK82DwVJxMq74w+qcKKoB8oXMK+/aARC+agTCkSmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kexJGVu8sTMV/taiprH5WzliI01mA3XbmTFHQRFh+EwFcAcz7gdqh3sP6pRJdNpQpcMxo+uoMhnXP31nVgS8rFU42z79uow7Jwoe+Lf42C7AwOxMBtmGJGqyySoNJ541Nyib8OLQezWbSejUa6xVJerJaJLGYKu/g4hwcT5+rDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKjJUCv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKjJUCv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A37C116C6;
	Mon, 29 Dec 2025 16:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025845;
	bh=4UBK82DwVJxMq74w+qcKKoB8oXMK+/aARC+agTCkSmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKjJUCv/t4OHCvH0VMG3c3Lh3axBjGeHokkuN8kA/j8IhFmJ9P909KfySMt3aLNaZ
	 jIP0+1ExmfWAIoDKEURqXriIhDstf34aXg0aSr7qI09PYuY39FRHRvrFQN4y0j4JxX
	 h8pRBoduBZJGITeH0rtizaL64aVNeeLn+LLWBOQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 358/430] xfs: validate that zoned RT devices are zone aligned
Date: Mon, 29 Dec 2025 17:12:40 +0100
Message-ID: <20251229160737.502760219@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 982d2616a2906113e433fdc0cfcc122f8d1bb60a upstream.

Garbage collection assumes all zones contain the full amount of blocks.
Mkfs already ensures this happens, but make the kernel check it as well
to avoid getting into trouble due to fuzzers or mkfs bugs.

Fixes: 2167eaabe2fa ("xfs: define the zoned on-disk format")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: stable@vger.kernel.org # v6.15
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_sb.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index cdd16dd805d7..94c272a2ae26 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -301,6 +301,21 @@ xfs_validate_rt_geometry(
 	    sbp->sb_rbmblocks != xfs_expected_rbmblocks(sbp))
 		return false;
 
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
+		uint32_t		mod;
+
+		/*
+		 * Zoned RT devices must be aligned to the RT group size,
+		 * because garbage collection assumes that all zones have the
+		 * same size to avoid insane complexity if that weren't the
+		 * case.
+		 */
+		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
+		if (mod)
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.52.0



