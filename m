Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DF24E36C3;
	Thu, 17 Sep 2026 17:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666700; cv=none; b=SZyB/EE+SyPf7TEbuMBX0/sav0sXnLiSFJ9DHLGhqSwEcyjFsPcFVCVb+lw+X/c2cCy3Pxfo+sNm7PZukv92whkRmbqm2zspNXPwC3dN7vWWxKs43E5oF7ol2UlMkwaeaaYiBEEcJDhQxZB7Pc8qviiz5tUDSKRnb6cYY+vAjRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666700; c=relaxed/simple;
	bh=kwBS5djD8Oj4caVLNRVrmcrMcZs+UCKB80cWMB2g6Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdBag4LThHlPqoDmCFHZq94hpctV7Y3+4HQYZqNKJCW/XbFyH883nWvrsNwxQSgysK2BiZz0psY+YYl4gZ/yBtTZxyVyHcBa7sHSFtWeyM6/V3YQZJ+bUciKRmIIfG+R4X0FX0UOWqNPf4nCTvwphwWMtsYIA7qwmaB7JI9o3Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Myu/lM/v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Myu/lM/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598321F0089A;
	Thu, 17 Sep 2026 17:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666698;
	bh=4QtXbmDbTZ0LvTY5lmjpWhCCnmJKFt4BKSOfQNgXdEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Myu/lM/vkU2JdjlNSBu+wAuT5FiF5pEalbxZFV4aOcPxN77pzKHYJAal0kHsSckjx
	 zgS3DwqFk4Da12KLPDCLGvHeY/K+H6aXanTC72gYUoQFjjmhxmVG4MZMollYPrv7+0
	 l4OkVqS+IbFLutG3jP5NajU9UtoM4rhY00UTCJQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1124/1250] xfs: bail out on bitmap errors in xrep_agfl_fill
Date: Thu, 17 Sep 2026 16:15:19 +0100
Message-ID: <20260917151622.703761046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit eaf580538eb1be3d162400d04c4b7dc4c627296b upstream.

LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
can fail, but we don't check the result of xagb_bitmap_walk, so we
silently drop the error and proceed with inconsistent incore data.
That shouldn't be allowed.

Cc: stable@vger.kernel.org # v6.6
Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -699,7 +699,9 @@ xrep_agfl_init_header(
 	 */
 	xagb_bitmap_init(&af.used_extents);
 	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
-	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	if (error && error != -ECANCELED)
+		goto err_undo;
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
 		goto err_undo;


