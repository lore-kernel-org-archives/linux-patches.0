Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD7446EF88;
	Tue, 21 Jul 2026 20:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664737; cv=none; b=XQjPpCrBtjh2uiJ/xPYa/Y8WN9hKK8TOUb9KyofCW5gS2pAcn3yZTGRDb3zXczynS7LgNwUsuCp/VFkHizbFJCYuME3Byjszcval4ddkdIjxsUGLj9wbeLA5JwwHxexQWq6fGNly3tm1ICpffKGAEVrgH8jfGGry/Za35lD7B4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664737; c=relaxed/simple;
	bh=Vzgv3DdbkO6bR2DiunuLD2hB87Pf3H7SsBX8gyc8ocs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R75yAEBkNuf8aaaSyOkREgXYEmpH9W27lhfooZuKDIkwFbDA2u7TnqfYWad1jmSGLA9BXG+ek+7D9IeI8kOw8G/Suf9LFITAhxQhn4q7TAOcheinATomqFAHgOJkd1H2zq9jYTuKK5c86pe5XkeKWp2/ng34sqFhBNpR57NeG8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyntcW+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyntcW+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F180E1F000E9;
	Tue, 21 Jul 2026 20:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664735;
	bh=REbazdsZp5kVPZQWfvtSrsTXcWTwpLExA1765wXJfNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EyntcW+Hph7OAiFREWTrF/m99hW2q6XQ7uJWMOUGFsvgTpeTh0YMKwZbYSASi5+Tt
	 tpX4fe/MtARXE+GtBS9EOAQ0ZNPT+d5MaetB8XWA2uCBuEbJT1HGqjyPD0HB4J2grp
	 lRpbe5vGfEPr+WwZRoqinF71dik9Tq+lWUDwu0xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0038/1266] NFSv4/flexfiles: reject zero filehandle version count
Date: Tue, 21 Jul 2026 17:07:55 +0200
Message-ID: <20260721152442.653945050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -460,6 +460,10 @@ ff_layout_alloc_lseg(struct pnfs_layout_
 		if (!p)
 			goto out_err_free;
 		fh_count = be32_to_cpup(p);
+		if (fh_count == 0) {
+			rc = -EINVAL;
+			goto out_err_free;
+		}
 
 		fls->mirror_array[i]->fh_versions =
 			kcalloc(fh_count, sizeof(struct nfs_fh),


