Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DE9372B4B;
	Fri,  4 Sep 2026 05:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500630; cv=none; b=tWlaSJy5TWOjinRgKhmCzd9qe4mlJcZcCDwKf49/1x+EfYolGL0VxzAZ3eXqIU9b7YA0IHdxTe6BV1IiYRRDEezDg5t42PmdmIrmnXfPJas//3XgVjDccnpT2X8qgwKRcUx2hwYodxcRnfT9Hz3Ec5qJws/Rvvr6zCAFITls6wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500630; c=relaxed/simple;
	bh=idEYm5tRNHT6hpgip5cYYAdNXKpzVBGa6yqbAjGC048=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcVkUke1rTpNqJIt+v7A+j4jOHRtjoDkKXAqvcWODuEr552qkK9Lp8XU8Z9jlTpgnJJFaTOCC/TwswYsUiCabl35JtmpA9K2LBYApRCocoUwpP+5XKng7sM/jZc+sCPk8l4vGedQjS0xYgkF/Aurw5cH1pyJ/HCxiPz269cFz94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzdBlwVh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzdBlwVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B101F00A3D;
	Fri,  4 Sep 2026 05:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500628;
	bh=ksO4V8A9d3Lt3jOR7dRCecC+eZYItm9awuiTjvgb030=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzdBlwVhgpmoVwJVQ3wz4EMb0tRKBd6Jagj9gnLOmNOs9PVALOcfBhsMgb5656Pa9
	 A8OIaUFJlidopSk31C4wpIW+gA1O+PdR+TPzXznvBbZWo46s5CnyhSHN/Y5tFbzIWJ
	 WHWR9fa2aY+aprhsJ/+LHAPRgAdt/8/gV2AgtTos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 117/552] nfsd: add fh_want_write() for early-verified SETATTR in nfsd_proc_setattr()
Date: Fri,  4 Sep 2026 06:54:34 +0200
Message-ID: <20260904045750.627160464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -82,6 +82,7 @@ nfsd_proc_setattr(struct svc_rqst *rqstp
 		.na_iattr	= iap,
 	};
 	struct svc_fh *fhp;
+	int hosterr;
 
 	dprintk("nfsd: SETATTR  %s, valid=%x, size=%ld\n",
 		SVCFH_fmt(&argp->fh),
@@ -117,6 +118,12 @@ nfsd_proc_setattr(struct svc_rqst *rqstp
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


