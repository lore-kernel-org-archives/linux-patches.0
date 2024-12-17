Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9E41F8697;
	Tue, 17 Dec 2024 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456460; cv=none; b=e9tzNBTAPM5GTyq7bQGQOeRWew6IIbBxmVF4HPQFD1/u1xj5Mtidb1+YJvbBaKZ9gRFYJV9Hpz+f9FJcOwfnKjapdJizQEWYYQXuKLZhm6nuwd+pZWdCNi/uS/ilr4ohBROuKac1kqt4UIQdQ4qEhKT+3K6VHK1vxcmWRMpQlqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456460; c=relaxed/simple;
	bh=nk7+KI+1MXu0pZmIbV8QC/nhc27Q8/4fBZPu8bi7DtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyoRJ8gTVWo1NDHCgT/NbV9Xvf8g30+fDImkIzLXzL/mQbHJnqViTECrsEawRrZg27S7Z3d7z/yuavNI9DMnxEdM8pB9L7Mfpqm5ZRPHdObzF0/cs/eXv1fu8F45ewHrrOpn6h4nsh9UBooY9nqhe1OR0JEirhcGESOwsL8gaUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jivEB6w1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jivEB6w1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E68C4CED3;
	Tue, 17 Dec 2024 17:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456460;
	bh=nk7+KI+1MXu0pZmIbV8QC/nhc27Q8/4fBZPu8bi7DtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jivEB6w1QyiHDcqSoeWVirP7eaoWPH5ZhNPZkKdnz7uJJ8x6HL+rgwCBJWFFFEyNC
	 SXaXbLcoQEpjD+Ct8fA3nh63N1Gq1KYEzEhh3YFgw4dlN91RgtvSKJPmJvT4p2BDBi
	 AR8VZ6/b632sqObqSeOqcbOhQoJ/72wWY/2yGG1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 067/172] xfs: set XFS_SICK_INO_SYMLINK_ZAPPED explicitly when zapping a symlink
Date: Tue, 17 Dec 2024 18:07:03 +0100
Message-ID: <20241217170549.058141516@linuxfoundation.org>
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

commit 6f4669708a69fd21f0299c2d5c4780a6ce358ab5 upstream.

If we need to reset a symlink target to the "durr it's busted" string,
then we clear the zapped flag as well.  However, this should be using
the provided helper so that we don't set the zapped state on an
otherwise ok symlink.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 2651923d8d8db0 ("xfs: online repair of symbolic links")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/symlink_repair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index d015a86ef460..953ce7be78dc 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -36,6 +36,7 @@
 #include "scrub/tempfile.h"
 #include "scrub/tempexch.h"
 #include "scrub/reap.h"
+#include "scrub/health.h"
 
 /*
  * Symbolic Link Repair
@@ -233,7 +234,7 @@ xrep_symlink_salvage(
 	 * target zapped flag.
 	 */
 	if (buflen == 0) {
-		sc->sick_mask |= XFS_SICK_INO_SYMLINK_ZAPPED;
+		xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_SYMLINK_ZAPPED);
 		sprintf(target_buf, DUMMY_TARGET);
 	}
 
-- 
2.47.1



