Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DC082495;
	Wed, 19 Jun 2024 13:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803347; cv=none; b=bocuoK8zQksaSIOKwUhm2uOp1JJAeIJX37NTZVvYCQGi3QqjZ7Bvs7srmGycCgSSO7EVayz/Y5pdgllW8QI9em1T8i9wl3PJORKhmIz3s3FjtyaciWcqplt+v59ZsasbzP4U60vZ/4kbb7ICpZzwkWEEfgCERDd64Ff1fQDACG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803347; c=relaxed/simple;
	bh=d1RCdVl4fHjSL7Kr1EQ/etkPeMB9nFplqtIDIVEMAM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRVHz4QtFs+XN9Nu523mm9p437QQA6Qmq0mAZ+QyelucGQHZyxzAVXCWN/MD4YPpE2jl0rm4OjXbFr7+S2WiKRrtW756dtxsxe20UEE/fO2n4UKf6tWHf84akH/B1S6sgg4KAIB1Ulc5ICHGOW96hZ8c7lagR/hlTkOFWnoJx+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+5Om0lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+5Om0lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27D7C2BBFC;
	Wed, 19 Jun 2024 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803347;
	bh=d1RCdVl4fHjSL7Kr1EQ/etkPeMB9nFplqtIDIVEMAM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+5Om0lkE2I6jIat3MOUjNf3bpCdH8s7FHMp0z0bi2eEMqF6SYRs0nSGjEc8xj5EK
	 7WFQJW2wMSHjTq9YRGk/bhzSBa5xpYem3tx/3/rwoHSvsdcfqeyf+9QYGl6n4KSUdg
	 IBi++1gBazxlwhssO6CRvQyf2op+iyydwSuA0qJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.9 236/281] knfsd: LOOKUP can return an illegal error value
Date: Wed, 19 Jun 2024 14:56:35 +0200
Message-ID: <20240619125619.041918774@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit e221c45da3770962418fb30c27d941bbc70d595a upstream.

The 'NFS error' NFSERR_OPNOTSUPP is not described by any of the official
NFS related RFCs, but appears to have snuck into some older .x files for
NFSv2.
Either way, it is not in RFC1094, RFC1813 or any of the NFSv4 RFCs, so
should not be returned by the knfsd server, and particularly not by the
"LOOKUP" operation.

Instead, let's return NFSERR_STALE, which is more appropriate if the
filesystem encodes the filehandle as FILEID_INVALID.

Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -573,7 +573,7 @@ fh_compose(struct svc_fh *fhp, struct sv
 		_fh_update(fhp, exp, dentry);
 	if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID) {
 		fh_put(fhp);
-		return nfserr_opnotsupp;
+		return nfserr_stale;
 	}
 
 	return 0;
@@ -599,7 +599,7 @@ fh_update(struct svc_fh *fhp)
 
 	_fh_update(fhp, fhp->fh_export, dentry);
 	if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID)
-		return nfserr_opnotsupp;
+		return nfserr_stale;
 	return 0;
 out_bad:
 	printk(KERN_ERR "fh_update: fh not verified!\n");


