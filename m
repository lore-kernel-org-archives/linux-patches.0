Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135734B7A46;
	Thu, 17 Sep 2026 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660755; cv=none; b=gTK6BWO5xB6KWoMIvm7m4mQjztU58VssQkTHGO8FgMnQxMkJBu/yt+QizauzCFDpaeqGuYxJaKf1shN3Uy77BvgdiwvxvPk+Q8JuI6f+99RHn4KWwyhuH27m1Ky0hbl1XQ9mhipO79ZIQtoBMibBCY0IWkiVrOwB9yOcT/7fs4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660755; c=relaxed/simple;
	bh=vRlH2sz+8KM5gweGamPYBcahAzgqKbKy6mUNzVkwo2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njTse4W44tQtHZr5KawX1zzmkoWdNzyUeDKuEus7dtd8OsXjvrBQbLsnfHCliD9eDb8VpDcQ6VQQvYR7kF20MU6k6se2ed6SgMTh0CwYFe5TniOzQc1V3DwFGLXVE+rHthof9nx3l7IBjJqqGMgnDMm58S40ZPmzBn4WKfxJbTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdtSm71w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdtSm71w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F8A1F000FF;
	Thu, 17 Sep 2026 15:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660753;
	bh=iJRWsLmMy753JQB4LsW41rvXfHzoHkreP+bqRS2XOBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdtSm71wnCqNh7XFhtIzvh5kZaIYJsaCD+ns4lOUD9EN4HMm7oXN6+oj2+jDgZGSB
	 9jhwQ01VSStmrqMRaYIvIgHEc1e/BFqhQZnCgMSUDBO1bwH7y3YSXX0qvOxAonkQ95
	 pA0erHgu6EapocPNbF3lE7mEiDOjrgGzDMBwIFmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 661/733] xfs: fix short ifork reaping computation in xreap_bmapi_binval
Date: Thu, 17 Sep 2026 16:16:09 +0100
Message-ID: <20260917151409.145444416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit eacb8479507756c3305994e87fb2fb1183827e98 upstream.

LOLLM got really confused about the update to imap->br_blockcount in
xreap_bmapi_binval if xreap_inc_binval returns false.  The intent of
this code is that we shorten the imap to whatever length of space we
invalidated so that the next iteration through the loop will start
wherever we left off.  Unfortunately, the calculation sets br_blockcount
to the amount of *unfinished* work, which means that we pointlessly
re-scan blocks that we already reaped.  This is benign, but we should
fix the computation anyway.

Cc: stable@vger.kernel.org # v6.10
Fixes: 5befb047b9f4de ("xfs: add the ability to reap entire inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1399,7 +1399,7 @@ xreap_bmapi_binval(
 			 * far we've gotten.
 			 */
 			if (!xreap_inc_binval(rs)) {
-				imap->br_blockcount = agbno_next - bno;
+				imap->br_blockcount = bno - agbno;
 				goto out;
 			}
 		}


