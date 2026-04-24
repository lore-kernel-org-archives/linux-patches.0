Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44833D6CA6;
	Fri, 24 Apr 2026 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037538; cv=none; b=hSByjIR/h0ifbpFk2WaCzlNl44uKGuhaWvk0OOx+T9OJzpqkImjKgn3R0b6l57UjFkXUwMOnog8q47bPGGidKDzSJIAAdb47gzlMudZNFQofrycl3GHUGMmu//7kVOqdfST8nkwx+hRvqt2VQs+oRZKLveeq7z8RBti/9pW2DTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037538; c=relaxed/simple;
	bh=Nk8kV05uvmowGA+bi33Czm49JFGfVM9BuvenyfwcM+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKjO5RmkhsgFSxuWDCNEW68fDzaEa0wfsqK8TrIOzNbCkvrae2u3DtXggqz4dkinJXxxH5WIJdnCv32crxtC4Oum6FKw3Nr3DnXb177anxyoDSq2KGC5qY3yZAI61xfPy7w/H5D3yTQtcY+oAs09RVv74k5IeRge0kXKEerCrTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFOenxDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFOenxDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37502C19425;
	Fri, 24 Apr 2026 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037538;
	bh=Nk8kV05uvmowGA+bi33Czm49JFGfVM9BuvenyfwcM+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFOenxDRbAmJTYTHkW351qQj/GUUPGdwEQ1GzankIrmWNgz037iaiz0Fx8txzLvOM
	 CrtP9LuX9xpLxFyCtuqeKsTOoV4fk+6g6yV02iZnpfwVtNmRI7pGAKb7o9rLA6pSgx
	 hMvRPKflVTgjUs8EjImm5JRLg+ljzlL3DOCXaMac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.0 17/42] fuse: Check for large folio with SPLICE_F_MOVE
Date: Fri, 24 Apr 2026 15:30:42 +0200
Message-ID: <20260424132424.120302930@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


