Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C7122301;
	Thu, 16 Jul 2026 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211642; cv=none; b=hgio35OF7rRf52EdAp68VzJxQ8uHuqKqH2k1Qk5ZOlG87yDSdOzxrUT9qu7IAn6uPxb9j/p+AmGI7Xwf/GA2lj0vx1eiCjpKAhrACM1LnRo0bIhqA7JNIcz5Bjmi5P6jsYu/RnQMkUMa0jE3DFA3tu1D+jBhhiKZHFr+saul6zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211642; c=relaxed/simple;
	bh=ERQik1WL6yPGFiVWmHsoitT//eyj0pIEzAhu/hCQq4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSOHZiSlFU8DkrFtfIkhFSBFk4cAYCGjqZoV344D2aLFpDDrJaU53g0+1I2iYxMNOHpjdDomPmpSLDQUInSGIkd7ViIxGWcTLxpLAaBtrY3XyFWU9Odg1Ml0nQzi5/MJl4B8W9TBz+F3yR/fwK99Ni+zi3X3DAyk2v7GlrrbGSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQOXH/S1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQOXH/S1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300861F000E9;
	Thu, 16 Jul 2026 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211640;
	bh=c8/gSnvPpN4JCLpPegX36pmUE3JDQpo8NXoE0/zs0QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQOXH/S14a410CunY4GrvB+LrRgjIk0Eu7tB/ly0s2H+cMCtA6WwHtyBfRVYroKx/
	 VYA/mpxN2OoCBs9rSdUeB3oVFcLg26EtvZoNW0P4/uXHI8Xex6TRvGogzQV33U22pk
	 Qv5NZL1tznYm3d+KDBC/iuDFwJR5ZG+i68N8whfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/349] NFSv4/flexfiles: reject zero filehandle version count
Date: Thu, 16 Jul 2026 15:29:18 +0200
Message-ID: <20260716133033.845107785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 2c6bb3c40bc24f6aa8dfbe6fe98c3ad6389203f2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -493,6 +493,10 @@ ff_layout_alloc_lseg(struct pnfs_layout_
 		if (!p)
 			goto out_err_free;
 		fh_count = be32_to_cpup(p);
+		if (fh_count == 0) {
+			rc = -EINVAL;
+			goto out_err_free;
+		}
 
 		fls->mirror_array[i]->dss[dss_id].fh_versions =
 		    kcalloc(fh_count, sizeof(struct nfs_fh),


