Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927A347CC81;
	Sat, 12 Sep 2026 17:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232583; cv=none; b=ZK4t2Oo58G+LbZtE8AjwYzK7plz7oYMgBp2ZfLiZQyo00Pc/rKMEAuTHs7UNoDTQNTF3JdhUuHlomdrrepDA5gTdmBrH2vouvmxFWMUdNat4CrwygBwz8DYV4S8OzT+TuAFyFJOH4Sesj4qJFs8uwQ66t3mbSI1JyEjrtJqhvJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232583; c=relaxed/simple;
	bh=KLkgg62gzCm4SOEJHc9yB7iIx0xnlu4g/IZOPNUxwO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwkwmlFyHDKAcfUmuMUEr2ZctVvnWvAw2c6v64Cuyh/FJpWWXB3NDYCdU39eTad5jFHcDb2JgVRK/XpEDoYMcirjVllMRZHCnS6H5NvZGJJx4clGclxpb57N8XEcuPT0JzyHDtjle6VWTTFLCwmEqtkBJkwFG9A3XkXR8RI6phM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPWZ++1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPWZ++1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F571F00893;
	Sat, 12 Sep 2026 17:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232579;
	bh=SU3prHDHXFSpge7Oa7+mNdiO/BWDY4w/R3VgTPrnTgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPWZ++1Z+/FP/VcUuY99a5au2ZGmnuyH9VqBYyuUZaKosCa5g+DTvzhM6IBGQ0zUZ
	 15qasMjUBThxMdtzDQVkhXB0xCNlRdsFdmVrFL/TYeXcEitehssVxN0pAm2aiPJG+O
	 umu8Npa2nRerJWegv+wlSkqTNdpS22rQ3UZY35mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 040/935] nfsd: add fh_want_write() for early-verified SETATTR in nfsd_proc_setattr()
Date: Sat, 12 Sep 2026 08:51:10 +0200
Message-ID: <20260912065527.758593718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


