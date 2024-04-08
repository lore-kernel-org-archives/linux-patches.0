Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FE742046;
	Mon,  8 Apr 2024 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584507; cv=none; b=oiW0+eawtyvg/0kpUnqEl8gI2kTxEI1ugSyvBJugDNyqQKkqI918i70IFpLXNpODaFyK7DqdT1Rk853fZlRZlcfpJ561GdS00O847ETOUF4FYT+/HqhIlHYPDUDQmVZKnT480ak4xX8j3RnqWQ4+ZR2hWdIuyvAf3BgLUiNE7GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584507; c=relaxed/simple;
	bh=HiTDD1Alminbu0TF4f1BSLVgJ7VkehASixOasFvUZ2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzG4bp5n7Wov77g8EbFMA+ure0qXHsZ5fvahvq90PX4WYc2VouZTjWpwkqysPD/TTvs9HWm4ahKml+spTUJDpoEsepbOWd7veY+bfVqHUJguJ0CxIQw0eBezUFVRTs9+c7KLBA50iyypkPD/X+vsonJZSJPQyIml7RApmTmnJzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EROsOmT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EROsOmT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D351C43390;
	Mon,  8 Apr 2024 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584506;
	bh=HiTDD1Alminbu0TF4f1BSLVgJ7VkehASixOasFvUZ2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EROsOmT/Buj6H7pk0TsqyYWZlbklrIiZ9NhWDW6so+UQ8Ec4lM1ggX98Hq8uggBya
	 Jb+jf0kMy+mGBrqSaPcFQYZcBfHnJuT7eylkzZhd5vUKkqAuwuVjadItqeKFlKz1NK
	 Vd/bD3VEZWvMCq+e8b5eKpagdK79xwur6rB+0eZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 462/690] nfsd: ensure we always call fh_verify_error tracepoint
Date: Mon,  8 Apr 2024 14:55:28 +0200
Message-ID: <20240408125416.364325243@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 93c128e709aec23b10f3a2f78a824080d4085318 ]

This is a conditional tracepoint. Call it every time, not just when
nfs_permission fails.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsfh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index d73434200df98..8c52b6c9d31a2 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -392,8 +392,8 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type, int access)
 skip_pseudoflavor_check:
 	/* Finally, check access permissions. */
 	error = nfsd_permission(rqstp, exp, dentry, access);
-	trace_nfsd_fh_verify_err(rqstp, fhp, type, access, error);
 out:
+	trace_nfsd_fh_verify_err(rqstp, fhp, type, access, error);
 	if (error == nfserr_stale)
 		nfsd_stats_fh_stale_inc(exp);
 	return error;
-- 
2.43.0



