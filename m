Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F30A482DA;
	Mon,  4 Mar 2024 21:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587824; cv=none; b=To5EWLJvdCEXcvkiW5IW1+9kzn0IUfls9LY5qGFFvbtV9n74JGRfwDMgzQdcOdixUgQ5kJwY6C0RGUxIsjRrvt4dwcdySTZqc15kJaE42RVcyT+mtFK7JVQWpuCswnMeyzHL1ikq/9/pf0qkk4g7tG2wp36auhtaxpDwdPDZ6EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587824; c=relaxed/simple;
	bh=ugQh52Vqq+0XacMc8nvhOhpWZMDmHd01uf0rWV3zVK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fui2fXT9yBi8DgstWSNRsphP5ubUKFKgmsVQG1sRuoj6ixjxSM62KTuVtue6nFmKpodSdXZm+zZFOctl1IbP47doxAF3B6PpSili0kbNA4GtXxnTG9ZbwI/vEt5BdBGbNdtSczoyh7JqHeeipDFSu6yp3ip+8BF6dRmWq+Shgvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmQ8njFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmQ8njFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B0FC433C7;
	Mon,  4 Mar 2024 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587824;
	bh=ugQh52Vqq+0XacMc8nvhOhpWZMDmHd01uf0rWV3zVK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmQ8njFDb4MGWdz4148KeFtGF6fduIXNGdUKlMYpOflq8UxAunQ4MbiNpWh49EKAL
	 /nbqMeXGIqzVK7i/5fPwYPBGcayXkgE/Y/Tb5nG0Oyu6gL289RhSzOD80bloMraf3u
	 aR0TRycn5hpRARRlr6dtfv0iUpkdckJDbNV3mCO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@ibm.com>,
	Venky Shankar <vshankar@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.7 104/162] ceph: switch to corrected encoding of max_xattr_size in mdsmap
Date: Mon,  4 Mar 2024 21:22:49 +0000
Message-ID: <20240304211555.137794515@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

commit 51d31149a88b5c5a8d2d33f06df93f6187a25b4c upstream.

The addition of bal_rank_mask with encoding version 17 was merged
into ceph.git in Oct 2022 and made it into v18.2.0 release normally.
A few months later, the much delayed addition of max_xattr_size got
merged, also with encoding version 17, placed before bal_rank_mask
in the encoding -- but it didn't make v18.2.0 release.

The way this ended up being resolved on the MDS side is that
bal_rank_mask will continue to be encoded in version 17 while
max_xattr_size is now encoded in version 18.  This does mean that
older kernels will misdecode version 17, but this is also true for
v18.2.0 and v18.2.1 clients in userspace.

The best we can do is backport this adjustment -- see ceph.git
commit 78abfeaff27fee343fb664db633de5b221699a73 for details.

[ idryomov: changelog ]

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/64440
Fixes: d93231a6bc8a ("ceph: prevent a client from exceeding the MDS maximum xattr size")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@ibm.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mdsmap.c |    7 ++++---
 fs/ceph/mdsmap.h |    6 +++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -380,10 +380,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(s
 		ceph_decode_skip_8(p, end, bad_ext);
 		/* required_client_features */
 		ceph_decode_skip_set(p, end, 64, bad_ext);
+		/* bal_rank_mask */
+		ceph_decode_skip_string(p, end, bad_ext);
+	}
+	if (mdsmap_ev >= 18) {
 		ceph_decode_64_safe(p, end, m->m_max_xattr_size, bad_ext);
-	} else {
-		/* This forces the usage of the (sync) SETXATTR Op */
-		m->m_max_xattr_size = 0;
 	}
 bad_ext:
 	doutc(cl, "m_enabled: %d, m_damaged: %d, m_num_laggy: %d\n",
--- a/fs/ceph/mdsmap.h
+++ b/fs/ceph/mdsmap.h
@@ -27,7 +27,11 @@ struct ceph_mdsmap {
 	u32 m_session_timeout;          /* seconds */
 	u32 m_session_autoclose;        /* seconds */
 	u64 m_max_file_size;
-	u64 m_max_xattr_size;		/* maximum size for xattrs blob */
+	/*
+	 * maximum size for xattrs blob.
+	 * Zeroed by default to force the usage of the (sync) SETXATTR Op.
+	 */
+	u64 m_max_xattr_size;
 	u32 m_max_mds;			/* expected up:active mds number */
 	u32 m_num_active_mds;		/* actual up:active mds number */
 	u32 possible_max_rank;		/* possible max rank index */


