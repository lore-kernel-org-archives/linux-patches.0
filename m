Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CC8320CD3;
	Sat, 12 Sep 2026 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226756; cv=none; b=C/fRjzb+KKsALUZbul53eF0X9eXEivYj5AymXTd0D8vPkhxYpxCRiIJ3ga7r9zxGJhk/V+VP/CIQXLa77R6guvVHZWF+c3QCx+qyaDUCysh3eG1Xvw5Coj8/HobdlVEA3nNeUP1Ja93HhbtruxpS0Q/C+pKwlTyEEWe3TtVwjxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226756; c=relaxed/simple;
	bh=K9KDCmsGUjUX/hUVQ5VV7WCVph30Wec4HiSIzp8gPo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9q7y931uQwSOCxnG1tpNOenhsAD8bnNMOcjbPL5yjWk53JVJyfePheh4xO3Ewn6RkzqOlY+f4iUipOaBb547C4KZu9H4M7LQEc4ouJSPUyLaqtM6Va7W6wEssIFZyiqc+cQSG2WJgBh7CXMld3QlB5nPAWdCVKSpg46wzaVinU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jwxv8rbH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jwxv8rbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077231F000FF;
	Sat, 12 Sep 2026 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226754;
	bh=8XFJR1uKDk4xrG/ZXXyJmMNYUcKbwTqEFCW1lvFpoUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jwxv8rbHuMJU//o6eL8gq8QRJZs6rXP3RIoeS/T5s7pM7XJldSN4px7CZ8EAgh3e9
	 amQy2GhS3dtku9f+/8a4gECBWlsF50MR8hgvpyxCUpD6NL6HuoXO78t3KTKmW2BYcq
	 OC3NVzH2veJuhoRiQsx7ySlbDfPxzhOKZanB964A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0041/1191] NFSD: remove flawed WARN_ON_ONCE from nfsd_mode_check
Date: Sat, 12 Sep 2026 08:46:09 +0200
Message-ID: <20260912065549.058800656@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

commit aa0cf48a448c5a9fe1a1e880899ecd589ce39e6e upstream.

The header for commit e75b23f9e323 ("nfsd: check d_can_lookup in
fh_verify of directories") details the assumption that justified
adding the WARN_ON_ONCE to nfsd_mode_check(), that assumption is
invalid (in the case of NFS reexport).

When NFSD exports an NFS filesystem it is very possible for
nfsd_mode_check() to encounter a @dentry that doesn't have
i_op->lookup (see nfs_fhget()'s NFS_ATTR_FATTR_MOUNTPOINT and
NFS_ATTR_FATTR_V4_REFERRAL handling, and d_flags_for_inode()).

So remove nfsd_mode_check()'s WARN_ON_ONCE(). The nfserr_notdir
return on that branch must stay. It guards the subsequent
lookup_one_unlocked() -> __lookup_slow() path, which calls
inode->i_op->lookup() with no NULL check, so returning nfserr_notdir
is what keeps a client LOOKUP into such a @dentry from dereferencing
a NULL method pointer.

Fixes: e75b23f9e323 ("nfsd: check d_can_lookup in fh_verify of directories")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Link: https://patch.msgid.link/20260612191410.50177-1-snitzer@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -70,10 +70,8 @@ nfsd_mode_check(struct svc_rqst *rqstp,
 	if (requested == 0) /* the caller doesn't care */
 		return nfs_ok;
 	if (mode == requested) {
-		if (mode == S_IFDIR && !d_can_lookup(dentry)) {
-			WARN_ON_ONCE(1);
+		if (mode == S_IFDIR && !d_can_lookup(dentry))
 			return nfserr_notdir;
-		}
 		return nfs_ok;
 	}
 	/*


