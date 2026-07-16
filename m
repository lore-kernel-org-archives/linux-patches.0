Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE506429028;
	Thu, 16 Jul 2026 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209723; cv=none; b=qJvO83GZAaLV3pGAJlo9cN4ZBuuhV80i/07HNAoXmZfp7l8EuCUB9QqZrCvmYsX5I4NeJZKOnSHEreyWBQFjs5oU7fM20tuFEV6DzFsk1KnvXQHuhrQ/wZ6WM2I2hjbtMaXgdVeD7es1KpOX7YIXKdGe9Htlp6z9jIKWKSyrvEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209723; c=relaxed/simple;
	bh=UJL6P6RayfyBF/3fiH7VMh006lRvm5GgFE8TjTHPWgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajgnC0yHAb+TtWLgkRMeiVn4IeRNCcENcxNY6LinGSMKEfWkqzQi1wjdbV1WAvVDN0piHWx/IaU7kzTCvNrAVg+ByoswW9aNL2IeiLpdaCCi4dPmsKv7V4XoZLxtkju1EUKMoAtnOhG1OhzFI9GbIN37uRdgG1/Pwu5b0THPF90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM+yDwec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM+yDwec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581B21F00AC4;
	Thu, 16 Jul 2026 13:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209712;
	bh=XTP/gUAc0vSRVIzQmGhiewMtXFDgJecIm4NQcQFPT74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bM+yDwect3Puh07ttJGSIF2O8pqRH8aQHc0Qd42b3xyC9FB97f7GOFVjfEvNdiCh1
	 u50OalLcYGLH+u3MEwS4kXBCsuDiIuXnQfj/GGzRehdOD/RB2wynThuiYKFhGn/rjQ
	 RZys3wklraRi5keybiu6hzKHkC5tXmZeSlqfISeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 289/518] xfs: fix exchmaps reservation limit check
Date: Thu, 16 Jul 2026 15:29:17 +0200
Message-ID: <20260716133054.143261737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingjie Gao <gaoyingjie@uniontech.com>

commit 0a5213bbff62b51c7d4999ac8c7e11ea57d00d45 upstream.

xfs_exchmaps_estimate_overhead() adds the bmbt and rmapbt
overhead to a local resblks variable, but the final UINT_MAX
check still tests req->resblks.  That is the reservation value
from before the overhead was added.

The computed value is stored back in req->resblks and later passed
to xfs_trans_alloc(), whose block reservation argument is unsigned
int.  Check the computed reservation so the existing limit applies
to the value that will be used.

Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Cc: stable@vger.kernel.org # v6.10
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_exchmaps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -711,7 +711,7 @@ xfs_exchmaps_estimate_overhead(
 		return -ENOSPC;
 
 	/* Can't actually reserve more than UINT_MAX blocks. */
-	if (req->resblks > UINT_MAX)
+	if (resblks > UINT_MAX)
 		return -ENOSPC;
 
 	req->resblks = resblks;


