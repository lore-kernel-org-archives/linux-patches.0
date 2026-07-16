Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649C5429810;
	Thu, 16 Jul 2026 14:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211089; cv=none; b=q+k4CRmmPdPWbf0SC4bouuYiIE2ZvxHHTpx+JBbERZhFnggi3QP9q/68Nh78L0G0maFnlTv0ZuhUEVS6xv4238gZipTPGBge75Tvfbg3lgUE1qVc2F47CCOhhMs6BfdTs09AhHH1MFDQPlSl2y2/QWYMfaF4OA3RqDMxessyjEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211089; c=relaxed/simple;
	bh=yniE8iQMiYs/s5aSm2ZeylZoEAPlVF0LJAQWkDF90rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEP1l1duy8rd3tGIjuBiQxpbP4TuceXz8Trj0DiZeeHkwe6Ba98wY1eh4r81tDvJaqqx7gtNt/HpmXO9ttPwss3XLHWhJVt1EeMXgA8hJWF2aNxTFKxBF2JQnoiKnSMfoa0jUAzcAam5B6Y/Vnv6w0X/Ufhzh0Y2cb4eDoxwaQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6Wtxq0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6Wtxq0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE24B1F00A3A;
	Thu, 16 Jul 2026 14:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211088;
	bh=fiIf/YJPkvaqBm+3QqvnLTr088t+668Ye86DMQCrLCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6Wtxq0xKLubna8RLlha8JXUCHuVdd/voW+9rTWPqO/RlXmyAe62r8pTXl5aUgoFF
	 kibIoUhzUdpUsJumvJ7TypuHwXNjggovtJwTA+y5DNzCIvKJz8pkILSFB2OMBHXel6
	 9riCmBJszAHj7r5geUidlZbg1Uz72DdMKR02w7g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 278/480] xfs: fix exchmaps reservation limit check
Date: Thu, 16 Jul 2026 15:30:25 +0200
Message-ID: <20260716133050.838827010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


