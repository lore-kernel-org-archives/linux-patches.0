Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FC039A805;
	Thu, 15 Jan 2026 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496818; cv=none; b=Tq35KppIBFuP2CxGjZkKfCsIVfnyt0BkbyYu0Y18PCgBGKfmY1kJyAfr6lS96mdRpg+CJQmaeGvhBLa7Zwwdms5wlaOdsDLJjnvte7bt+MmnmvdOZkfb0Hc/wuSVoFUkrkbW/FGvRvvpNLzxMtzD5EQ8Kb2cixLKj20nrUirZrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496818; c=relaxed/simple;
	bh=HHehmisEcZUvQyGrXDFzI0OpKnMxiAcXH/7fZsGLSgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDcca7solOevw+D1sTllHS5ZgC6yEBKfEbSYC2JV+G0fvNJupBQHNLLW+6Aln3TUdRGH9/3/UDU7AwyUrwgnIlg+k0GUANkluy4wu0KN2ecARDlOyY4rcbhHd5Zisj38VnvrCh1iS0pW2MosBHDfaIzAFq9lIbvqmZXMwaEqTXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yen8JWYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yen8JWYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684F3C116D0;
	Thu, 15 Jan 2026 17:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496818;
	bh=HHehmisEcZUvQyGrXDFzI0OpKnMxiAcXH/7fZsGLSgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yen8JWYnlejHdIftbzNkMcIdjiGdjhHYRo4bk+L8Jj3/XDqEMSn1JXkPiHQXd4/lT
	 fYfdwSW+Vtmsp9K/9WNrZfVUMv/a+jr8jySGtBPQr44lYUl67KTyUdrcws1saCa+SJ
	 +NXz317omGg62T1bzayP3wV2/WZVw+AwqZ4t/Tt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aur=C3=A9lien=20Couderc?= <aurelien.couderc2002@gmail.com>,
	Roland Mainz <roland.mainz@nrubsig.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 26/88] NFSD: NFSv4 file creation neglects setting ACL
Date: Thu, 15 Jan 2026 17:48:09 +0100
Message-ID: <20260115164147.259770740@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 913f7cf77bf14c13cfea70e89bcb6d0b22239562 upstream.

An NFSv4 client that sets an ACL with a named principal during file
creation retrieves the ACL afterwards, and finds that it is only a
default ACL (based on the mode bits) and not the ACL that was
requested during file creation. This violates RFC 8881 section
6.4.1.3: "the ACL attribute is set as given".

The issue occurs in nfsd_create_setattr(), which calls
nfsd_attrs_valid() to determine whether to call nfsd_setattr().
However, nfsd_attrs_valid() checks only for iattr changes and
security labels, but not POSIX ACLs. When only an ACL is present,
the function returns false, nfsd_setattr() is skipped, and the
POSIX ACL is never applied to the inode.

Subsequently, when the client retrieves the ACL, the server finds
no POSIX ACL on the inode and returns one generated from the file's
mode bits rather than returning the originally-specified ACL.

Reported-by: Aurélien Couderc <aurelien.couderc2002@gmail.com>
Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: Roland Mainz <roland.mainz@nrubsig.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -65,7 +65,8 @@ static inline bool nfsd_attrs_valid(stru
 	struct iattr *iap = attrs->na_iattr;
 
 	return (iap->ia_valid || (attrs->na_seclabel &&
-		attrs->na_seclabel->len));
+		attrs->na_seclabel->len) ||
+		attrs->na_pacl || attrs->na_dpacl);
 }
 
 __be32		nfserrno (int errno);


