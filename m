Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828937;
	b=HLsbGjqGCWEtLY0S2qy52XOhCGkEKEBAMJyC9nPkhTQbfI2VLgWHzfSIxNZczMvg9BkI
	 lqSiew1WEMNcvdWs4qEVvWl/P1m6yAZGamfqu0tGgJarrHgmXtT6tIaIbTEHJaDjum5np
	 FsUeKLrppb+JXx7Olppeq48H4mJdpYvm3A0XO/xy4Krw/uVWUvJK4vLM3p+dpphJ42xEm
	 0jFAD5IVaS259XwmqmAMMWEAVw/meeyl0zJN0vFy4aEwvA4PPC0PquvyONX0dQEkA63uv
	 W7AtUeCVEzEBzOWIzy5/nYL8xeyK2e3YIE1BABciEfklIEKWPDIgXPO6TfwOLa9yQnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k0vOKdiIijdui4n+ZkOEcTijaBq2Uk2WsckYnH/u7jM=;
	b=TC0SqdlIL5x320sGjO04JAm/HAhG864ehjojx9KGlhbXkX6CzDDs0FyfDS/nIj47Waxr
	 i4Qj749NZP2JHXgzgatrHN/GF4ZQblVKe3A0EkNAmx6cUl53lbBCZ1VRADTfW6IUB8Xx6
	 NUNnt9yGir5XMf+7av4+j4cBSikQeDr0D/i4JTXLt9cO5sLNL0KZCi8KtoTp0PPoiR58G
	 w0JJvOaTff8B1FI62zHP255EQAakrVhlHLV2JcRjFVesAqnmcgf4HPIpQJcyw5dYlhn8v
	 pPPWp3orWog/i5dDb253/aY3yGRF58W4ajmmPvdMU1vu7lhldaBV/bAcB9pzsSHKTKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytUZ34ZK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB36078730;
	Wed,  4 Nov 2026 21:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytUZ34ZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A9D1F000C1;
	Wed,  4 Nov 2026 21:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828937;
	bh=k0vOKdiIijdui4n+ZkOEcTijaBq2Uk2WsckYnH/u7jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytUZ34ZKyyWlE+jirMU2+/CyxsfRRUT2eHRE8q6eM8RSpjAR7GZHO/pghisnDGjEF
	 f4KqoPntmChhGlSwTcugg9KXiCOhUt78A9aIAMucrBCpCS2bbmHR2yNNK0YkTPxSoh
	 oKkPgxufeTl4dwsJ1TkUmdmUsxgdF+0YFuNQA3RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 337/547] xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
Date: Wed,  4 Nov 2026 16:08:41 -0500
Message-ID: <20261104211047.806352002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit fd012955641881169a9f01a00f656f6ca73842ec upstream.

LOLLM suggests that we shouldn't try to allocate absurdly large buffers
for xattr value checks because that will push reclaim very hard, never
succeed, and is pointless because nobody can create xattrs that large.
Since the xattr repair code ignores values larger than XATTR_SIZE_MAX,
we can flag the corruption and return early.

Cc: stable@vger.kernel.org # v5.3
Fixes: 6d6ccedd76823c ("xfs: only allocate memory for scrubbing attributes when we need it")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr.c          |    6 ++++++
 fs/xfs/scrub/parent_repair.c |    4 ++++
 2 files changed, 10 insertions(+)

--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -216,6 +216,12 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
+	}
+
 	/*
 	 * Try to allocate enough memory to extract the attr value.  If that
 	 * doesn't work, return -EDEADLOCK as a signal to try again with a
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -910,6 +910,10 @@ xrep_parent_fetch_xattr_remote(
 	};
 	int			error;
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX)
+		return -EFSCORRUPTED;
+
 	/*
 	 * If we need a larger value buffer, try to allocate one.  If that
 	 * fails, return with -EDEADLOCK to try harder.


