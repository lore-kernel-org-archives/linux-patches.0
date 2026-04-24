Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378B73D75C1;
	Fri, 24 Apr 2026 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037994; cv=none; b=GFZMeGTPOmX27XPx5D3YdBtyihEy/Gd+atV+xqDfNQaC/GaDH3uAZqJ5XKlNcsPKzYH1G28BFnjAc5Do6BcvT0pQeVvZJ/ce5AqLAqzHqxrTsu9Q3IiHqSORwxMNVvptOk/EcpN18rkdXoSiav1M35CwhPi0w5ADdAkGo/nXQiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037994; c=relaxed/simple;
	bh=Tf3xFCkTaVlSBAG8MYtOn+FGgNTU2OHT6GzLUC7419U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/lsxaW4Z6/1dCKjV3D6ufqcmiKRowZ1ZbSXVOhVsxVasl1fmw4A6PLfcGdDX6rpGhay07P7I/JJVKY/s3hG6ih9DShTTHdjMCE/7dyWR/vLGyIeDgLbh8tDuYYGDl+sT10mqO9uIwi1Lw+9Z98OtdycT1C2eT/jXeDdVMYrwDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnCETz3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnCETz3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A99EC2BCB6;
	Fri, 24 Apr 2026 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037993;
	bh=Tf3xFCkTaVlSBAG8MYtOn+FGgNTU2OHT6GzLUC7419U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnCETz3oLjHbQ9BpagEXsOcB32KJx9JpVZqrEQPK/T0hjjBxnp/IFFFokcrY6lPN7
	 q7U21lVY1VpNwqQPs+Bw2aBC4j4r+340FbIwq+dDGndKC33c29/ALA9l13XvDcAU4s
	 LxBSfu5hZZ9El2ShnvH2ctZ/r7ZdgFnwxHN4Fj5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 148/166] fuse: Check for large folio with SPLICE_F_MOVE
Date: Fri, 24 Apr 2026 15:31:02 +0200
Message-ID: <20260424132604.130673069@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -823,6 +823,9 @@ static int fuse_try_move_page(struct fus
 
 	folio_clear_mappedtodisk(newfolio);
 
+	if (folio_test_large(newfolio))
+		goto out_fallback_unlock;
+
 	if (fuse_check_folio(newfolio) != 0)
 		goto out_fallback_unlock;
 


