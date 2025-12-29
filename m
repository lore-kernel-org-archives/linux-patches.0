Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C84332EDD;
	Mon, 29 Dec 2025 16:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025877; cv=none; b=aP26qPVpITjudpsxoiZ13JytEE4WpXtW7g4N/iKPxvNliOKrM9mBAJsNgwKow25KnpmBBn2uG8X238dUv1IjYzhCVHymuS1QixeHGUecvtNr4JMN3RakSqnM71R3hNgNQ002Bz9umBc6EAKu2dF5+v0nFl6do263WjiqC2keAhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025877; c=relaxed/simple;
	bh=1FGs46FClDN99ivUHNvkunqxwz5S5onoPGgETW8P0ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZ93wcUmU00fAMHJMYkg8tP7aIVCsdhztJ7AE5zpiakqIMP/spZ4iSw6FxD8ZHoQqwmtJ3cSSwsDo5R96zYi9FoMM3zZfbmrDMFrRZwQogev69I0+7NRbrR5zNVIW9HVSgxQjLyKsJSQmOiT75tc3N7GE27fb38QSlQmyGE9xSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDYbm6vG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDYbm6vG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71213C4CEF7;
	Mon, 29 Dec 2025 16:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025876;
	bh=1FGs46FClDN99ivUHNvkunqxwz5S5onoPGgETW8P0ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDYbm6vGoVPPOYgbFge8Ob8dmFvBNfi7SAsYZpoDjjR3hVDjH7bMuiZPF4k33uO1B
	 HtGEkxXn5Jin5yQqTtmQSfd37/ipYModuaAWS12cvsOR8eNW9+oyl7AajN8XPSEFbG
	 aSMrO8cPaboy8yai2nyQja35H5rfP1KTIMJyKRZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aur=C3=A9lien=20Couderc?= <aurelien.couderc2002@gmail.com>,
	Roland Mainz <roland.mainz@nrubsig.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 368/430] NFSD: NFSv4 file creation neglects setting ACL
Date: Mon, 29 Dec 2025 17:12:50 +0100
Message-ID: <20251229160737.868464094@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -67,7 +67,8 @@ static inline bool nfsd_attrs_valid(stru
 	struct iattr *iap = attrs->na_iattr;
 
 	return (iap->ia_valid || (attrs->na_seclabel &&
-		attrs->na_seclabel->len));
+		attrs->na_seclabel->len) ||
+		attrs->na_pacl || attrs->na_dpacl);
 }
 
 __be32		nfserrno (int errno);


