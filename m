Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500BE42A144;
	Sat, 12 Sep 2026 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226785; cv=none; b=OTR636NTp+hKu8m0Lo5Jw1cyfLmCtxwQx8WomGIffbsGoYI9aU3iKFJni2Nr6qs4tuZ3xT/jkpEqdyyE52k8wU4/q6d+JM1ATegxGSBi5CyF08XnYHI+Bp3dr6sK+ECsz4QtkK9xQeZFs+LRTRTdybATEr37rA5tkuULyzbRqSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226785; c=relaxed/simple;
	bh=yDea6QMb2dxrGueTSq6z84nwPIdOwSU1RqNI1uM4x1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxSCZBYr8FXDfk1OryLwoqoS3dpUdyXLI+ngN0VzvAcw6dpQTqFFHvrPEuUgVgelLSi0zZEd4TMchD40XpW52/STSF7eRKDx+oTVMsytDokJyLJkVtFD+i+hJD7XoX/wE1dK7IIul/w6GSSyT/wDTn8YnsPwTwXmmcFTzCsvOcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17KzGyEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17KzGyEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D421F00893;
	Sat, 12 Sep 2026 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226784;
	bh=cQ2rEjh77DCds7IDY2rFhDpQRIrF6CuHslpmoSjkyc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17KzGyEkuRDvztP81aos4cTUElqz+3pX0yQXMoIG9VCF/b7PRQkMaCxoVYLlzmJpo
	 fEHJDg61/FSi+Mry+NzDttEbwWK3YC0npLGV6gFpCGkP2zQ/kJPqBVxNV0148h4ucB
	 hcbVCO+GzyCgsVgHLN6xxFrX6XMGFQ+UdtqPwPIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0047/1191] nfsd: add fh_want_write() for early-verified SETATTR in nfsd_proc_setattr()
Date: Sat, 12 Sep 2026 08:46:15 +0200
Message-ID: <20260912065549.196872599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


