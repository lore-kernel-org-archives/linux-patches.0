Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F383290A5;
	Fri, 24 Apr 2026 13:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038122; cv=none; b=GBY4WZ+D0FuK3md3bN/afTTTDf3KS9eStpQa3WjA88dhApo7QIYWO0961aPnkKfFNLHkwXLUezSnU3jCQ1EqPNrbOD6vbo3d1/VaOEeJ39IDDp1GV0r0nazoj9kAYdqnd9UcPs7G3zkm1coQxjo9THxKg7Xv+Eg3F4w+3ltDo/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038122; c=relaxed/simple;
	bh=4XNgBZMtRgy7nRUqR2fU4fpeIiTGM9TRLNmi84nyOV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgPJ5P35TGWYTg0ap94QX+zi2lDecWu+E0L0bv+NBDsw/jbjjz04lQzU3xXQvh/RbWxxX2bkDQKS0DldOlBmKlVsnEDa54O0Ssi2CSIZn/Skms6CbgSbgqzqRTRWw+SdmRm0jdxgcXmQisvzqAM49uke8biWuIyTIvYHkDEDTuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUn/WDlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUn/WDlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C04C19425;
	Fri, 24 Apr 2026 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038122;
	bh=4XNgBZMtRgy7nRUqR2fU4fpeIiTGM9TRLNmi84nyOV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUn/WDlmJ5E65HnSxzPp+Pz1kunW8UHyCrD2HnCn2d2TDWzD7rypbWFQRMdWnOjrF
	 xPiKn/zEcI79iHk6cYQU1ChDyIljXDSE0RL3q5udhATB5QpXzatSHLK58IFLlyRIgL
	 fBB5vGZMVpejiRUXIZfy0ksvwsspdH+6bh7EjdJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 33/55] fuse: Check for large folio with SPLICE_F_MOVE
Date: Fri, 24 Apr 2026 15:31:12 +0200
Message-ID: <20260424132436.893746180@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

From: Bernd Schubert <bschubert@ddn.com>

commit 59ba47b6be9cd0146ef9a55c6e32e337e11e7625 upstream.

xfstest generic/074 and generic/075 complain result in kernel
warning messages / page dumps.
This is easily reproducible (on 6.19) with
CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS=y
CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS=y

This just adds a test for large folios fuse_try_move_folio
with the same page copy fallback, but to avoid the warnings
from fuse_check_folio().

Cc: stable@vger.kernel.org
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Horst Birthelmer <hbirthelmer@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1017,6 +1017,9 @@ static int fuse_try_move_folio(struct fu
 	folio_clear_uptodate(newfolio);
 	folio_clear_mappedtodisk(newfolio);
 
+	if (folio_test_large(newfolio))
+		goto out_fallback_unlock;
+
 	if (fuse_check_folio(newfolio) != 0)
 		goto out_fallback_unlock;
 


