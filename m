Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A78E378838;
	Fri,  4 Sep 2026 06:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502089; cv=none; b=sYipSQ0EglWLmkCdceQkZSUPBbEr8AC8rjr2JKejIXQwW4Fo1YVe1sR9J+lei95B2NAhJaL62VPM6CVU8lsotBJyIL4lfQQLUdwiB5bnYR1vHkNqxmSCg1Xq7sGA+wY+mBRw6FjzIC+2K0BycUFTVlVHNfF0/yWDBxCNaMb8tgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502089; c=relaxed/simple;
	bh=9F4m3+tLiUcMm2RsjdAUmaDK5UF0eO32LAyyvc+hFyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBwuE2miMVNhpXTsKgJ96mdoLElSDnz8u4JyXiLHMsgD1I1Y6rSPrKjAC2Y3ch6GFswcmgingxlcpwN1dQ/NlSlNA76QMQwGADI3XjeV/AYmQ3zmfJ8uUeBQ/RCoriI1ZUw8Nc7z1Evy2uaYmfCiOOmN/Dn4lUq3vDJ5y5iJ/LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmXfOuWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmXfOuWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63A11F00A3D;
	Fri,  4 Sep 2026 06:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502088;
	bh=rinHMll7nRZV1CXWU/wa6HtP0iTYo8WjtA4fwYQG/VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmXfOuWi7OdKYAFC5wcaVdCcjrS0U1ekLXp6dgjC3pToySe99AqV1WHjLnd9sHwgH
	 5UzfkybA56zvfjGFYiIsk9haMbdsorGZ6lLZYRz1Ht/Xr7DdUVGSQCN0wAna0xZVSu
	 +kYRFN9mVV2oEV6Ja/PumxQsgBhLoW2n8Mj61xmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 083/403] nfsd: add fh_want_write() for early-verified SETATTR in nfsd_proc_setattr()
Date: Fri,  4 Sep 2026 06:58:06 +0200
Message-ID: <20260904045736.719308798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 4e475be769aa9f7a2c1ce55a2b8592cfccacddcc upstream.

The BOTH_TIME_SET branch calls fh_verify() early so setattr_prepare()
can inspect the dentry. This causes nfsd_setattr() to skip
fh_want_write(), so notify_change() runs without a mount write
reference.

Add the missing fh_want_write() call after the early fh_verify().

Fixes: cc265089ce1b ("nfsd: Disable NFSv2 timestamp workaround for NFSv3+")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-11-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsproc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -81,6 +81,7 @@ nfsd_proc_setattr(struct svc_rqst *rqstp
 		.na_iattr	= iap,
 	};
 	struct svc_fh *fhp;
+	int hosterr;
 
 	dprintk("nfsd: SETATTR  %s, valid=%x, size=%ld\n",
 		SVCFH_fmt(&argp->fh),
@@ -116,6 +117,12 @@ nfsd_proc_setattr(struct svc_rqst *rqstp
 		if (resp->status != nfs_ok)
 			goto out;
 
+		hosterr = fh_want_write(fhp);
+		if (hosterr) {
+			resp->status = nfserrno(hosterr);
+			goto out;
+		}
+
 		if (delta < 0)
 			delta = -delta;
 		if (delta < MAX_TOUCH_TIME_ERROR &&


