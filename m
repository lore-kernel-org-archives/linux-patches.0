Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6438625B09B;
	Thu,  2 Jul 2026 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011450; cv=none; b=b7zSXsFKKuMDRjiZQaPNDPEFva2GBszSJiRh1TscA/yCO6ysSPBgqjcFN5eZxsg4QNt4AqFKEwUj9PewoxQMU/0sK28R7LbjKxznYWxhdwRnH10PT+x5nlRmYMPDBtey77ELHvM9dCd1pFYaFlqZ5RP/rbQVcgIA0CQjHGIl/Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011450; c=relaxed/simple;
	bh=cx9eZGI21BGaiJDAAtjYDTuYF4X4cdxYpNKmaCdngoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjbypjbuSckHNf3mvG5zZR2+OCObOB+g7Q21FYqvU6FXPdHGwr849e1yHNy+5H9vz9HhQQ7bkFEw5rMisNbZfeQNqmjOeUtyCWQ0k+PHNOHFEHup/hmH/wfKGozpZ6zT1jAuhRfUWFoumPZm0yRLdfumy6/a1Lkgiuzh+D6/8xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4k+Z/KC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4k+Z/KC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774F21F000E9;
	Thu,  2 Jul 2026 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011449;
	bh=lLNtk5N032MZ2hcfSs51w7DV30y0/n+s+C0B6tYi3r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4k+Z/KCDLQ+EL6HKp+ATEyX6asXzo+QoyIkfuGxQrFBXfmSnb8vLedp8sQFQBVEA
	 sPCam0VInmkwtzJZE+wQ+RoL/Inot+zboSeXYnRx9kIqwdsOEUHQl4wjnvJoBBuA3Y
	 vyMG4cz/tNDEXsv480J9i1q98+oYK2JzaZ0EcoxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 101/108] NFSv4/flexfiles: reject zero filehandle version count
Date: Thu,  2 Jul 2026 18:21:38 +0200
Message-ID: <20260702155114.204437822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 2c6bb3c40bc24f6aa8dfbe6fe98c3ad6389203f2 upstream.

ff_layout_alloc_lseg() decodes the filehandle-version array count
from the flexfiles layout body. The value is used as the count for
kzalloc_objs(), and the current code only rejects NULL.

A zero count yields ZERO_SIZE_PTR, which can be stored in
dss_info->fh_versions even though later flexfiles paths assume that at
least one filehandle version exists.

Reject fh_count == 0 before the allocation, matching the existing zero
version_count validation in the flexfiles GETDEVICEINFO parser.

A QEMU/KASAN run with a malformed flexfiles layout hit:

  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:ff_layout_encode_ff_layoutupdate.isra.0+0x15f/0x750
  ff_layout_encode_layoutreturn+0x683/0x970
  nfs4_xdr_enc_layoutreturn+0x278/0x3a0
  Kernel panic - not syncing: Fatal exception

The patched kernel rejects the malformed layout without KASAN/oops/panic,
and a valid fh_count=1 regression still opens, reads, and unmounts cleanly.

Cc: stable@vger.kernel.org
Fixes: d67ae825a59d ("pnfs/flexfiles: Add the FlexFile Layout Driver")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -552,6 +552,10 @@ ff_layout_alloc_lseg(struct pnfs_layout_
 			if (!p)
 				goto out_err_free;
 			fh_count = be32_to_cpup(p);
+			if (fh_count == 0) {
+				rc = -EINVAL;
+				goto out_err_free;
+			}
 
 			dss_info->fh_versions =
 			    kcalloc(fh_count, sizeof(struct nfs_fh),


