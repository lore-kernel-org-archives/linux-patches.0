Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B5134E747;
	Tue,  6 Jan 2026 17:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720453; cv=none; b=hXR0kii/ur2iUqsK5a19IkiAYbKCORC6sQKqmYaHgSkI9wnsVeoDzrhKyxKObNFOoKhrUUaK/PWYB5+Y6VxjFJ8XbWYjVzZDsGMfsWTtpheXCOkaJSpJRm/wPuM1AfTvLewcQqB9gBiLUXndZbtNGs40jdLZfw4W2vWkUa8XaPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720453; c=relaxed/simple;
	bh=mjnD/iqAl6hR47feXgi1cnaCWXrcbrxkB7bekbm02Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RyKF5zG/R4bWK0rGI1bY5qDrqKYTXcUhR6pCmiUUtkFnscDQhduy6GCvewUPZxNrC/xeyYwa9c4TVBYWVwNs+RiaOS+6USbFnJH5XNDjBlHG0vCvU4sMgwKwcy8f8F88+fy991p5bflG7hhgUOcDKpNMDmcP6UTbnT/Vz82+J7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqNSBRRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqNSBRRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A660C116C6;
	Tue,  6 Jan 2026 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720453;
	bh=mjnD/iqAl6hR47feXgi1cnaCWXrcbrxkB7bekbm02Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqNSBRRL/MVx/Y/h+oAv3lCirDcviKUFHhfkEs302rjxLygSt5cyGh9SLUfLV084K
	 zE1OMyfdYsoc9DuMSbHNV5YJHkubPTaAtDkb4jN9qRTCB+Y+Vn+Ss0X/Ua5Eh2y56g
	 nAfa4i736DjD6xYbh/ndHmJAVV1Zmth98HV/TDCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aur=C3=A9lien=20Couderc?= <aurelien.couderc2002@gmail.com>,
	Roland Mainz <roland.mainz@nrubsig.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 240/567] NFSD: NFSv4 file creation neglects setting ACL
Date: Tue,  6 Jan 2026 18:00:22 +0100
Message-ID: <20260106170500.194832625@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


