Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1AE519E1E;
	Wed, 30 Sep 2026 17:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789765; cv=none; b=UtMPJBqlgkDr83fZTfsWkyCNqmiGaYPaoFUAZRtBpPavcjPmDhNopsMw/4jH/UhmrKPI1RCa4aQeJg7RSXvlXlVAjh6NxEEgb8e/aycKRO/hNttT9crrBWAp4JuiSfodKVJwHchJAdVk79NVwKig1JhoiyC7dU09sezXRDv6NuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789765; c=relaxed/simple;
	bh=O7rJj5hEss2RERicKGPy+mB4jqYfj2JUN6/b7ratfoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgYXCKeOqx6p10GxW9raRxNKl1ipFnc0ihMiGS7JYFhEdywjjusd6iajlMxrKFVVa97B4xyhVRZFxR5QCIZagVuiGyog3kplUifX4WxlOAvcH6w3eFDbX52IRDNjblvQaURcGSh3S5W4UuhQU3ZLxwntidqJnokh8iJe5KqJA8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcbQo87F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcbQo87F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49D11F000FF;
	Wed, 30 Sep 2026 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789763;
	bh=yC2rZq2VimIjAz3f527zM589+f8onpW7l6ZHWlOza10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcbQo87F95idexj3nGyWKGDDb+DeBMFhQAau2goyhxXP4F8uTmpC++GwNTZcGw0FR
	 IFgjLnbGNB1bF6PX89Zjuo3db996SN8UxMYLKG8e83pN/on8nMiQB03t63gTfMWJVe
	 46e10rE0DNjoES5tusW57W/P4P5apRGiCrbi5Esw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 547/877] xfs: dont assert when XFS_SCRUB_TYPE_HEALTHY scans return corruption
Date: Wed, 30 Sep 2026 17:24:18 +0200
Message-ID: <20260930152426.443682434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit afbccf99f7f82117cba9ad4b0b006692030f49e8 upstream.

XFS_SCRUB_TYPE_HEALTHY is a synthentic scrub type so that xfs_scrub can
tell the kernel "Hey, I finished a scan and saw no problems" and have
the kernel forget that it saw indirect evidence of corruption.

Unfortunately, as LOLLM points out, it's possible for the health system
to record a new corruption just before xfs_scrub gets to
XFS_SCRUB_TYPE_HEALTHY.  In this case, the existing logic doesn't return
early and instead wanders into unknown regions of type_to_health_flag
and trips the assert because HEALTHY doesn't have a group assignment.

Fix the logic so that we always return early for a HEALTHY scrub type,
even if we decide not to call xchk_mark_all_healthy.

Cc: stable@vger.kernel.org # v6.9
Fixes: a1f3e0cca41036 ("xfs: update health status if we get a clean bill of health")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/health.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -192,9 +192,9 @@ xchk_update_health(
 	 * there's no sick flag defined for it, so we branch here ahead of the
 	 * mask check.
 	 */
-	if (sc->sm->sm_type == XFS_SCRUB_TYPE_HEALTHY &&
-	    !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
-		xchk_mark_all_healthy(sc->mp);
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_HEALTHY) {
+		if (!(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+			xchk_mark_all_healthy(sc->mp);
 		return;
 	}
 


