Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BBE42FCC0;
	Thu, 16 Jul 2026 14:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212142; cv=none; b=Px3EkOY4CfYOevjjP1GZo9/4zZD7npPZJKpUuC2jCfz+MJn2TKs215+mxxKv79sBLKeR8AYg8VasI/Zly17/01eP28+dyV79cnMCyQHbvCdt7hDZZmJFpofTOUYfQaSbZWybeJgTVRtENrrna2IVyCAK8EoUTOO8IRxTdc/9sec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212142; c=relaxed/simple;
	bh=vx7qoLJn+R8RO0QF7v2gbOW1+/Qxza7k9iOni78RykU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca7o9PElM4tjYhGlRCDC1XCIIlQ8t0Qrgno4KeFXnHRO+it5umMWMU5q0YneNgUWjS5tM2UsfbI8TYdsn+aR9RVJej8gZtd1qGEdBMLJwfKjXwYO+A0h2kkNVirsAdj3S2VIQGQuUK0FqEXz91nwwXQf2LifvLSXr8apdnvtm04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMCw0+tH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMCw0+tH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495EC1F000E9;
	Thu, 16 Jul 2026 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212141;
	bh=h8lbpJ0jNokKF38kxI6tcTS9lXePHcGx9XU7jz5HjuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMCw0+tHMefeOsUJmQYWpZovE5pUa8EO1GaAfSjOgmbg+2vPh0W9SOBp5iZ61iw50
	 nDHaawUCKH63q+A7OML2RYocc4o8ultv0ag9F3TNGzAbHPqxp6Xms7N+pMKLpZZK1l
	 vq1VmtuW6RH0ODq1dGDnKs5fh407cXGS5Sox7oGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 215/349] xfs: fix exchmaps reservation limit check
Date: Thu, 16 Jul 2026 15:32:29 +0200
Message-ID: <20260716133038.175439371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -709,7 +709,7 @@ xfs_exchmaps_estimate_overhead(
 		return -ENOSPC;
 
 	/* Can't actually reserve more than UINT_MAX blocks. */
-	if (req->resblks > UINT_MAX)
+	if (resblks > UINT_MAX)
 		return -ENOSPC;
 
 	req->resblks = resblks;


