Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7F5346E4F;
	Wed,  3 Dec 2025 16:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780872; cv=none; b=OvqiZ1YyNrEUPf4TkYlImgB9NvpuXSX4gZqVNQUHOdSqCAYoMovPLFfkZUiBwMLarC5QDpipm+sVGG0TArs9BxzRg+baqf5uEDZf64HGFzPvfm0vKZPnqppyBsL3Jp25I6DlbV2YhSpPYLhj153NqXUqou5mr3RwDOpFG6Mn1nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780872; c=relaxed/simple;
	bh=nPJC2YIX2H5ifBZJRrXFNbehIqK5P0HMqiNDpn4nj0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GypjX6FPBVP2Qw0ABXzBWOPaDiV4KAg6pp/a8R7MAhlFygnWMbXQMtgxAIhgh3Qtv991ehH/lOEXnnxHh1gJeRtSgiYD4osK8EY3DkjoJK5vMvko95OPKZLRGWjJScs1SKDJ9ruiCO3IKftPJPDHBrdCvzv/56yE/x0TvRKd8c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5r3q3rJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5r3q3rJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77684C4CEF5;
	Wed,  3 Dec 2025 16:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780871;
	bh=nPJC2YIX2H5ifBZJRrXFNbehIqK5P0HMqiNDpn4nj0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5r3q3rJ5XGALF7Mi+Lx99OD2loY1xouh10q/lnOPbx/bMGaEhRriPPArFaQHVkUy
	 LXrdn8InNM25CTftbg1RqzaWNI9WIKHPRW+kuPCBxeF23jnKd7L3ZzWteoBjmKhKgX
	 MrHrBjPlnY/hSBWqKA9pQMup6RoiQ7wfp/rHRtwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 115/132] nfsd: Replace clamp_t in nfsd4_get_drc_mem()
Date: Wed,  3 Dec 2025 16:29:54 +0100
Message-ID: <20251203152347.573843607@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: NeilBrown <neil@brown.name>

A recent change to clamp_t() in 6.1.y caused fs/nfsd/nfs4state.c to fail
to compile with gcc-9. The code in nfsd4_get_drc_mem() was written with
the assumption that when "max < min",

   clamp(val, min, max)

would return max.  This assumption is not documented as an API promise
and the change caused a compile failure if it could be statically
determined that "max < min".

The relevant code was no longer present upstream when commit 1519fbc8832b
("minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()")
landed there, so there is no upstream change to nfsd4_get_drc_mem() to
backport.

There is no clear case that the existing code in nfsd4_get_drc_mem()
is functioning incorrectly. The goal of this patch is to permit the clean
application of commit 1519fbc8832b ("minmax.h: use BUILD_BUG_ON_MSG() for
the lo < hi test in clamp()"), and any commits that depend on it, to LTS
kernels without affecting the ability to compile those kernels. This is
done by open-coding the __clamp() macro sans the built-in type checking.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220745#c0
Signed-off-by: NeilBrown <neil@brown.name>
Stable-dep-of: 1519fbc8832b ("minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed_by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Changes since Neil's post:
* Editorial changes to the commit message
* Attempt to address David's review comments
* Applied to linux-6.12.y, passed NFSD upstream CI suite

This patch is intended to be applied to linux-6.12.y, and should
apply cleanly to other LTS kernels since nfsd4_get_drc_mem hasn't
changed since v5.4.

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1984,8 +1984,10 @@ static u32 nfsd4_get_drc_mem(struct nfsd
 	 */
 	scale_factor = max_t(unsigned int, 8, nn->nfsd_serv->sv_nrthreads);
 
-	avail = clamp_t(unsigned long, avail, slotsize,
-			total_avail/scale_factor);
+	if (avail > total_avail / scale_factor)
+		avail = total_avail / scale_factor;
+	else if (avail < slotsize)
+		avail = slotsize;
 	num = min_t(int, num, avail / slotsize);
 	num = max_t(int, num, 1);
 	nfsd_drc_mem_used += num * slotsize;


