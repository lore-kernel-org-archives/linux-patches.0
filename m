Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B213176EE;
	Sat, 12 Sep 2026 19:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240950; cv=none; b=iZVa6spnlM5CyZH6AxriqbrvQ0oZH1z1InQbajI3UO30/nNUcEoNfa2np2oNdSJGQlXmT8BCqEPWC8f9XWEVQ3zZdAcVvADDmKXevLf1Kc7aZg/xLBIy+2NlSG52xksTlxflZ69rX5afN2UUwZw4THYNsohIEUQp4NAbk13YGz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240950; c=relaxed/simple;
	bh=Ws4v/BSkeTqNGl/AJGdirqBh/ftTBMTm11msR0Od6xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noCLiV2FgDNAXzxSYtrm5xzXXNeF3y9RewMCbHVLc36YMeqzQdM9K9jJ254StPA21mEirt8m46XqbFLa+PxJ3bLfNG9y1TFdSbVoaKYp1t9bdCk73gqrfOcGDvs+RLRLPOVP+7615lMXvRnEQ64TBPs4Bru6yYQAwxkMCAR0qX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsr96t2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsr96t2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F821F000FF;
	Sat, 12 Sep 2026 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240949;
	bh=y6KAvL2zwiZPZG0LUfN+NVEVaoIcTtZs2//Ot1ArSyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsr96t2+HmySGcZgWbK+A4u1S2iEvhMpZ4ocvRKpx/pI74kz+GVgwvISAiysFTwjl
	 QKN+yD7J/Fsb4HHywsfnWGfGK9TjWlZ3FonSNuG9XI+0cgM4qOT7r8rpExxC2b9NNB
	 Zysw4pXFojR0913MZoKX5DvzhhEdf4JdNcfo4Lns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 036/798] nfsd: add fh_want_write() for early-verified SETATTR in nfsd_proc_setattr()
Date: Sat, 12 Sep 2026 08:54:24 +0200
Message-ID: <20260912065517.790675658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


