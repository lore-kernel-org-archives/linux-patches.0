Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DB347DFBF;
	Sat, 12 Sep 2026 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219848; cv=none; b=HTz9KlnUkk6y0x4YWHj1/VnomRVr+c5yPgTVpLEn9iLfs84Cvsb/Pg+vIwXFgsocKi2jQmmg5LFUlpECgKae/5D1AdTlXODVuhNk70rDLyP0mMsxyb+gl4Audpf29I706oIjKTB4jlTdBoroALY1Ur68qUKI7Ovz4blFqb5t9JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219848; c=relaxed/simple;
	bh=n76rzQs5PRZGPYbhRnmzF7L8Dmd/pcbUglZnDHLoXbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKjtCOPYhDDn+oMCGBLk4auDeMfFTJXqn3Rs/ZzlGZPH69bYwZjkFUR/E7oCTip7nqVcwhKNyV7PlIJfdV7q47Ff3PHf0/WMk1Jg9WILVbHeLsupozOzZGRENeIyU3zq7U4T6NAUN+qKjDJNsSLYMdz1XXS43EjUpm0Us1/O3Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLZPtSHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLZPtSHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA63B1F000FF;
	Sat, 12 Sep 2026 13:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219846;
	bh=4LxM2c85NrU86cZU2ccIDr49nEOq8Z6+cnR3xSHgK2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLZPtSHB693yxgrLRhJV/l2RDiEC7EV4tAgVwjG1wwM2636lgaeFEHVzW/1fA0+Ot
	 7IS2H6hq78cd7dorquOlG+Ig+3e2sr3j1zPVZ0DVp4WAbGFSVXkJ/ZRxb+GuD2QbE5
	 EClGPvlk8ZSO2X4oetqTxNC1yApRIN26/suidLMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0056/1424] nfsd: add fh_want_write() for early-verified SETATTR in nfsd_proc_setattr()
Date: Sat, 12 Sep 2026 08:41:28 +0200
Message-ID: <20260912065608.556641062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -55,6 +55,7 @@ nfsd_proc_setattr(struct svc_rqst *rqstp
 		.na_iattr	= iap,
 	};
 	struct svc_fh *fhp;
+	int hosterr;
 
 	dprintk("nfsd: SETATTR  %s, valid=%x, size=%ld\n",
 		SVCFH_fmt(&argp->fh),
@@ -90,6 +91,12 @@ nfsd_proc_setattr(struct svc_rqst *rqstp
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


